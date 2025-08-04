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
        private var update:
            @MainActor (
                _ proposedSize: SIMD2<Int>,
                _ environment: EnvironmentValues,
                _ dryRun: Bool
            ) -> ViewUpdateResult
        var tag: String?

        public init(
            update: @escaping @MainActor (SIMD2<Int>, EnvironmentValues, Bool) -> ViewUpdateResult,
            tag: String? = nil
        ) {
            self.update = update
            self.tag = tag
        }

        @MainActor
        public func update(
            proposedSize: SIMD2<Int>,
            environment: EnvironmentValues,
            dryRun: Bool = false
        ) -> ViewUpdateResult {
            update(proposedSize, environment, dryRun)
        }
    }

    /// - Parameter inheritStackLayoutParticipation: If `true`, the stack layout
    ///   will have ``ViewSize/participateInStackLayoutsWhenEmpty`` set to `true`
    ///   if all of its children have it set to true. This allows views such as
    ///   ``Group`` to avoid changing stack layout participation (since ``Group``
    ///   is meant to appear completely invisible to the layout system).
    @MainActor
    public static func updateStackLayout<Backend: AppBackend>(
        container: Backend.Widget,
        children: [LayoutableChild],
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool,
        inheritStackLayoutParticipation: Bool = false
    ) -> ViewUpdateResult {
        let spacing = environment.layoutSpacing
        let alignment = environment.layoutAlignment
        let orientation = environment.layoutOrientation

        var renderedChildren: [ViewUpdateResult] = Array(
            repeating: ViewUpdateResult.leafView(size: .empty),
            count: children.count
        )

        // Figure out which views to treat as hidden. This could be the cause
        // of issues if a view has some threshold at which it suddenly becomes
        // invisible.
        var isHidden = [Bool](repeating: false, count: children.count)
        for (i, child) in children.enumerated() {
            let result = child.update(
                proposedSize: proposedSize,
                environment: environment,
                dryRun: true
            )
            isHidden[i] = !result.participatesInStackLayouts
        }

        // My thanks go to this great article for investigating and explaining
        // how SwiftUI determines child view 'flexibility':
        // https://www.objc.io/blog/2020/11/10/hstacks-child-ordering/
        let visibleChildrenCount = isHidden.filter { hidden in
            !hidden
        }.count
        let totalSpacing = max(visibleChildrenCount - 1, 0) * spacing
        let proposedSizeWithoutSpacing = SIMD2(
            proposedSize.x - (orientation == .horizontal ? totalSpacing : 0),
            proposedSize.y - (orientation == .vertical ? totalSpacing : 0)
        )
        let flexibilities = children.map { child in
            let size = child.update(
                proposedSize: proposedSizeWithoutSpacing,
                environment: environment,
                dryRun: true
            ).size
            return switch orientation {
                case .horizontal:
                    size.maximumWidth - Double(size.minimumWidth)
                case .vertical:
                    size.maximumHeight - Double(size.minimumHeight)
            }
        }
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
                let result = child.update(
                    proposedSize: .zero,
                    environment: environment,
                    dryRun: dryRun
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

            let childResult = child.update(
                proposedSize: SIMD2<Int>(
                    Int(proposedWidth.rounded(.towardZero)),
                    Int(proposedHeight.rounded(.towardZero))
                ),
                environment: environment,
                dryRun: dryRun
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

        if !dryRun {
            backend.setSize(of: container, to: size)

            var x = 0
            var y = 0
            for (index, childSize) in renderedChildren.enumerated() {
                // Avoid the whole iteration if the child is hidden. If there
                // are weird positioning issues for views that do strange things
                // then this could be the cause.
                if isHidden[index] {
                    continue
                }

                // Compute alignment
                switch (orientation, alignment) {
                    case (.vertical, .leading):
                        x = 0
                    case (.horizontal, .leading):
                        y = 0
                    case (.vertical, .center):
                        x = (size.x - childSize.size.size.x) / 2
                    case (.horizontal, .center):
                        y = (size.y - childSize.size.size.y) / 2
                    case (.vertical, .trailing):
                        x = (size.x - childSize.size.size.x)
                    case (.horizontal, .trailing):
                        y = (size.y - childSize.size.size.y)
                }

                backend.setPosition(ofChildAt: index, in: container, to: SIMD2<Int>(x, y))

                switch orientation {
                    case .horizontal:
                        x += childSize.size.size.x + spacing
                    case .vertical:
                        y += childSize.size.size.y + spacing
                }
            }
        }

        // If the stack has been told to inherit its stack layout participation
        // and all of its children are hidden, then the stack itself also
        // shouldn't participate in stack layouts.
        let shouldGetIgnoredInStackLayouts =
            inheritStackLayoutParticipation && isHidden.allSatisfy { $0 }

        return ViewUpdateResult(
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
}
