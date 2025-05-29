public enum LayoutSystem {
    static func width(forHeight height: Int, aspectRatio: Double) -> Int {
        roundSize(Double(height) * aspectRatio)
    }

    static func height(forWidth width: Int, aspectRatio: Double) -> Int {
        roundSize(Double(width) / aspectRatio)
    }

    static func roundSize(_ size: Double) -> Int {
        Int(size.rounded(.towardZero))
    }

    static func aspectRatio(of frame: SIMD2<Double>) -> Double {
        if frame.x == 0 || frame.y == 0 {
            // Even though we could technically compute an aspect ratio when the
            // ideal width is 0, it leads to a lot of annoying usecases and isn't
            // very meaningful, so we default to 1 in that case as well as the
            // division by zero case.
            return 1
        } else {
            return frame.x / frame.y
        }
    }

    static func frameSize(
        forProposedSize proposedSize: SIMD2<Int>,
        aspectRatio: Double,
        contentMode: ContentMode
    ) -> SIMD2<Int> {
        let widthForHeight = width(forHeight: proposedSize.y, aspectRatio: aspectRatio)
        let heightForWidth = height(forWidth: proposedSize.x, aspectRatio: aspectRatio)
        switch contentMode {
            case .fill:
                return SIMD2(
                    max(proposedSize.x, widthForHeight),
                    max(proposedSize.y, heightForWidth)
                )
            case .fit:
                return SIMD2(
                    min(proposedSize.x, widthForHeight),
                    min(proposedSize.y, heightForWidth)
                )
        }
    }

    public struct LayoutableChild {
        private var computeLayout:
            @MainActor (
                _ proposedSize: SIMD2<Int>,
                _ environment: EnvironmentValues
            ) -> ViewLayoutResult
        private var _commit: @MainActor () -> ViewLayoutResult
        var tag: String?

        public init(
            computeLayout: @escaping @MainActor (SIMD2<Int>, EnvironmentValues) -> ViewLayoutResult,
            commit: @escaping @MainActor () -> ViewLayoutResult,
            tag: String? = nil
        ) {
            self.computeLayout = computeLayout
            self._commit = commit
            self.tag = tag
        }

        @MainActor
        public func computeLayout(
            proposedSize: SIMD2<Int>,
            environment: EnvironmentValues,
            dryRun: Bool = false
        ) -> ViewLayoutResult {
            computeLayout(proposedSize, environment)
        }

        @MainActor
        public func commit() -> ViewLayoutResult {
            _commit()
        }
    }

    /// - Parameter inheritStackLayoutParticipation: If `true`, the stack layout
    ///   will have ``ViewSize/participateInStackLayoutsWhenEmpty`` set to `true`
    ///   if all of its children have it set to true. This allows views such as
    ///   ``Group`` to avoid changing stack layout participation (since ``Group``
    ///   is meant to appear completely invisible to the layout system).
    @MainActor
    public static func computeStackLayout<Backend: AppBackend>(
        container: Backend.Widget,
        children: [LayoutableChild],
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        inheritStackLayoutParticipation: Bool = false
    ) -> ViewLayoutResult {
        let spacing = environment.layoutSpacing
        let orientation = environment.layoutOrientation

        var renderedChildren: [ViewLayoutResult] = Array(
            repeating: ViewLayoutResult.leafView(size: .empty),
            count: children.count
        )

        // My thanks go to this great article for investigating and explaining
        // how SwiftUI determines child view 'flexibility':
        // https://www.objc.io/blog/2020/11/10/hstacks-child-ordering/
        var isHidden = [Bool](repeating: false, count: children.count)
        let flexibilities = children.enumerated().map { i, child in
            let result = child.computeLayout(
                proposedSize: proposedSize,
                environment: environment
            )
            isHidden[i] = !result.participatesInStackLayouts
            return switch orientation {
                case .horizontal:
                    result.size.maximumWidth - Double(result.size.minimumWidth)
                case .vertical:
                    result.size.maximumHeight - Double(result.size.minimumHeight)
            }
        }
        let visibleChildrenCount = isHidden.filter { hidden in
            !hidden
        }.count
        let totalSpacing = max(visibleChildrenCount - 1, 0) * spacing
        let sortedChildren = zip(children.enumerated(), flexibilities)
            .sorted { first, second in
                first.1 <= second.1
            }
            .map(\.0)

        var spaceUsedAlongStackAxis = 0
        var childrenRemaining = visibleChildrenCount
        for (index, child) in sortedChildren {
            // No need to render visible children.
            if isHidden[index] {
                // Update child in case it has just changed from visible to hidden,
                // and to make sure that the view is still hidden (if it's not then
                // it's a bug with either the view or the layout system).
                let result = child.computeLayout(
                    proposedSize: .zero,
                    environment: environment
                )
                if result.participatesInStackLayouts {
                    print(
                        """
                        warning: Hidden view became visible on second update. \
                        Layout may break. View: \(child.tag ?? "<unknown type>")
                        """
                    )
                }
                renderedChildren[index] = result
                renderedChildren[index].size = .hidden
                continue
            }

            let proposedWidth: Double
            let proposedHeight: Double
            switch orientation {
                case .horizontal:
                    proposedWidth =
                        Double(max(proposedSize.x - spaceUsedAlongStackAxis - totalSpacing, 0))
                        / Double(childrenRemaining)
                    proposedHeight = Double(proposedSize.y)
                case .vertical:
                    proposedHeight =
                        Double(max(proposedSize.y - spaceUsedAlongStackAxis - totalSpacing, 0))
                        / Double(childrenRemaining)
                    proposedWidth = Double(proposedSize.x)
            }

            let childResult = child.computeLayout(
                proposedSize: SIMD2<Int>(
                    Int(proposedWidth.rounded(.towardZero)),
                    Int(proposedHeight.rounded(.towardZero))
                ),
                environment: environment
            )

            renderedChildren[index] = childResult
            childrenRemaining -= 1

            switch orientation {
                case .horizontal:
                    spaceUsedAlongStackAxis += childResult.size.size.x
                case .vertical:
                    spaceUsedAlongStackAxis += childResult.size.size.y
            }
        }

        let size: SIMD2<Int>
        let idealSize: SIMD2<Int>
        let idealWidthForProposedHeight: Int
        let idealHeightForProposedWidth: Int
        let minimumWidth: Int
        let minimumHeight: Int
        let maximumWidth: Double?
        let maximumHeight: Double?
        switch orientation {
            case .horizontal:
                size = SIMD2<Int>(
                    renderedChildren.map(\.size.size.x).reduce(0, +) + totalSpacing,
                    renderedChildren.map(\.size.size.y).max() ?? 0
                )
                idealSize = SIMD2<Int>(
                    renderedChildren.map(\.size.idealSize.x).reduce(0, +) + totalSpacing,
                    renderedChildren.map(\.size.idealSize.y).max() ?? 0
                )
                minimumWidth = renderedChildren.map(\.size.minimumWidth).reduce(0, +) + totalSpacing
                minimumHeight = renderedChildren.map(\.size.minimumHeight).max() ?? 0
                maximumWidth =
                    renderedChildren.map(\.size.maximumWidth).reduce(0, +) + Double(totalSpacing)
                maximumHeight = renderedChildren.map(\.size.maximumHeight).max()
                idealWidthForProposedHeight =
                    renderedChildren.map(\.size.idealWidthForProposedHeight).reduce(0, +)
                    + totalSpacing
                idealHeightForProposedWidth =
                    renderedChildren.map(\.size.idealHeightForProposedWidth).max() ?? 0
            case .vertical:
                size = SIMD2<Int>(
                    renderedChildren.map(\.size.size.x).max() ?? 0,
                    renderedChildren.map(\.size.size.y).reduce(0, +) + totalSpacing
                )
                idealSize = SIMD2<Int>(
                    renderedChildren.map(\.size.idealSize.x).max() ?? 0,
                    renderedChildren.map(\.size.idealSize.y).reduce(0, +) + totalSpacing
                )
                minimumWidth = renderedChildren.map(\.size.minimumWidth).max() ?? 0
                minimumHeight =
                    renderedChildren.map(\.size.minimumHeight).reduce(0, +) + totalSpacing
                maximumWidth = renderedChildren.map(\.size.maximumWidth).max()
                maximumHeight =
                    renderedChildren.map(\.size.maximumHeight).reduce(0, +) + Double(totalSpacing)
                idealWidthForProposedHeight =
                    renderedChildren.map(\.size.idealWidthForProposedHeight).max() ?? 0
                idealHeightForProposedWidth =
                    renderedChildren.map(\.size.idealHeightForProposedWidth).reduce(0, +)
                    + totalSpacing
        }

        // If the stack has been told to inherit its stack layout participation
        // and all of its children are hidden, then the stack itself also
        // shouldn't participate in stack layouts.
        let shouldGetIgnoredInStackLayouts =
            inheritStackLayoutParticipation && isHidden.allSatisfy { $0 }

        return ViewLayoutResult(
            size: ViewSize(
                size: size,
                idealSize: idealSize,
                idealWidthForProposedHeight: idealWidthForProposedHeight,
                idealHeightForProposedWidth: idealHeightForProposedWidth,
                minimumWidth: minimumWidth,
                minimumHeight: minimumHeight,
                maximumWidth: maximumWidth,
                maximumHeight: maximumHeight,
                participateInStackLayoutsWhenEmpty: !shouldGetIgnoredInStackLayouts
            ),
            childResults: renderedChildren
        )
    }

    @MainActor
    public static func commitStackLayout<Backend: AppBackend>(
        container: Backend.Widget,
        children: [LayoutableChild],
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        let size = layout.size.size
        backend.setSize(of: container, to: size)

        let renderedChildren = children.map { $0.commit() }

        let alignment = environment.layoutAlignment
        let spacing = environment.layoutSpacing
        let orientation = environment.layoutOrientation

        var x = 0
        var y = 0
        for (index, child) in renderedChildren.enumerated() {
            // Avoid the whole iteration if the child is hidden. If there
            // are weird positioning issues for views that do strange things
            // then this could be the cause.
            if !child.participatesInStackLayouts {
                continue
            }

            // Compute alignment
            switch (orientation, alignment) {
                case (.vertical, .leading):
                    x = 0
                case (.horizontal, .leading):
                    y = 0
                case (.vertical, .center):
                    x = (size.x - child.size.size.x) / 2
                case (.horizontal, .center):
                    y = (size.y - child.size.size.y) / 2
                case (.vertical, .trailing):
                    x = (size.x - child.size.size.x)
                case (.horizontal, .trailing):
                    y = (size.y - child.size.size.y)
            }

            backend.setPosition(ofChildAt: index, in: container, to: SIMD2<Int>(x, y))

            switch orientation {
                case .horizontal:
                    x += child.size.size.x + spacing
                case .vertical:
                    y += child.size.size.y + spacing
            }
        }
    }
}
