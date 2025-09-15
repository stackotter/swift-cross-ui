import CGtk3

/// #GtkFileChooser is an interface that can be implemented by file
/// selection widgets.  In GTK+, the main objects that implement this
/// interface are #GtkFileChooserWidget, #GtkFileChooserDialog, and
/// #GtkFileChooserButton.  You do not need to write an object that
/// implements the #GtkFileChooser interface unless you are trying to
/// adapt an existing file selector to expose a standard programming
/// interface.
///
/// #GtkFileChooser allows for shortcuts to various places in the filesystem.
/// In the default implementation these are displayed in the left pane. It
/// may be a bit confusing at first that these shortcuts come from various
/// sources and in various flavours, so lets explain the terminology here:
///
/// - Bookmarks: are created by the user, by dragging folders from the
/// right pane to the left pane, or by using the “Add”. Bookmarks
/// can be renamed and deleted by the user.
///
/// - Shortcuts: can be provided by the application. For example, a Paint
/// program may want to add a shortcut for a Clipart folder. Shortcuts
/// cannot be modified by the user.
///
/// - Volumes: are provided by the underlying filesystem abstraction. They are
/// the “roots” of the filesystem.
///
/// # File Names and Encodings
///
/// When the user is finished selecting files in a
/// #GtkFileChooser, your program can get the selected names
/// either as filenames or as URIs.  For URIs, the normal escaping
/// rules are applied if the URI contains non-ASCII characters.
/// However, filenames are always returned in
/// the character set specified by the
/// `G_FILENAME_ENCODING` environment variable.
/// Please see the GLib documentation for more details about this
/// variable.
///
/// This means that while you can pass the result of
/// gtk_file_chooser_get_filename() to g_open() or g_fopen(),
/// you may not be able to directly set it as the text of a
/// #GtkLabel widget unless you convert it first to UTF-8,
/// which all GTK+ widgets expect. You should use g_filename_to_utf8()
/// to convert filenames into strings that can be passed to GTK+
/// widgets.
///
/// # Adding a Preview Widget
///
/// You can add a custom preview widget to a file chooser and then
/// get notification about when the preview needs to be updated.
/// To install a preview widget, use
/// gtk_file_chooser_set_preview_widget().  Then, connect to the
/// #GtkFileChooser::update-preview signal to get notified when
/// you need to update the contents of the preview.
///
/// Your callback should use
/// gtk_file_chooser_get_preview_filename() to see what needs
/// previewing.  Once you have generated the preview for the
/// corresponding file, you must call
/// gtk_file_chooser_set_preview_widget_active() with a boolean
/// flag that indicates whether your callback could successfully
/// generate a preview.
///
/// ## Example: Using a Preview Widget ## {#gtkfilechooser-preview}
/// |[<!-- language="C" -->
/// {
/// GtkImage *preview;
///
/// ...
///
/// preview = gtk_image_new ();
///
/// gtk_file_chooser_set_preview_widget (my_file_chooser, preview);
/// g_signal_connect (my_file_chooser, "update-preview",
/// G_CALLBACK (update_preview_cb), preview);
/// }
///
/// static void
/// update_preview_cb (GtkFileChooser *file_chooser, gpointer data)
/// {
/// GtkWidget *preview;
/// char *filename;
/// GdkPixbuf *pixbuf;
/// gboolean have_preview;
///
/// preview = GTK_WIDGET (data);
/// filename = gtk_file_chooser_get_preview_filename (file_chooser);
///
/// pixbuf = gdk_pixbuf_new_from_file_at_size (filename, 128, 128, NULL);
/// have_preview = (pixbuf != NULL);
/// g_free (filename);
///
/// gtk_image_set_from_pixbuf (GTK_IMAGE (preview), pixbuf);
/// if (pixbuf)
/// g_object_unref (pixbuf);
///
/// gtk_file_chooser_set_preview_widget_active (file_chooser, have_preview);
/// }
/// ]|
///
/// # Adding Extra Widgets
///
/// You can add extra widgets to a file chooser to provide options
/// that are not present in the default design.  For example, you
/// can add a toggle button to give the user the option to open a
/// file in read-only mode.  You can use
/// gtk_file_chooser_set_extra_widget() to insert additional
/// widgets in a file chooser.
///
/// An example for adding extra widgets:
/// |[<!-- language="C" -->
///
/// GtkWidget *toggle;
///
/// ...
///
/// toggle = gtk_check_button_new_with_label ("Open file read-only");
/// gtk_widget_show (toggle);
/// gtk_file_chooser_set_extra_widget (my_file_chooser, toggle);
/// }
/// ]|
///
/// If you want to set more than one extra widget in the file
/// chooser, you can a container such as a #GtkBox or a #GtkGrid
/// and include your widgets in it.  Then, set the container as
/// the whole extra widget.
public protocol FileChooser: GObjectRepresentable {

    var action: FileChooserAction { get set }

    var localOnly: Bool { get set }

    var previewWidgetActive: Bool { get set }

    var selectMultiple: Bool { get set }

    var showHidden: Bool { get set }

    var usePreviewLabel: Bool { get set }

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
    var confirmOverwrite: ((Self) -> Void)? { get set }

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
    var currentFolderChanged: ((Self) -> Void)? { get set }

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
    var fileActivated: ((Self) -> Void)? { get set }

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
    var selectionChanged: ((Self) -> Void)? { get set }

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
    var updatePreview: ((Self) -> Void)? { get set }
}
