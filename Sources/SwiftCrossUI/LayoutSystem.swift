public enum LayoutSystem {
    public struct LayoutableChild {
        private var update:
            (
                _ proposedSize: SIMD2<Int>,
                _ environment: Environment,
                _ dryRun: Bool
            ) -> ViewUpdateResult

        public init(update: @escaping (SIMD2<Int>, Environment, Bool) -> ViewUpdateResult) {
            self.update = update
        }

        public func update(
            proposedSize: SIMD2<Int>,
            environment: Environment,
            dryRun: Bool = false
        ) -> ViewUpdateResult {
            update(proposedSize, environment, dryRun)
        }

        public func computeSize(
            proposedSize: SIMD2<Int>,
            environment: Environment
        ) -> ViewUpdateResult {
            update(proposedSize, environment, true)
        }
    }

    public static func updateStackLayout<Backend: AppBackend>(
        container: Backend.Widget,
        children: [LayoutableChild],
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let spacing = environment.layoutSpacing
        let alignment = environment.layoutAlignment
        let orientation = environment.layoutOrientation
        let totalSpacing = (children.count - 1) * spacing

        var spaceUsedAlongStackAxis = 0
        var childrenRemaining = children.count

        var renderedChildren = [ViewUpdateResult](
            repeating: .empty,
            count: children.count
        )

        // TODO: Find a better notion of 'flexibility', will probably require knowing a view's
        //   maximum size, not just its minimum size.
        let proposedSizeWithoutSpacing = SIMD2(
            proposedSize.x - (orientation == .horizontal ? totalSpacing : 0),
            proposedSize.y - (orientation == .vertical ? totalSpacing : 0)
        )
        let minimumSizes = children.map { child in
            let size = child.computeSize(
                proposedSize: proposedSizeWithoutSpacing,
                environment: environment
            )
            return switch orientation {
                case .horizontal:
                    size.minimumWidth
                case .vertical:
                    size.minimumHeight
            }
        }
        let sortedChildren = zip(children.enumerated(), minimumSizes).sorted { first, second in
            first.1 >= second.1
        }.map(\.0)

        for (index, child) in sortedChildren {
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
        let minimumWidth: Int
        let minimumHeight: Int
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
        }

        if !dryRun {
            backend.setSize(of: container, to: size)

            var x = 0
            var y = 0
            for (index, childSize) in renderedChildren.enumerated() {
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

        return ViewUpdateResult(
            size: size,
            idealSize: idealSize,
            minimumWidth: minimumWidth,
            minimumHeight: minimumHeight
        )
    }
}
