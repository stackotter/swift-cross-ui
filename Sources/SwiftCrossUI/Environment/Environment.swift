/// A property wrapper used to access environment values within a `View` or
/// `App`. Must not be used before the view graph accesses the view or app's
/// `body` (i.e. don't access it from an initializer).
///
/// ```
/// struct ContentView: View {
///     @Environment(\.colorScheme) var colorScheme
///
///     var body: some View {
///         Text("Current color scheme: \(colorScheme)")
///             .background(colorScheme == .light ? Color.black : Color.white)
///     }
/// }
/// ```
///
/// The environment also contains UI-related actions, such as the
/// ``EnvironmentValues/chooseFile`` action used to present 'Open file' dialogs.
///
/// ```
/// struct ContentView: View {
///     @Environment(\.chooseFile) var chooseFile
///
///     var body: some View {
///         Button("Open") {
///             Task {
///                 guard let file = await chooseFile() else {
///                     print("No file chosen")
///                     return
///                 }
///
///                 print("The user chose: \(file.path)")
///             }
///         }
///     }
/// }
/// ```
@propertyWrapper
public struct Environment<Value>: DynamicProperty {
    var keyPath: KeyPath<EnvironmentValues, Value>
    var value: Box<Value?>

    public func update(
        with environment: EnvironmentValues,
        previousValue: Self?
    ) {
        value.value = environment[keyPath: keyPath]
    }

    public var wrappedValue: Value {
        guard let value = value.value else {
            fatalError(
                """
                Environment value at \(keyPath) used before initialization. Don't \
                use @Environment properties before SwiftCrossUI requests the \
                view's body.
                """
            )
        }
        return value
    }

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
        value = Box(nil)
    }
}
