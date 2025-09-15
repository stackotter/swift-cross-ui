import CGtk3

/// The #GtkImage widget displays an image. Various kinds of object
/// can be displayed as an image; most typically, you would load a
/// #GdkPixbuf ("pixel buffer") from a file, and then display that.
/// There’s a convenience function to do this, gtk_image_new_from_file(),
/// used as follows:
/// |[<!-- language="C" -->
/// GtkWidget *image;
/// image = gtk_image_new_from_file ("myfile.png");
/// ]|
/// If the file isn’t loaded successfully, the image will contain a
/// “broken image” icon similar to that used in many web browsers.
/// If you want to handle errors in loading the file yourself,
/// for example by displaying an error message, then load the image with
/// gdk_pixbuf_new_from_file(), then create the #GtkImage with
/// gtk_image_new_from_pixbuf().
///
/// The image file may contain an animation, if so the #GtkImage will
/// display an animation (#GdkPixbufAnimation) instead of a static image.
///
/// #GtkImage is a subclass of #GtkMisc, which implies that you can
/// align it (center, left, right) and add padding to it, using
/// #GtkMisc methods.
///
/// #GtkImage is a “no window” widget (has no #GdkWindow of its own),
/// so by default does not receive events. If you want to receive events
/// on the image, such as button clicks, place the image inside a
/// #GtkEventBox, then connect to the event signals on the event box.
///
/// ## Handling button press events on a #GtkImage.
///
/// |[<!-- language="C" -->
/// static gboolean
/// button_press_callback (GtkWidget      *event_box,
/// GdkEventButton *event,
/// gpointer        data)
/// {
/// g_print ("Event box clicked at coordinates %f,%f\n",
/// event->x, event->y);
///
/// // Returning TRUE means we handled the event, so the signal
/// // emission should be stopped (don’t call any further callbacks
/// // that may be connected). Return FALSE to continue invoking callbacks.
/// return TRUE;
/// }
///
/// static GtkWidget*
/// create_image (void)
/// {
/// GtkWidget *image;
/// GtkWidget *event_box;
///
/// image = gtk_image_new_from_file ("myfile.png");
///
/// event_box = gtk_event_box_new ();
///
/// gtk_container_add (GTK_CONTAINER (event_box), image);
///
/// g_signal_connect (G_OBJECT (event_box),
/// "button_press_event",
/// G_CALLBACK (button_press_callback),
/// image);
///
/// return image;
/// }
/// ]|
///
/// When handling events on the event box, keep in mind that coordinates
/// in the image may be different from event box coordinates due to
/// the alignment and padding settings on the image (see #GtkMisc).
/// The simplest way to solve this is to set the alignment to 0.0
/// (left/top), and set the padding to zero. Then the origin of
/// the image will be the same as the origin of the event box.
///
/// Sometimes an application will want to avoid depending on external data
/// files, such as image files. GTK+ comes with a program to avoid this,
/// called “gdk-pixbuf-csource”. This library
/// allows you to convert an image into a C variable declaration, which
/// can then be loaded into a #GdkPixbuf using
/// gdk_pixbuf_new_from_inline().
///
/// # CSS nodes
///
/// GtkImage has a single CSS node with the name image. The style classes
/// may appear on image CSS nodes: .icon-dropshadow, .lowres-icon.
open class Image: Misc {
    /// Creates a new empty #GtkImage widget.
    public convenience init() {
        self.init(
            gtk_image_new()
        )
    }

    /// Creates a new #GtkImage displaying the file @filename. If the file
    /// isn’t found or can’t be loaded, the resulting #GtkImage will
    /// display a “broken image” icon. This function never returns %NULL,
    /// it always returns a valid #GtkImage widget.
    ///
    /// If the file contains an animation, the image will contain an
    /// animation.
    ///
    /// If you need to detect failures to load the file, use
    /// gdk_pixbuf_new_from_file() to load the file yourself, then create
    /// the #GtkImage from the pixbuf. (Or for animations, use
    /// gdk_pixbuf_animation_new_from_file()).
    ///
    /// The storage type (gtk_image_get_storage_type()) of the returned
    /// image is not defined, it will be whatever is appropriate for
    /// displaying the file.
    public convenience init(filename: String) {
        self.init(
            gtk_image_new_from_file(filename)
        )
    }

