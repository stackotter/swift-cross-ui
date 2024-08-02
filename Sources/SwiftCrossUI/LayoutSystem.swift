public enum LayoutSystem {
    public struct LayoutableChild {
        public var flexibility: Int
        public var update:
            (
                _ proposedSize: SIMD2<Int>,
                _ parentOrientation: Orientation
            ) -> SIMD2<Int>

        public init(
            flexibility: Int,
            update: @escaping (SIMD2<Int>, Orientation) -> SIMD2<Int>
        ) {
            self.flexibility = flexibility
            self.update = update
        }
    }

    public static func updateStackLayout<Backend: AppBackend>(
        container: Backend.Widget,
        children: [LayoutableChild],
        proposedSize: SIMD2<Int>,
        orientation: Orientation,
        alignment: StackAlignment,
        spacing: Int = 10,
        backend: Backend
    ) -> SIMD2<Int> {
        let totalSpacing = (children.count - 1) * spacing

        var spaceUsedAlongStackAxis = 0
        var childrenRemaining = children.count

        var renderedChildren = [SIMD2<Int>](
            repeating: .zero,
            count: children.count
        )

        let sortedChildren = children.enumerated().sorted { first, second in
            first.element.flexibility <= second.element.flexibility
        }

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
                SIMD2<Int>(
                    Int(proposedWidth.rounded(.towardZero)),
                    Int(proposedHeight.rounded(.towardZero))
                ),
                orientation
            )

            renderedChildren[index] = childSize
            childrenRemaining -= 1

            switch orientation {
                case .horizontal:
                    spaceUsedAlongStackAxis += childSize.x
                case .vertical:
                    spaceUsedAlongStackAxis += childSize.y
            }
        }

        let size: SIMD2<Int>
        switch orientation {
            case .horizontal:
                size = SIMD2<Int>(
                    renderedChildren.map(\.x).reduce(0, +) + totalSpacing,
                    renderedChildren.map(\.y).max() ?? 0
                )
            case .vertical:
                size = SIMD2<Int>(
                    renderedChildren.map(\.x).max() ?? 0,
                    renderedChildren.map(\.y).reduce(0, +) + totalSpacing
                )
        }

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
                    x = (size.x - childSize.x) / 2
                case (.horizontal, .center):
                    y = (size.y - childSize.y) / 2
                case (.vertical, .trailing):
                    x = (size.x - childSize.x)
                case (.horizontal, .trailing):
                    y = (size.y - childSize.y)
            }

            backend.setPosition(ofChildAt: index, in: container, to: SIMD2<Int>(x, y))

            switch orientation {
                case .horizontal:
                    x += childSize.x + spacing
                case .vertical:
                    y += childSize.y + spacing
            }
        }

        return size
    }
}
