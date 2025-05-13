import CGtk

/// `GtkFileChooserNative` is an abstraction of a dialog suitable
/// for use with “File Open” or “File Save as” commands.
///
/// By default, this just uses a `GtkFileChooserDialog` to implement
/// the actual dialog. However, on some platforms, such as Windows and
/// macOS, the native platform file chooser is used instead. When the
/// application is running in a sandboxed environment without direct
/// filesystem access (such as Flatpak), `GtkFileChooserNative` may call
/// the proper APIs (portals) to let the user choose a file and make it
/// available to the application.
///
/// While the API of `GtkFileChooserNative` closely mirrors `GtkFileChooserDialog`,
/// the main difference is that there is no access to any `GtkWindow` or `GtkWidget`
/// for the dialog. This is required, as there may not be one in the case of a
/// platform native dialog.
///
/// Showing, hiding and running the dialog is handled by the
/// [class@Gtk.NativeDialog] functions.
///
/// Note that unlike `GtkFileChooserDialog`, `GtkFileChooserNative` objects
/// are not toplevel widgets, and GTK does not keep them alive. It is your
/// responsibility to keep a reference until you are done with the
/// object.
///
/// ## Typical usage
///
/// In the simplest of cases, you can the following code to use
/// `GtkFileChooserNative` to select a file for opening:
///
/// ```c
/// static void
/// on_response (GtkNativeDialog *native,
/// int              response)
/// {
/// if (response == GTK_RESPONSE_ACCEPT)
/// {
/// GtkFileChooser *chooser = GTK_FILE_CHOOSER (native);
/// GFile *file = gtk_file_chooser_get_file (chooser);
///
/// open_file (file);
///
/// g_object_unref (file);
/// }
///
/// g_object_unref (native);
/// }
///
/// // ...
/// GtkFileChooserNative *native;
/// GtkFileChooserAction action = GTK_FILE_CHOOSER_ACTION_OPEN;
///
/// native = gtk_file_chooser_native_new ("Open File",
/// parent_window,
/// action,
/// "_Open",
/// "_Cancel");
///
/// g_signal_connect (native, "response", G_CALLBACK (on_response), NULL);
/// gtk_native_dialog_show (GTK_NATIVE_DIALOG (native));
/// ```
///
/// To use a `GtkFileChooserNative` for saving, you can use this:
///
/// ```c
/// static void
/// on_response (GtkNativeDialog *native,
/// int              response)
/// {
/// if (response == GTK_RESPONSE_ACCEPT)
/// {
/// GtkFileChooser *chooser = GTK_FILE_CHOOSER (native);
/// GFile *file = gtk_file_chooser_get_file (chooser);
///
/// save_to_file (file);
///
/// g_object_unref (file);
/// }
///
/// g_object_unref (native);
/// }
///
/// // ...
/// GtkFileChooserNative *native;
/// GtkFileChooser *chooser;
/// GtkFileChooserAction action = GTK_FILE_CHOOSER_ACTION_SAVE;
///
/// native = gtk_file_chooser_native_new ("Save File",
/// parent_window,
/// action,
/// "_Save",
/// "_Cancel");
/// chooser = GTK_FILE_CHOOSER (native);
///
/// if (user_edited_a_new_document)
/// gtk_file_chooser_set_current_name (chooser, _("Untitled document"));
/// else
/// gtk_file_chooser_set_file (chooser, existing_file, NULL);
///
/// g_signal_connect (native, "response", G_CALLBACK (on_response), NULL);
/// gtk_native_dialog_show (GTK_NATIVE_DIALOG (native));
/// ```
///
/// For more information on how to best set up a file dialog,
/// see the [class@Gtk.FileChooserDialog] documentation.
///
/// ## Response Codes
///
/// `GtkFileChooserNative` inherits from [class@Gtk.NativeDialog],
/// which means it will return %GTK_RESPONSE_ACCEPT if the user accepted,
/// and %GTK_RESPONSE_CANCEL if he pressed cancel. It can also return
/// %GTK_RESPONSE_DELETE_EVENT if the window was unexpectedly closed.
///
/// ## Differences from `GtkFileChooserDialog`
///
/// There are a few things in the [iface@Gtk.FileChooser] interface that
/// are not possible to use with `GtkFileChooserNative`, as such use would
/// prohibit the use of a native dialog.
///
/// No operations that change the dialog work while the dialog is visible.
/// Set all the properties that are required before showing the dialog.
///
/// ## Win32 details
///
/// On windows the `IFileDialog` implementation (added in Windows Vista) is
/// used. It supports many of the features that `GtkFileChooser` has, but
/// there are some things it does not handle:
///
/// * Any [class@Gtk.FileFilter] added using a mimetype
///
/// If any of these features are used the regular `GtkFileChooserDialog`
/// will be used in place of the native one.
///
/// ## Portal details
///
/// When the `org.freedesktop.portal.FileChooser` portal is available on
/// the session bus, it is used to bring up an out-of-process file chooser.
/// Depending on the kind of session the application is running in, this may
/// or may not be a GTK file chooser.
///
/// ## macOS details
///
/// On macOS the `NSSavePanel` and `NSOpenPanel` classes are used to provide
/// native file chooser dialogs. Some features provided by `GtkFileChooser`
/// are not supported:
///
/// * Shortcut folders.
open class FileChooserNative: NativeDialog, FileChooser {
    /// Creates a new `GtkFileChooserNative`.
    public convenience init(
        title: String, parent: UnsafeMutablePointer<GtkWindow>!, action: GtkFileChooserAction,
        acceptLabel: String, cancelLabel: String
    ) {
        self.init(
            gtk_file_chooser_native_new(title, parent, action, acceptLabel, cancelLabel)
        )
    }