    /// Creates a #GtkImage displaying an icon from the current icon theme.
    /// If the icon name isn’t known, a “broken image” icon will be
    /// displayed instead.  If the current icon theme is changed, the icon
    /// will be updated appropriately.
    public convenience init(icon: OpaquePointer, size: GtkIconSize) {
        self.init(
            gtk_image_new_from_gicon(icon, size)
        )
    }

    /// Creates a #GtkImage displaying an icon from the current icon theme.
    /// If the icon name isn’t known, a “broken image” icon will be
    /// displayed instead.  If the current icon theme is changed, the icon
    /// will be updated appropriately.
    public convenience init(iconName: String, size: GtkIconSize) {
        self.init(
            gtk_image_new_from_icon_name(iconName, size)
        )
    }

    /// Creates a new #GtkImage displaying the resource file @resource_path. If the file
    /// isn’t found or can’t be loaded, the resulting #GtkImage will
    /// display a “broken image” icon. This function never returns %NULL,
    /// it always returns a valid #GtkImage widget.
    ///
    /// If the file contains an animation, the image will contain an
    /// animation.
    ///
    /// If you need to detect failures to load the file, use
    /// gdk_pixbuf_new_from_file() to load the file yourself, then create
    /// the #GtkImage from the pixbuf. (Or for animations, use
    /// gdk_pixbuf_animation_new_from_file()).
    ///
    /// The storage type (gtk_image_get_storage_type()) of the returned
    /// image is not defined, it will be whatever is appropriate for
    /// displaying the file.
    public convenience init(resourcePath: String) {
        self.init(
            gtk_image_new_from_resource(resourcePath)
        )
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::file", handler: gCallback(handler0)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyFile?(self, param0)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::gicon", handler: gCallback(handler1)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyGicon?(self, param0)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::icon-name", handler: gCallback(handler2)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyIconName?(self, param0)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::icon-set", handler: gCallback(handler3)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyIconSet?(self, param0)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::icon-size", handler: gCallback(handler4)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyIconSize?(self, param0)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::pixbuf", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPixbuf?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::pixbuf-animation", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPixbufAnimation?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::pixel-size", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPixelSize?(self, param0)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::resource", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyResource?(self, param0)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::stock", handler: gCallback(handler9)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyStock?(self, param0)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::storage-type", handler: gCallback(handler10)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyStorageType?(self, param0)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::surface", handler: gCallback(handler11)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySurface?(self, param0)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-fallback", handler: gCallback(handler12)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseFallback?(self, param0)
        }
    }

    @GObjectProperty(named: "stock") public var stock: String

    @GObjectProperty(named: "storage-type") public var storageType: ImageType

    public var notifyFile: ((Image, OpaquePointer) -> Void)?

    public var notifyGicon: ((Image, OpaquePointer) -> Void)?

    public var notifyIconName: ((Image, OpaquePointer) -> Void)?

    public var notifyIconSet: ((Image, OpaquePointer) -> Void)?

    public var notifyIconSize: ((Image, OpaquePointer) -> Void)?

    public var notifyPixbuf: ((Image, OpaquePointer) -> Void)?

    public var notifyPixbufAnimation: ((Image, OpaquePointer) -> Void)?

    public var notifyPixelSize: ((Image, OpaquePointer) -> Void)?

    public var notifyResource: ((Image, OpaquePointer) -> Void)?

    public var notifyStock: ((Image, OpaquePointer) -> Void)?

    public var notifyStorageType: ((Image, OpaquePointer) -> Void)?

    public var notifySurface: ((Image, OpaquePointer) -> Void)?

    public var notifyUseFallback: ((Image, OpaquePointer) -> Void)?
}
