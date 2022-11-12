extension View {
    public func padding(_ amount: Int) -> PaddingView<ViewContent1<Self>> {
        let padding = Padding(amount)
        return PaddingView(ViewContent1(self), padding)
    }

    public func padding(_ side: Side, _ amount: Int) -> PaddingView<ViewContent1<Self>> {
        var padding = Padding()
        padding[side] = amount
        return PaddingView(ViewContent1(self), padding)
    }
}
