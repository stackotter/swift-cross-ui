extension View {
    public func padding(_ amount: Int) -> PaddingView<ViewContent1<Self>> {
        let padding = Padding(amount)
        return PaddingView(ViewContent1(self), padding)
    }

    public func padding(
        _ side: Side,
        _ amount: Int
    ) -> PaddingView<ViewContent1<Self>> {
        var padding = Padding()
        padding[side] = amount
        return PaddingView(ViewContent1(self), padding)
    }

    public func frame(height: Int) -> FrameView<ViewContent1<Self>> {
        return FrameView(ViewContent1(self), height: height)
    }

    public func frame(
        minimumHeight: Int? = nil,
        maximumHeight: Int? = nil
    ) -> FrameView<ViewContent1<Self>> {
        return FrameView(
            ViewContent1(self),
            minimumHeight: minimumHeight,
            maximumHeight: maximumHeight
        )
    }

    public func foregroundColor(_ color: Color) -> ForegroundColorView<ViewContent1<Self>> {
        return ForegroundColorView(ViewContent1(self), color: color)
    }
}
