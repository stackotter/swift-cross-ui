import CGtk3

/// #GtkGLArea is a widget that allows drawing with OpenGL.
///
/// #GtkGLArea sets up its own #GdkGLContext for the window it creates, and
/// creates a custom GL framebuffer that the widget will do GL rendering onto.
/// It also ensures that this framebuffer is the default GL rendering target
/// when rendering.
///
/// In order to draw, you have to connect to the #GtkGLArea::render signal,
/// or subclass #GtkGLArea and override the @GtkGLAreaClass.render() virtual
/// function.
///
/// The #GtkGLArea widget ensures that the #GdkGLContext is associated with
/// the widget's drawing area, and it is kept updated when the size and
/// position of the drawing area changes.
///
/// ## Drawing with GtkGLArea ##
///
/// The simplest way to draw using OpenGL commands in a #GtkGLArea is to
/// create a widget instance and connect to the #GtkGLArea::render signal:
///
/// |[<!-- language="C" -->
/// // create a GtkGLArea instance
/// GtkWidget *gl_area = gtk_gl_area_new ();
///
/// // connect to the "render" signal
/// g_signal_connect (gl_area, "render", G_CALLBACK (render), NULL);
/// ]|
///
/// The `render()` function will be called when the #GtkGLArea is ready
/// for you to draw its content:
///
/// |[<!-- language="C" -->
/// static gboolean
/// render (GtkGLArea *area, GdkGLContext *context)
/// {
/// // inside this function it's safe to use GL; the given
/// // #GdkGLContext has been made current to the drawable
/// // surface used by the #GtkGLArea and the viewport has
/// // already been set to be the size of the allocation
///
/// // we can start by clearing the buffer
/// glClearColor (0, 0, 0, 0);
/// glClear (GL_COLOR_BUFFER_BIT);
///
/// // draw your object
/// draw_an_object ();
///
/// // we completed our drawing; the draw commands will be
/// // flushed at the end of the signal emission chain, and
/// // the buffers will be drawn on the window
/// return TRUE;
/// }
/// ]|
///
/// If you need to initialize OpenGL state, e.g. buffer objects or
/// shaders, you should use the #GtkWidget::realize signal; you
/// can use the #GtkWidget::unrealize signal to clean up. Since the
/// #GdkGLContext creation and initialization may fail, you will
/// need to check for errors, using gtk_gl_area_get_error(). An example
/// of how to safely initialize the GL state is:
///
/// |[<!-- language="C" -->
/// static void
/// on_realize (GtkGLarea *area)
/// {
/// // We need to make the context current if we want to
/// // call GL API
/// gtk_gl_area_make_current (area);
///
/// // If there were errors during the initialization or
/// // when trying to make the context current, this
/// // function will return a #GError for you to catch
/// if (gtk_gl_area_get_error (area) != NULL)
/// return;
///
/// // You can also use gtk_gl_area_set_error() in order
/// // to show eventual initialization errors on the
/// // GtkGLArea widget itself
/// GError *internal_error = NULL;
/// init_buffer_objects (&error);
/// if (error != NULL)
/// {
/// gtk_gl_area_set_error (area, error);
/// g_error_free (error);
/// return;
/// }
///
/// init_shaders (&error);
/// if (error != NULL)
/// {
/// gtk_gl_area_set_error (area, error);
/// g_error_free (error);
/// return;
/// }
/// }
/// ]|
///
/// If you need to change the options for creating the #GdkGLContext
/// you should use the #GtkGLArea::create-context signal.
open class GLArea: Widget {
    /// Creates a new #GtkGLArea widget.
    public convenience init() {
        self.init(
            gtk_gl_area_new()
        )
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "create-context") { [weak self] () in
            guard let self = self else { return }
            self.createContext?(self)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "render", handler: gCallback(handler1)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.render?(self, param0)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, Int, Int, UnsafeMutableRawPointer) -> Void =
                { _, value1, value2, data in
                    SignalBox2<Int, Int>.run(data, value1, value2)
                }

        addSignal(name: "resize", handler: gCallback(handler2)) {
            [weak self] (param0: Int, param1: Int) in
            guard let self = self else { return }
            self.resize?(self, param0, param1)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::auto-render", handler: gCallback(handler3)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAutoRender?(self, param0)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::context", handler: gCallback(handler4)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyContext?(self, param0)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::has-alpha", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHasAlpha?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::has-depth-buffer", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHasDepthBuffer?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::has-stencil-buffer", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHasStencilBuffer?(self, param0)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-es", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseEs?(self, param0)
        }
    }

    /// The ::create-context signal is emitted when the widget is being
    /// realized, and allows you to override how the GL context is
    /// created. This is useful when you want to reuse an existing GL
    /// context, or if you want to try creating different kinds of GL
    /// options.
    ///
    /// If context creation fails then the signal handler can use
    /// gtk_gl_area_set_error() to register a more detailed error
    /// of how the construction failed.
    public var createContext: ((GLArea) -> Void)?

    /// The ::render signal is emitted every time the contents
    /// of the #GtkGLArea should be redrawn.
    ///
    /// The @context is bound to the @area prior to emitting this function,
    /// and the buffers are painted to the window once the emission terminates.
    public var render: ((GLArea, OpaquePointer) -> Void)?

    /// The ::resize signal is emitted once when the widget is realized, and
    /// then each time the widget is changed while realized. This is useful
    /// in order to keep GL state up to date with the widget size, like for
    /// instance camera properties which may depend on the width/height ratio.
    ///
    /// The GL context for the area is guaranteed to be current when this signal
    /// is emitted.
    ///
    /// The default handler sets up the GL viewport.
    public var resize: ((GLArea, Int, Int) -> Void)?

    public var notifyAutoRender: ((GLArea, OpaquePointer) -> Void)?

    public var notifyContext: ((GLArea, OpaquePointer) -> Void)?

    public var notifyHasAlpha: ((GLArea, OpaquePointer) -> Void)?

    public var notifyHasDepthBuffer: ((GLArea, OpaquePointer) -> Void)?

    public var notifyHasStencilBuffer: ((GLArea, OpaquePointer) -> Void)?

    public var notifyUseEs: ((GLArea, OpaquePointer) -> Void)?
}
