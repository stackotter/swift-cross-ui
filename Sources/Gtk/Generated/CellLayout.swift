import CGtk

/// An interface for packing cells
///
/// `GtkCellLayout` is an interface to be implemented by all objects which
/// want to provide a `GtkTreeViewColumn` like API for packing cells,
/// setting attributes and data funcs.
///
/// One of the notable features provided by implementations of
/// `GtkCellLayout` are attributes. Attributes let you set the properties
/// in flexible ways. They can just be set to constant values like regular
/// properties. But they can also be mapped to a column of the underlying
/// tree model with gtk_cell_layout_set_attributes(), which means that the value
/// of the attribute can change from cell to cell as they are rendered by
/// the cell renderer. Finally, it is possible to specify a function with
/// gtk_cell_layout_set_cell_data_func() that is called to determine the
/// value of the attribute for each cell that is rendered.
///
/// ## GtkCellLayouts as GtkBuildable
///
/// Implementations of GtkCellLayout which also implement the GtkBuildable
/// interface (`GtkCellView`, `GtkIconView`, `GtkComboBox`,
/// `GtkEntryCompletion`, `GtkTreeViewColumn`) accept `GtkCellRenderer` objects
/// as `<child>` elements in UI definitions. They support a custom `<attributes>`
/// element for their children, which can contain multiple `<attribute>`
/// elements. Each `<attribute>` element has a name attribute which specifies
/// a property of the cell renderer; the content of the element is the
/// attribute value.
///
/// This is an example of a UI definition fragment specifying attributes:
///
/// ```xml
/// <object class="GtkCellView"><child><object class="GtkCellRendererText"/><attributes><attribute name="text">0</attribute></attributes></child></object>
/// ```
///
/// Furthermore for implementations of `GtkCellLayout` that use a `GtkCellArea`
/// to lay out cells (all `GtkCellLayout`s in GTK use a `GtkCellArea`)
/// [cell properties](class.CellArea.html#cell-properties) can also be defined
/// in the format by specifying the custom `<cell-packing>` attribute which can
/// contain multiple `<property>` elements.
///
/// Here is a UI definition fragment specifying cell properties:
///
/// ```xml
/// <object class="GtkTreeViewColumn"><child><object class="GtkCellRendererText"/><cell-packing><property name="align">True</property><property name="expand">False</property></cell-packing></child></object>
/// ```
///
/// ## Subclassing GtkCellLayout implementations
///
/// When subclassing a widget that implements `GtkCellLayout` like
/// `GtkIconView` or `GtkComboBox`, there are some considerations related
/// to the fact that these widgets internally use a `GtkCellArea`.
/// The cell area is exposed as a construct-only property by these
/// widgets. This means that it is possible to e.g. do
///
/// ```c
/// GtkWIdget *combo =
/// g_object_new (GTK_TYPE_COMBO_BOX, "cell-area", my_cell_area, NULL);
/// ```
///
/// to use a custom cell area with a combo box. But construct properties
/// are only initialized after instance `init()`
/// functions have run, which means that using functions which rely on
/// the existence of the cell area in your subclass `init()` function will
/// cause the default cell area to be instantiated. In this case, a provided
/// construct property value will be ignored (with a warning, to alert
/// you to the problem).
///
/// ```c
/// static void
/// my_combo_box_init (MyComboBox *b)
/// {
/// GtkCellRenderer *cell;
///
/// cell = gtk_cell_renderer_pixbuf_new ();
///
/// // The following call causes the default cell area for combo boxes,
/// // a GtkCellAreaBox, to be instantiated
/// gtk_cell_layout_pack_start (GTK_CELL_LAYOUT (b), cell, FALSE);
/// ...
/// }
///
/// GtkWidget *
/// my_combo_box_new (GtkCellArea *area)
/// {
/// // This call is going to cause a warning about area being ignored
/// return g_object_new (MY_TYPE_COMBO_BOX, "cell-area", area, NULL);
/// }
/// ```
///
/// If supporting alternative cell areas with your derived widget is
/// not important, then this does not have to concern you. If you want
/// to support alternative cell areas, you can do so by moving the
/// problematic calls out of `init()` and into a `constructor()`
/// for your class.
public protocol CellLayout: GObjectRepresentable {

}
