extension View {
    @available(macOS 99.99.0, *)
    public func padding(_ amount: Int) -> PaddingView<ViewContentVariadic<Self>> {
        let padding = Padding(amount)
        return PaddingView(ViewContentVariadic(self), padding)
    }

    @available(macOS 99.99.0, *)
    public func padding(
        _ side: Side,
        _ amount: Int
    ) -> PaddingView<ViewContentVariadic<Self>> {
        var padding = Padding()
        padding[side] = amount
        return PaddingView(ViewContentVariadic(self), padding)
    }

    @available(macOS 99.99.0, *)
    public func frame(height: Int) -> FrameView<ViewContentVariadic<Self>> {
        return FrameView(ViewContentVariadic(self), height: height)
    }

    @available(macOS 99.99.0, *)
    public func frame(
        minimumHeight: Int? = nil,
        maximumHeight: Int? = nil
    ) -> FrameView<ViewContentVariadic<Self>> {
        return FrameView(
            ViewContentVariadic(self),
            minimumHeight: minimumHeight,
            maximumHeight: maximumHeight
        )
    }

    @available(macOS 99.99.0, *)
    public func foregroundColor(_ color: Color) -> ForegroundColorView<ViewContentVariadic<Self>> {
        return ForegroundColorView(ViewContentVariadic(self), color: color)
    }
}
