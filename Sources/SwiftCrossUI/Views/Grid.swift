/// A view that arranges subviews in a flexible grid layout.
public struct Grid<Content: View>: View {
    let alignment: Alignment
    let horizontalSpacing: Int?
    let verticalSpacing: Int?
    let content: () -> Content

    public init(
        alignment: Alignment = .center,
        horizontalSpacing: Int? = nil,
        verticalSpacing: Int? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            content()
        }
    }
}

/// A single row within a Grid.
public struct GridRow<Content: View>: View {
    let alignment: VerticalAlignment
    let content: () -> Content

    public init(
        alignment: VerticalAlignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        HStack(alignment: alignment) {
            content()
        }
    }
}
