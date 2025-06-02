import Foundation

/// The environment used when constructing scenes and views. Each scene or view
/// gets to modify the environment before passing it on to its children, which
/// is the basis of many view modifiers.
public struct EnvironmentValues {
    /// The current stack orientation. Inherited by ``ForEach`` and ``Group`` so
    /// that they can be used without affecting layout.
    public var layoutOrientation: Orientation
    /// The current stack alignment. Inherited by ``ForEach`` and ``Group`` so
    /// that they can be used without affecting layout.
    public var layoutAlignment: StackAlignment
    /// The current stack spacing. Inherited by ``ForEach`` and ``Group`` so
    /// that they can be used without affecting layout.
    public var layoutSpacing: Int
    /// The current font.
    public var font: Font
    /// How lines should be aligned relative to each other when line wrapped.
    public var multilineTextAlignment: HorizontalAlignment

    /// The current color scheme of the current view scope.
    public var colorScheme: ColorScheme
    /// The foreground color. `nil` means that the default foreground color of
    /// the current color scheme should be used.
    public var foregroundColor: Color?

    /// The suggested foreground color for backends to use. Backends don't
    /// neccessarily have to obey this when ``Environment/foregroundColor``
    /// is `nil`.
    public var suggestedForegroundColor: Color {
        foregroundColor ?? colorScheme.defaultForegroundColor
    }

    /// Called when a text field gets submitted (usually due to the user
    /// pressing Enter/Return).
    public var onSubmit: (() -> Void)?

    /// The scale factor of the current window.
    public var windowScaleFactor: Double

    /// The type of input that text fields represent.
    ///
    /// This affects autocomplete suggestions, and on devices with no physical keyboard, which
    /// on-screen keyboard to use.
    ///
    /// Do not use this in place of validation, even if you only plan on supporting mobile
    /// devices, as this does not restrict copy-paste and many mobile devices support bluetooth
    /// keyboards.
    public var textContentType: TextContentType

    /// Whether user interaction is enabled. Set by ``View/disabled(_:)``.
    public var isEnabled: Bool

    /// Called by view graph nodes when they resize due to an internal state
    /// change and end up changing size. Each view graph node sets its own
    /// handler when passing the environment on to its children, setting up
    /// a bottom-up update chain up which resize events can propagate.
    var onResize: (_ newSize: ViewSize) -> Void

    /// The style of list to use.
    package var listStyle: ListStyle

    /// The style of toggle to use.
    public var toggleStyle: ToggleStyle

    // Backing storage for extensible subscript
    private var extraValues: [ObjectIdentifier: Any]

    public subscript<T: EnvironmentKey>(_ key: T.Type) -> T.Value {
        get {
            extraValues[ObjectIdentifier(T.self), default: T.defaultValue] as! T.Value
        }
        set {
            extraValues[ObjectIdentifier(T.self)] = newValue
        }
    }

    /// Brings the current window forward, not guaranteed to always bring
    /// the window to the top (due to focus stealing prevention).
    func bringWindowForward() {
        func activate<Backend: AppBackend>(with backend: Backend) {
            backend.activate(window: window as! Backend.Window)
        }
        activate(with: backend)
        print("Activated")
    }

    /// The backend's representation of the window that the current view is
    /// in, if any. This is a very internal detail that should never get
    /// exposed to users.
    package var window: Any?
    /// The backend in use. Mustn't change throughout the app's lifecycle.
    let backend: any AppBackend

    /// Presents an 'Open file' dialog fit for selecting a single file. Some
    /// backends only allow selecting either files or directories but not both
    /// in a single dialog. Returns `nil` if the user cancels the operation.
    /// Displays as a modal for the current window, or the entire app if
    /// accessed outside of a scene's view graph (in which case the backend
    /// can decide whether to make it an app modal, a standalone window, or a
    /// window of its choosing).
    public var chooseFile: PresentSingleFileOpenDialogAction {
        return PresentSingleFileOpenDialogAction(
            backend: backend,
            window: window
        )
    }

    /// Presents a 'Save file' dialog fit for selecting a save destination.
    /// Returns `nil` if the user cancels the operation. Displays as a modal
    /// for the current window, or the entire app if accessed outside of a
    /// scene's view graph (in which case the backend can decide whether to
    /// make it an app modal, a standalone window, or a modal for a window of
    /// its chooosing).
    public var chooseFileSaveDestination: PresentFileSaveDialogAction {
        return PresentFileSaveDialogAction(
            backend: backend,
            window: window
        )
    }

    /// Presents an alert for the current window, or the entire app if accessed
    /// outside of a scene's view graph (in which case the backend can decide
    /// whether to make it an app modal, a standalone window, or a modal for a
    /// window of its choosing).
    public var presentAlert: PresentAlertAction {
        return PresentAlertAction(
            environment: self
        )
    }

    /// Opens a URL with the default application. May present an application
    /// picker if multiple applications are registered for the given URL
    /// protocol.
    public var openURL: OpenURLAction {
        return OpenURLAction(
            backend: backend
        )
    }

    /// Reveals a file in the system's file manager. This opens
    /// the file's enclosing directory and highlighting the file.
    ///
    /// `nil` on platforms that don't support revealing files, e.g.
    /// iOS.
    public var revealFile: RevealFileAction? {
        return RevealFileAction(
            backend: backend
        )
    }

    /// Creates the default environment.
    init<Backend: AppBackend>(backend: Backend) {
        self.backend = backend

        onResize = { _ in }
        layoutOrientation = .vertical
        layoutAlignment = .center
        layoutSpacing = 10
        foregroundColor = nil
        font = .system(size: 12)
        multilineTextAlignment = .leading
        colorScheme = .light
        windowScaleFactor = 1
        textContentType = .text
        window = nil
        extraValues = [:]
        listStyle = .default
        toggleStyle = .button
        isEnabled = true
    }

    /// Returns a copy of the environment with the specified property set to the
    /// provided new value.
    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ newValue: T) -> Self {
        var environment = self
        environment[keyPath: keyPath] = newValue
        return environment
    }
}

/// A key that can be used to extend the environment with new properties.
public protocol EnvironmentKey {
    /// The type of value the key can hold.
    associatedtype Value
    /// The default value for the key.
    static var defaultValue: Value { get }
}
