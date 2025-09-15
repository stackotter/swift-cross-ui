import CGtk

/// `GtkFileChooser` is an interface that can be implemented by file
/// selection widgets.
///
/// In GTK, the main objects that implement this interface are
/// [class@Gtk.FileChooserWidget] and [class@Gtk.FileChooserDialog].
///
/// You do not need to write an object that implements the `GtkFileChooser`
/// interface unless you are trying to adapt an existing file selector to
/// expose a standard programming interface.
///
/// `GtkFileChooser` allows for shortcuts to various places in the filesystem.
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
/// When the user is finished selecting files in a `GtkFileChooser`, your
/// program can get the selected filenames as `GFile`s.
///
/// # Adding options
///
/// You can add extra widgets to a file chooser to provide options
/// that are not present in the default design, by using
/// [method@Gtk.FileChooser.add_choice]. Each choice has an identifier and
/// a user visible label; additionally, each choice can have multiple
/// options. If a choice has no option, it will be rendered as a
/// check button with the given label; if a choice has options, it will
/// be rendered as a combo box.
public protocol FileChooser: GObjectRepresentable {
    /// The type of operation that the file chooser is performing.
    var action: FileChooserAction { get set }

    /// Whether a file chooser not in %GTK_FILE_CHOOSER_ACTION_OPEN mode
    /// will offer the user to create new folders.
    var createFolders: Bool { get set }

    /// A `GListModel` containing the filters that have been
    /// added with gtk_file_chooser_add_filter().
    ///
    /// The returned object should not be modified. It may
    /// or may not be updated for later changes.
    var filters: OpaquePointer { get set }

    /// Whether to allow multiple files to be selected.
    var selectMultiple: Bool { get set }

    /// A `GListModel` containing the shortcut folders that have been
    /// added with gtk_file_chooser_add_shortcut_folder().
    ///
    /// The returned object should not be modified. It may
    /// or may not be updated for later changes.
    var shortcutFolders: OpaquePointer { get set }

}
