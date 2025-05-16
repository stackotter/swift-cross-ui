extension View {
    public func `if`<Result: View>(
        _ condition: Bool,
        apply modifier: (Self) -> Result
    ) -> some View {
        if condition {
            EitherView<Self, Result>(modifier(self))
        } else {
            EitherView<Self, Result>(self)
        }
    }

    public func ifLet<Value, Result: View>(
        _ value: Value?,
        apply modifier: (Self, Value) -> Result
    ) -> some View {
        if let value {
            EitherView<Self, Result>(modifier(self, value))
        } else {
            EitherView<Self, Result>(self)
        }
    }
}
