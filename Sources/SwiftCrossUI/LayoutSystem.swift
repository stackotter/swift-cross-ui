public enum LayoutSystem {
    public struct LayoutableChild {
        private var update:
            (
                _ proposedSize: SIMD2<Int>,
                _ environment: EnvironmentValues,
                _ dryRun: Bool
            ) -> ViewSize

        public init(update: @escaping (SIMD2<Int>, EnvironmentValues, Bool) -> ViewSize) {
            self.update = update
        }

        public func update(
            proposedSize: SIMD2<Int>,
            environment: EnvironmentValues,
            dryRun: Bool = false
        ) -> ViewSize {
            update(proposedSize, environment, dryRun)
        }

        public func computeSize(
            proposedSize: SIMD2<Int>,
            environment: EnvironmentValues
        ) -> ViewSize {
            update(proposedSize, environment, true)
        }
    }

    /// - Parameter inheritStackLayoutParticipation: If `true`, the stack layout
    ///   will have ``ViewSize/participateInStackLayoutsWhenEmpty`` set to `true`
    ///   if all of its children have it set to true. This allows views such as
    ///   ``Group`` to avoid changing stack layout participation (since ``Group``
    ///   is meant to appear completely invisible to the layout system).
    public static func updateStackLayout<Backend: AppBackend>(
        container: Backend.Widget,
        children: [LayoutableChild],
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool,
        inheritStackLayoutParticipation: Bool = false
    ) -> ViewSize {
        let spacing = environment.layoutSpacing
        let alignment = environment.layoutAlignment
        let orientation = environment.layoutOrientation

        var renderedChildren = [ViewSize](
            repeating: .empty,
            count: children.count
        )

        // Figure out which views to treat as hidden. This could be the cause
        // of issues if a view has some threshold at which it suddenly becomes
        // invisible.
        var isHidden = [Bool](repeating: false, count: children.count)
        for (i, child) in children.enumerated() {
            let size = child.computeSize(
                proposedSize: proposedSize,
                environment: environment
            )
            isHidden[i] =
                size.size == .zero
                && !size.participateInStackLayoutsWhenEmpty
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
            let size = child.computeSize(
                proposedSize: proposedSizeWithoutSpacing,
                environment: environment
            )
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
                let size = child.update(
                    proposedSize: .zero,
                    environment: environment,
                    dryRun: dryRun
                )
                if size.size != .zero || size.participateInStackLayoutsWhenEmpty {
                    print("warning: Hidden view became visible on second update. Layout may break.")
                }
                renderedChildren[index] = .hidden
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

            let childSize = child.update(
                proposedSize: SIMD2<Int>(
                    Int(proposedWidth.rounded(.towardZero)),
                    Int(proposedHeight.rounded(.towardZero))
                ),
                environment: environment,
                dryRun: dryRun
            )

            renderedChildren[index] = childSize
            childrenRemaining -= 1

            switch orientation {
                case .horizontal:
                    spaceUsedAlongStackAxis += childSize.size.x
                case .vertical:
                    spaceUsedAlongStackAxis += childSize.size.y
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
                    renderedChildren.map(\.size.x).reduce(0, +) + totalSpacing,
                    renderedChildren.map(\.size.y).max() ?? 0
                )
                idealSize = SIMD2<Int>(
                    renderedChildren.map(\.idealSize.x).reduce(0, +) + totalSpacing,
                    renderedChildren.map(\.idealSize.y).max() ?? 0
                )
                minimumWidth = renderedChildren.map(\.minimumWidth).reduce(0, +) + totalSpacing
                minimumHeight = renderedChildren.map(\.minimumHeight).max() ?? 0
                maximumWidth =
                    renderedChildren.map(\.maximumWidth).reduce(0, +) + Double(totalSpacing)
                maximumHeight = renderedChildren.map(\.maximumHeight).max()
                idealWidthForProposedHeight =
                    renderedChildren.map(\.idealWidthForProposedHeight).reduce(0, +) + totalSpacing
                idealHeightForProposedWidth =
                    renderedChildren.map(\.idealHeightForProposedWidth).max() ?? 0
            case .vertical:
                size = SIMD2<Int>(
                    renderedChildren.map(\.size.x).max() ?? 0,
                    renderedChildren.map(\.size.y).reduce(0, +) + totalSpacing
                )
                idealSize = SIMD2<Int>(
                    renderedChildren.map(\.idealSize.x).max() ?? 0,
                    renderedChildren.map(\.idealSize.y).reduce(0, +) + totalSpacing
                )
                minimumWidth = renderedChildren.map(\.minimumWidth).max() ?? 0
                minimumHeight = renderedChildren.map(\.minimumHeight).reduce(0, +) + totalSpacing
                maximumWidth = renderedChildren.map(\.maximumWidth).max()
                maximumHeight =
                    renderedChildren.map(\.maximumHeight).reduce(0, +) + Double(totalSpacing)
                idealWidthForProposedHeight =
                    renderedChildren.map(\.idealWidthForProposedHeight).max() ?? 0
                idealHeightForProposedWidth =
                    renderedChildren.map(\.idealHeightForProposedWidth).reduce(0, +) + totalSpacing
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
                        x = (size.x - childSize.size.x) / 2
                    case (.horizontal, .center):
                        y = (size.y - childSize.size.y) / 2
                    case (.vertical, .trailing):
                        x = (size.x - childSize.size.x)
                    case (.horizontal, .trailing):
                        y = (size.y - childSize.size.y)
                }

                backend.setPosition(ofChildAt: index, in: container, to: SIMD2<Int>(x, y))

                switch orientation {
                    case .horizontal:
                        x += childSize.size.x + spacing
                    case .vertical:
                        y += childSize.size.y + spacing
                }
            }
        }

        // If the stack has been told to inherit its stack layout participation
        // and all of its children are hidden, then the stack itself also
        // shouldn't participate in stack layouts.
        let shouldGetIgnoredInStackLayouts =
            inheritStackLayoutParticipation && isHidden.allSatisfy { $0 }
        return ViewSize(
            size: size,
            idealSize: idealSize,
            idealWidthForProposedHeight: idealWidthForProposedHeight,
            idealHeightForProposedWidth: idealHeightForProposedWidth,
            minimumWidth: minimumWidth,
            minimumHeight: minimumHeight,
            maximumWidth: maximumWidth,
            maximumHeight: maximumHeight,
            participateInStackLayoutsWhenEmpty: !shouldGetIgnoredInStackLayouts
        )
    }
}
