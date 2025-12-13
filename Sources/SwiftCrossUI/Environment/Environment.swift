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
    var location: EnvironmentLocation<Value>
    var value: Box<Value?>

    public func update(
        with environment: EnvironmentValues,
        previousValue: Self?
    ) {
        switch location {
            case .keyPath(let keyPath):
                value.value = environment[keyPath: keyPath]
            case .environmentKey(let environmentKey):
                value.value = (environment[environmentKey])
        }
    }

    public var wrappedValue: Value {
        guard let value = value.value else {
            fatalError(
                """
                Environment value at \(location.debugDescription) used before initialization. Don't \
                use @Environment properties before SwiftCrossUI requests the \
                view's body.
                """
            )
        }
        return value
    }

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.location = .keyPath(keyPath)
        value = Box(value: nil)
    }

    public init<Key: EnvironmentKey>(_ type: Key.Type) where Value == Key.Value {
        self.location = .environmentKey(type)
        self.value = Box(value: nil)
    }
}

enum EnvironmentLocation<Value> {
    case keyPath(KeyPath<EnvironmentValues, Value>)
    case environmentKey(any EnvironmentKey<Value>.Type)
}

extension EnvironmentLocation: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
            case .keyPath(let keyPath):
                "EnvironmentLocation.keyPath(\(keyPath))"
            case .environmentKey(let environmentKey):
                "EnvironmentLocation.environmentKey(\(environmentKey))"
        }
    }
}
