import CGtk3

/// A #GtkMenuShell is the abstract base class used to derive the
/// #GtkMenu and #GtkMenuBar subclasses.
///
/// A #GtkMenuShell is a container of #GtkMenuItem objects arranged
/// in a list which can be navigated, selected, and activated by the
/// user to perform application functions. A #GtkMenuItem can have a
/// submenu associated with it, allowing for nested hierarchical menus.
///
/// # Terminology
///
/// A menu item can be “selected”, this means that it is displayed
/// in the prelight state, and if it has a submenu, that submenu
/// will be popped up.
///
/// A menu is “active” when it is visible onscreen and the user
/// is selecting from it. A menubar is not active until the user
/// clicks on one of its menuitems. When a menu is active,
/// passing the mouse over a submenu will pop it up.
///
/// There is also is a concept of the current menu and a current
/// menu item. The current menu item is the selected menu item
/// that is furthest down in the hierarchy. (Every active menu shell
/// does not necessarily contain a selected menu item, but if
/// it does, then the parent menu shell must also contain
/// a selected menu item.) The current menu is the menu that
/// contains the current menu item. It will always have a GTK
/// grab and receive all key presses.
open class MenuShell: Container {

    override func didMoveToParent() {
        super.didMoveToParent()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, Bool, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<Bool>.run(data, value1)
                }

        addSignal(name: "activate-current", handler: gCallback(handler0)) {
            [weak self] (param0: Bool) in
            guard let self = self else { return }
            self.activateCurrent?(self, param0)
        }

        addSignal(name: "cancel") { [weak self] () in
            guard let self = self else { return }
            self.cancel?(self)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, GtkDirectionType, UnsafeMutableRawPointer) ->
                Void =
                { _, value1, data in
                    SignalBox1<GtkDirectionType>.run(data, value1)
                }

        addSignal(name: "cycle-focus", handler: gCallback(handler2)) {
            [weak self] (param0: GtkDirectionType) in
            guard let self = self else { return }
            self.cycleFocus?(self, param0)
        }

        addSignal(name: "deactivate") { [weak self] () in
            guard let self = self else { return }
            self.deactivate?(self)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, GtkWidget, Int, UnsafeMutableRawPointer) ->
                Void =
                { _, value1, value2, data in
                    SignalBox2<GtkWidget, Int>.run(data, value1, value2)
                }

        addSignal(name: "insert", handler: gCallback(handler4)) {
            [weak self] (param0: GtkWidget, param1: Int) in
            guard let self = self else { return }
            self.insert?(self, param0, param1)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, GtkMenuDirectionType, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<GtkMenuDirectionType>.run(data, value1)
                }

        addSignal(name: "move-current", handler: gCallback(handler5)) {
            [weak self] (param0: GtkMenuDirectionType) in
            guard let self = self else { return }
            self.moveCurrent?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, Int, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<Int>.run(data, value1)
                }

        addSignal(name: "move-selected", handler: gCallback(handler6)) {
            [weak self] (param0: Int) in
            guard let self = self else { return }
            self.moveSelected?(self, param0)
        }

        addSignal(name: "selection-done") { [weak self] () in
            guard let self = self else { return }
            self.selectionDone?(self)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::take-focus", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTakeFocus?(self, param0)
        }
    }

    /// An action signal that activates the current menu item within
    /// the menu shell.
    public var activateCurrent: ((MenuShell, Bool) -> Void)?

    /// An action signal which cancels the selection within the menu shell.
    /// Causes the #GtkMenuShell::selection-done signal to be emitted.
    public var cancel: ((MenuShell) -> Void)?

    /// A keybinding signal which moves the focus in the
    /// given @direction.
    public var cycleFocus: ((MenuShell, GtkDirectionType) -> Void)?

    /// This signal is emitted when a menu shell is deactivated.
    public var deactivate: ((MenuShell) -> Void)?

    /// The ::insert signal is emitted when a new #GtkMenuItem is added to
    /// a #GtkMenuShell.  A separate signal is used instead of
    /// GtkContainer::add because of the need for an additional position
    /// parameter.
    ///
    /// The inverse of this signal is the GtkContainer::removed signal.
    public var insert: ((MenuShell, GtkWidget, Int) -> Void)?

    /// An keybinding signal which moves the current menu item
    /// in the direction specified by @direction.
    public var moveCurrent: ((MenuShell, GtkMenuDirectionType) -> Void)?

    /// The ::move-selected signal is emitted to move the selection to
    /// another item.
    public var moveSelected: ((MenuShell, Int) -> Void)?

    /// This signal is emitted when a selection has been
    /// completed within a menu shell.
    public var selectionDone: ((MenuShell) -> Void)?

    public var notifyTakeFocus: ((MenuShell, OpaquePointer) -> Void)?
}
