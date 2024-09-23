public enum LayoutSystem {
    public struct LayoutableChild {
        private var update:
            (
                _ proposedSize: SIMD2<Int>,
                _ environment: Environment,
                _ dryRun: Bool
            ) -> ViewSize

        public init(update: @escaping (SIMD2<Int>, Environment, Bool) -> ViewSize) {
            self.update = update
        }

        public func update(
            proposedSize: SIMD2<Int>,
            environment: Environment,
            dryRun: Bool = false
        ) -> ViewSize {
            update(proposedSize, environment, dryRun)
        }

        public func computeSize(
            proposedSize: SIMD2<Int>,
            environment: Environment
        ) -> ViewSize {
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
    ) -> ViewSize {
        let spacing = environment.layoutSpacing
        let alignment = environment.layoutAlignment
        let orientation = environment.layoutOrientation
        let totalSpacing = (children.count - 1) * spacing

        var spaceUsedAlongStackAxis = 0
        var childrenRemaining = children.count

        var renderedChildren = [ViewSize](
            repeating: .empty,
            count: children.count
        )

        // My thanks go to this great article for investigating and explaining how SwiftUI determines
        // child view 'flexibility': https://www.objc.io/blog/2020/11/10/hstacks-child-ordering/
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
        let sortedChildren = zip(children.enumerated(), flexibilities).sorted { first, second in
            first.1 <= second.1
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

        return ViewSize(
            size: size,
            idealSize: idealSize,
            minimumWidth: minimumWidth,
            minimumHeight: minimumHeight,
            maximumWidth: maximumWidth,
            maximumHeight: maximumHeight
        )
    }
}