    public override func registerSignals() {
        super.registerSignals()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::accept-label", handler: gCallback(handler0)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAcceptLabel?(self, param0)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::cancel-label", handler: gCallback(handler1)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCancelLabel?(self, param0)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::action", handler: gCallback(handler2)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAction?(self, param0)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::create-folders", handler: gCallback(handler3)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCreateFolders?(self, param0)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::filter", handler: gCallback(handler4)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyFilter?(self, param0)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::filters", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyFilters?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::select-multiple", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectMultiple?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::shortcut-folders", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShortcutFolders?(self, param0)
        }
    }

    /// The text used for the label on the accept button in the dialog, or
    /// %NULL to use the default text.
    @GObjectProperty(named: "accept-label") public var acceptLabel: String?

    /// The text used for the label on the cancel button in the dialog, or
    /// %NULL to use the default text.
    @GObjectProperty(named: "cancel-label") public var cancelLabel: String?

    /// The type of operation that the file chooser is performing.
    @GObjectProperty(named: "action") public var action: FileChooserAction

    /// Whether a file chooser not in %GTK_FILE_CHOOSER_ACTION_OPEN mode
    /// will offer the user to create new folders.
    @GObjectProperty(named: "create-folders") public var createFolders: Bool

    /// A `GListModel` containing the filters that have been
    /// added with gtk_file_chooser_add_filter().
    ///
    /// The returned object should not be modified. It may
    /// or may not be updated for later changes.
    @GObjectProperty(named: "filters") public var filters: OpaquePointer

    /// Whether to allow multiple files to be selected.
    @GObjectProperty(named: "select-multiple") public var selectMultiple: Bool

    /// A `GListModel` containing the shortcut folders that have been
    /// added with gtk_file_chooser_add_shortcut_folder().
    ///
    /// The returned object should not be modified. It may
    /// or may not be updated for later changes.
    @GObjectProperty(named: "shortcut-folders") public var shortcutFolders: OpaquePointer

    public var notifyAcceptLabel: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyCancelLabel: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyAction: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyCreateFolders: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyFilter: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyFilters: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifySelectMultiple: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyShortcutFolders: ((FileChooserNative, OpaquePointer) -> Void)?
}
