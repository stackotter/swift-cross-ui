import CGtk3

/// #GtkFileChooserNative is an abstraction of a dialog box suitable
/// for use with “File/Open” or “File/Save as” commands. By default, this
/// just uses a #GtkFileChooserDialog to implement the actual dialog.
/// However, on certain platforms, such as Windows and macOS, the native platform
/// file chooser is used instead. When the application is running in a
/// sandboxed environment without direct filesystem access (such as Flatpak),
/// #GtkFileChooserNative may call the proper APIs (portals) to let the user
/// choose a file and make it available to the application.
///
/// While the API of #GtkFileChooserNative closely mirrors #GtkFileChooserDialog, the main
/// difference is that there is no access to any #GtkWindow or #GtkWidget for the dialog.
/// This is required, as there may not be one in the case of a platform native dialog.
/// Showing, hiding and running the dialog is handled by the #GtkNativeDialog functions.
///
/// ## Typical usage ## {#gtkfilechoosernative-typical-usage}
///
/// In the simplest of cases, you can the following code to use
/// #GtkFileChooserDialog to select a file for opening:
///
/// |[
/// GtkFileChooserNative *native;
/// GtkFileChooserAction action = GTK_FILE_CHOOSER_ACTION_OPEN;
/// gint res;
///
/// native = gtk_file_chooser_native_new ("Open File",
/// parent_window,
/// action,
/// "_Open",
/// "_Cancel");
///
/// res = gtk_native_dialog_run (GTK_NATIVE_DIALOG (native));
/// if (res == GTK_RESPONSE_ACCEPT)
/// {
/// char *filename;
/// GtkFileChooser *chooser = GTK_FILE_CHOOSER (native);
/// filename = gtk_file_chooser_get_filename (chooser);
/// open_file (filename);
/// g_free (filename);
/// }
///
/// g_object_unref (native);
/// ]|
///
/// To use a dialog for saving, you can use this:
///
/// |[
/// GtkFileChooserNative *native;
/// GtkFileChooser *chooser;
/// GtkFileChooserAction action = GTK_FILE_CHOOSER_ACTION_SAVE;
/// gint res;
///
/// native = gtk_file_chooser_native_new ("Save File",
/// parent_window,
/// action,
/// "_Save",
/// "_Cancel");
/// chooser = GTK_FILE_CHOOSER (native);
///
/// gtk_file_chooser_set_do_overwrite_confirmation (chooser, TRUE);
///
/// if (user_edited_a_new_document)
/// gtk_file_chooser_set_current_name (chooser,
/// _("Untitled document"));
/// else
/// gtk_file_chooser_set_filename (chooser,
/// existing_filename);
///
/// res = gtk_native_dialog_run (GTK_NATIVE_DIALOG (native));
/// if (res == GTK_RESPONSE_ACCEPT)
/// {
/// char *filename;
///
/// filename = gtk_file_chooser_get_filename (chooser);
/// save_to_file (filename);
/// g_free (filename);
/// }
///
/// g_object_unref (native);
/// ]|
///
/// For more information on how to best set up a file dialog, see #GtkFileChooserDialog.
///
/// ## Response Codes ## {#gtkfilechooserdialognative-responses}
///
/// #GtkFileChooserNative inherits from #GtkNativeDialog, which means it
/// will return #GTK_RESPONSE_ACCEPT if the user accepted, and
/// #GTK_RESPONSE_CANCEL if he pressed cancel. It can also return
/// #GTK_RESPONSE_DELETE_EVENT if the window was unexpectedly closed.
///
/// ## Differences from #GtkFileChooserDialog ##  {#gtkfilechooserdialognative-differences}
///
/// There are a few things in the GtkFileChooser API that are not
/// possible to use with #GtkFileChooserNative, as such use would
/// prohibit the use of a native dialog.
///
/// There is no support for the signals that are emitted when the user
/// navigates in the dialog, including:
/// * #GtkFileChooser::current-folder-changed
/// * #GtkFileChooser::selection-changed
/// * #GtkFileChooser::file-activated
/// * #GtkFileChooser::confirm-overwrite
///
/// You can also not use the methods that directly control user navigation:
/// * gtk_file_chooser_unselect_filename()
/// * gtk_file_chooser_select_all()
/// * gtk_file_chooser_unselect_all()
///
/// If you need any of the above you will have to use #GtkFileChooserDialog directly.
///
/// No operations that change the the dialog work while the dialog is
/// visible. Set all the properties that are required before showing the dialog.
///
/// ## Win32 details ## {#gtkfilechooserdialognative-win32}
///
/// On windows the IFileDialog implementation (added in Windows Vista) is
/// used. It supports many of the features that #GtkFileChooserDialog
/// does, but there are some things it does not handle:
///
/// * Extra widgets added with gtk_file_chooser_set_extra_widget().
///
/// * Use of custom previews by connecting to #GtkFileChooser::update-preview.
///
/// * Any #GtkFileFilter added using a mimetype or custom filter.
///
/// If any of these features are used the regular #GtkFileChooserDialog
/// will be used in place of the native one.
///
/// ## Portal details ## {#gtkfilechooserdialognative-portal}
///
/// When the org.freedesktop.portal.FileChooser portal is available on the
/// session bus, it is used to bring up an out-of-process file chooser. Depending
/// on the kind of session the application is running in, this may or may not
/// be a GTK+ file chooser. In this situation, the following things are not
/// supported and will be silently ignored:
///
/// * Extra widgets added with gtk_file_chooser_set_extra_widget().
///
/// * Use of custom previews by connecting to #GtkFileChooser::update-preview.
///
/// * Any #GtkFileFilter added with a custom filter.
///
/// ## macOS details ## {#gtkfilechooserdialognative-macos}
///
/// On macOS the NSSavePanel and NSOpenPanel classes are used to provide native
/// file chooser dialogs. Some features provided by #GtkFileChooserDialog are
/// not supported:
///
/// * Extra widgets added with gtk_file_chooser_set_extra_widget(), unless the
/// widget is an instance of GtkLabel, in which case the label text will be used
/// to set the NSSavePanel message instance property.
///
/// * Use of custom previews by connecting to #GtkFileChooser::update-preview.
///
/// * Any #GtkFileFilter added with a custom filter.
///
/// * Shortcut folders.
open class FileChooserNative: NativeDialog, FileChooser {
    /// Creates a new #GtkFileChooserNative.
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

