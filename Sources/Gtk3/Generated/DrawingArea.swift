import CGtk3

/// The #GtkDrawingArea widget is used for creating custom user interface
/// elements. It’s essentially a blank widget; you can draw on it. After
/// creating a drawing area, the application may want to connect to:
///
/// - Mouse and button press signals to respond to input from
/// the user. (Use gtk_widget_add_events() to enable events
/// you wish to receive.)
///
/// - The #GtkWidget::realize signal to take any necessary actions
/// when the widget is instantiated on a particular display.
/// (Create GDK resources in response to this signal.)
///
/// - The #GtkWidget::size-allocate signal to take any necessary
/// actions when the widget changes size.
///
/// - The #GtkWidget::draw signal to handle redrawing the
/// contents of the widget.
///
/// The following code portion demonstrates using a drawing
/// area to display a circle in the normal widget foreground
/// color.
///
/// Note that GDK automatically clears the exposed area before sending
/// the expose event, and that drawing is implicitly clipped to the exposed
/// area. If you want to have a theme-provided background, you need
/// to call gtk_render_background() in your ::draw method.
///
/// ## Simple GtkDrawingArea usage
///
/// |[<!-- language="C" -->
/// gboolean
/// draw_callback (GtkWidget *widget, cairo_t *cr, gpointer data)
/// {
/// guint width, height;
/// GdkRGBA color;
/// GtkStyleContext *context;
///
/// context = gtk_widget_get_style_context (widget);
///
/// width = gtk_widget_get_allocated_width (widget);
/// height = gtk_widget_get_allocated_height (widget);
///
/// gtk_render_background (context, cr, 0, 0, width, height);
///
/// cairo_arc (cr,
/// width / 2.0, height / 2.0,
/// MIN (width, height) / 2.0,
/// 0, 2 * G_PI);
///
/// gtk_style_context_get_color (context,
/// gtk_style_context_get_state (context),
/// &color);
/// gdk_cairo_set_source_rgba (cr, &color);
///
/// cairo_fill (cr);
///
/// return FALSE;
/// }
/// [...]
/// GtkWidget *drawing_area = gtk_drawing_area_new ();
/// gtk_widget_set_size_request (drawing_area, 100, 100);
/// g_signal_connect (G_OBJECT (drawing_area), "draw",
/// G_CALLBACK (draw_callback), NULL);
/// ]|
///
/// Draw signals are normally delivered when a drawing area first comes
/// onscreen, or when it’s covered by another window and then uncovered.
/// You can also force an expose event by adding to the “damage region”
/// of the drawing area’s window; gtk_widget_queue_draw_area() and
/// gdk_window_invalidate_rect() are equally good ways to do this.
/// You’ll then get a draw signal for the invalid region.
///
/// The available routines for drawing are documented on the
/// [GDK Drawing Primitives][gdk3-Cairo-Interaction] page
/// and the cairo documentation.
///
/// To receive mouse events on a drawing area, you will need to enable
/// them with gtk_widget_add_events(). To receive keyboard events, you
/// will need to set the “can-focus” property on the drawing area, and you
/// should probably draw some user-visible indication that the drawing
/// area is focused. Use gtk_widget_has_focus() in your expose event
/// handler to decide whether to draw the focus indicator. See
/// gtk_render_focus() for one way to draw focus.
open class DrawingArea: Widget {
    /// Creates a new drawing area.
    public convenience init() {
        self.init(
            gtk_drawing_area_new()
        )
    }

}