        addSignal(name: "confirm-overwrite") { [weak self] () in
            guard let self = self else { return }
            self.confirmOverwrite?(self)
        }

        addSignal(name: "current-folder-changed") { [weak self] () in
            guard let self = self else { return }
            self.currentFolderChanged?(self)
        }

        addSignal(name: "file-activated") { [weak self] () in
            guard let self = self else { return }
            self.fileActivated?(self)
        }

        addSignal(name: "selection-changed") { [weak self] () in
            guard let self = self else { return }
            self.selectionChanged?(self)
        }

        addSignal(name: "update-preview") { [weak self] () in
            guard let self = self else { return }
            self.updatePreview?(self)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::accept-label", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAcceptLabel?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::cancel-label", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCancelLabel?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::action", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAction?(self, param0)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::create-folders", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCreateFolders?(self, param0)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::do-overwrite-confirmation", handler: gCallback(handler9)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyDoOverwriteConfirmation?(self, param0)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::extra-widget", handler: gCallback(handler10)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyExtraWidget?(self, param0)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::filter", handler: gCallback(handler11)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyFilter?(self, param0)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::local-only", handler: gCallback(handler12)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLocalOnly?(self, param0)
        }

        let handler13:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::preview-widget", handler: gCallback(handler13)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPreviewWidget?(self, param0)
        }

        let handler14:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::preview-widget-active", handler: gCallback(handler14)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPreviewWidgetActive?(self, param0)
        }

        let handler15:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::select-multiple", handler: gCallback(handler15)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectMultiple?(self, param0)
        }

        let handler16:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::show-hidden", handler: gCallback(handler16)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShowHidden?(self, param0)
        }

        let handler17:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-preview-label", handler: gCallback(handler17)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUsePreviewLabel?(self, param0)
        }
    }

    /// The text used for the label on the accept button in the dialog, or
    /// %NULL to use the default text.
    @GObjectProperty(named: "accept-label") public var acceptLabel: String?

    /// The text used for the label on the cancel button in the dialog, or
    /// %NULL to use the default text.
    @GObjectProperty(named: "cancel-label") public var cancelLabel: String?

    @GObjectProperty(named: "action") public var action: FileChooserAction

    @GObjectProperty(named: "local-only") public var localOnly: Bool

    @GObjectProperty(named: "preview-widget-active") public var previewWidgetActive: Bool

    @GObjectProperty(named: "select-multiple") public var selectMultiple: Bool

    @GObjectProperty(named: "show-hidden") public var showHidden: Bool

    @GObjectProperty(named: "use-preview-label") public var usePreviewLabel: Bool

    /// This signal gets emitted whenever it is appropriate to present a
    /// confirmation dialog when the user has selected a file name that
    /// already exists.  The signal only gets emitted when the file
    /// chooser is in %GTK_FILE_CHOOSER_ACTION_SAVE mode.
    ///
    /// Most applications just need to turn on the
    /// #GtkFileChooser:do-overwrite-confirmation property (or call the
    /// gtk_file_chooser_set_do_overwrite_confirmation() function), and
    /// they will automatically get a stock confirmation dialog.
    /// Applications which need to customize this behavior should do
    /// that, and also connect to the #GtkFileChooser::confirm-overwrite
    /// signal.
    ///
    /// A signal handler for this signal must return a
    /// #GtkFileChooserConfirmation value, which indicates the action to
    /// take.  If the handler determines that the user wants to select a
    /// different filename, it should return
    /// %GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN.  If it determines
    /// that the user is satisfied with his choice of file name, it
    /// should return %GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME.
    /// On the other hand, if it determines that the stock confirmation
    /// dialog should be used, it should return
    /// %GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM. The following example
    /// illustrates this.
    ///
    /// ## Custom confirmation ## {#gtkfilechooser-confirmation}
    ///
    /// |[<!-- language="C" -->
    /// static GtkFileChooserConfirmation
    /// confirm_overwrite_callback (GtkFileChooser *chooser, gpointer data)
    /// {
    /// char *uri;
    ///
    /// uri = gtk_file_chooser_get_uri (chooser);
    ///
    /// if (is_uri_read_only (uri))
    /// {
    /// if (user_wants_to_replace_read_only_file (uri))
    /// return GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME;
    /// else
    /// return GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN;
    /// } else
    /// return GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM; // fall back to the default dialog
    /// }
    ///
    /// ...
    ///
    /// chooser = gtk_file_chooser_dialog_new (...);
    ///
    /// gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (dialog), TRUE);
    /// g_signal_connect (chooser, "confirm-overwrite",
    /// G_CALLBACK (confirm_overwrite_callback), NULL);
    ///
    /// if (gtk_dialog_run (chooser) == GTK_RESPONSE_ACCEPT)
    /// save_to_file (gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (chooser));
    ///
    /// gtk_widget_destroy (chooser);
    /// ]|
    public var confirmOverwrite: ((FileChooserNative) -> Void)?

    /// This signal is emitted when the current folder in a #GtkFileChooser
    /// changes.  This can happen due to the user performing some action that
    /// changes folders, such as selecting a bookmark or visiting a folder on the
    /// file list.  It can also happen as a result of calling a function to
    /// explicitly change the current folder in a file chooser.
    ///
    /// Normally you do not need to connect to this signal, unless you need to keep
    /// track of which folder a file chooser is showing.
    ///
    /// See also:  gtk_file_chooser_set_current_folder(),
    /// gtk_file_chooser_get_current_folder(),
    /// gtk_file_chooser_set_current_folder_uri(),
    /// gtk_file_chooser_get_current_folder_uri().
    public var currentFolderChanged: ((FileChooserNative) -> Void)?

    /// This signal is emitted when the user "activates" a file in the file
    /// chooser.  This can happen by double-clicking on a file in the file list, or
    /// by pressing `Enter`.
    ///
    /// Normally you do not need to connect to this signal.  It is used internally
    /// by #GtkFileChooserDialog to know when to activate the default button in the
    /// dialog.
    ///
    /// See also: gtk_file_chooser_get_filename(),
    /// gtk_file_chooser_get_filenames(), gtk_file_chooser_get_uri(),
    /// gtk_file_chooser_get_uris().
    public var fileActivated: ((FileChooserNative) -> Void)?

    /// This signal is emitted when there is a change in the set of selected files
    /// in a #GtkFileChooser.  This can happen when the user modifies the selection
    /// with the mouse or the keyboard, or when explicitly calling functions to
    /// change the selection.
    ///
    /// Normally you do not need to connect to this signal, as it is easier to wait
    /// for the file chooser to finish running, and then to get the list of
    /// selected files using the functions mentioned below.
    ///
    /// See also: gtk_file_chooser_select_filename(),
    /// gtk_file_chooser_unselect_filename(), gtk_file_chooser_get_filename(),
    /// gtk_file_chooser_get_filenames(), gtk_file_chooser_select_uri(),
    /// gtk_file_chooser_unselect_uri(), gtk_file_chooser_get_uri(),
    /// gtk_file_chooser_get_uris().
    public var selectionChanged: ((FileChooserNative) -> Void)?

    /// This signal is emitted when the preview in a file chooser should be
    /// regenerated.  For example, this can happen when the currently selected file
    /// changes.  You should use this signal if you want your file chooser to have
    /// a preview widget.
    ///
    /// Once you have installed a preview widget with
    /// gtk_file_chooser_set_preview_widget(), you should update it when this
    /// signal is emitted.  You can use the functions
    /// gtk_file_chooser_get_preview_filename() or
    /// gtk_file_chooser_get_preview_uri() to get the name of the file to preview.
    /// Your widget may not be able to preview all kinds of files; your callback
    /// must call gtk_file_chooser_set_preview_widget_active() to inform the file
    /// chooser about whether the preview was generated successfully or not.
    ///
    /// Please see the example code in
    /// [Using a Preview Widget][gtkfilechooser-preview].
    ///
    /// See also: gtk_file_chooser_set_preview_widget(),
    /// gtk_file_chooser_set_preview_widget_active(),
    /// gtk_file_chooser_set_use_preview_label(),
    /// gtk_file_chooser_get_preview_filename(),
    /// gtk_file_chooser_get_preview_uri().
    public var updatePreview: ((FileChooserNative) -> Void)?

    public var notifyAcceptLabel: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyCancelLabel: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyAction: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyCreateFolders: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyDoOverwriteConfirmation: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyExtraWidget: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyFilter: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyLocalOnly: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyPreviewWidget: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyPreviewWidgetActive: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifySelectMultiple: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyShowHidden: ((FileChooserNative, OpaquePointer) -> Void)?

    public var notifyUsePreviewLabel: ((FileChooserNative, OpaquePointer) -> Void)?
}
