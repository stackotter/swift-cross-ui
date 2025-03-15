import SwiftCrossUI
import UIKit

/// An item which can be displayed in a keyboard toolbar. Implementers of this do not have
/// to implement ``SwiftCrossUI/View``.
///
/// Toolbar items are expected to be "stateless". Mutations of `@State` properties of toolbar
/// items will not cause the toolbar to be updated. The toolbar is only updated when the view
/// containing the ``View/keyboardToolbar(animateChanges:body:)`` modifier is updated, so any
/// state necessary for the toolbar should live in the view itself.
public protocol ToolbarItem {
    /// Convert the item to a `UIBarButtonItem`, which will be placed in the keyboard toolbar.
    func asBarButtonItem() -> UIBarButtonItem
}

@resultBuilder
public enum ToolbarBuilder {
    public typealias Component = [any ToolbarItem]

    public static func buildExpression(_ expression: some ToolbarItem) -> Component {
        [expression]
    }

    public static func buildExpression(_ expression: any ToolbarItem) -> Component {
        [expression]
    }

    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [Component]) -> Component {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: Component?) -> Component {
        component ?? []
    }

    public static func buildEither(first component: Component) -> Component {
        component
    }

    public static func buildEither(second component: Component) -> Component {
        component
    }
}

final class CallbackBarButtonItem: UIBarButtonItem {
    private var callback: () -> Void

    init(title: String, callback: @escaping () -> Void) {
        self.callback = callback
        super.init()

        self.title = title
        self.target = self
        self.action = #selector(onTap)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not used for this item")
    }

    @objc
    func onTap() {
        callback()
    }
}

extension Button: ToolbarItem {
    public func asBarButtonItem() -> UIBarButtonItem {
        CallbackBarButtonItem(title: label, callback: action)
    }
}

@available(iOS 14, macCatalyst 14, tvOS 14, *)
extension Spacer: ToolbarItem {
    public func asBarButtonItem() -> UIBarButtonItem {
        if let minLength, minLength > 0 {
            print(
                """
                Warning: Spacer's minLength property is ignored within keyboard toolbars \
                due to UIKit limitations. Use `Spacer()` for unconstrained spacers and \
                `Spacer().frame(width: _)` for fixed-length spacers.
                """
            )
        }
        return .flexibleSpace()
    }
}

struct FixedWidthToolbarItem<Base: ToolbarItem>: ToolbarItem {
    var base: Base
    var width: Int?

    func asBarButtonItem() -> UIBarButtonItem {
        let item = base.asBarButtonItem()
        if let width {
            item.width = CGFloat(width)
        }
        return item
    }
}

// Setting width on a flexible space is ignored, you must use a fixed space from the outset
@available(iOS 14, macCatalyst 14, tvOS 14, *)
struct FixedWidthSpacerItem: ToolbarItem {
    var width: Int?

    func asBarButtonItem() -> UIBarButtonItem {
        if let width {
            .fixedSpace(CGFloat(width))
        } else {
            .flexibleSpace()
        }
    }
}

struct ColoredToolbarItem<Base: ToolbarItem>: ToolbarItem {
    var base: Base
    var color: Color

    func asBarButtonItem() -> UIBarButtonItem {
        let item = base.asBarButtonItem()
        item.tintColor = color.uiColor
        return item
    }
}

extension ToolbarItem {
    /// A toolbar item with the specified width.
    ///
    /// If `width` is positive, the item will have that exact width. If `width` is zero or
    /// nil, the item will have its natural size.
    public func frame(width: Int?) -> any ToolbarItem {
        if #available(iOS 14, macCatalyst 14, tvOS 14, *),
            self is Spacer || self is FixedWidthSpacerItem
        {
            FixedWidthSpacerItem(width: width)
        } else {
            FixedWidthToolbarItem(base: self, width: width)
        }
    }

    /// A toolbar item with the specified foreground color.
    public func foregroundColor(_ color: Color) -> some ToolbarItem {
        ColoredToolbarItem(base: self, color: color)
    }
}

enum ToolbarKey: EnvironmentKey {
    static let defaultValue: ((UIToolbar) -> Void)? = nil
}

extension EnvironmentValues {
    var updateToolbar: ((UIToolbar) -> Void)? {
        get { self[ToolbarKey.self] }
        set { self[ToolbarKey.self] = newValue }
    }
}

extension View {
    /// Set a toolbar that will be shown above the keyboard for text fields within this view.
    /// - Parameters:
    ///   - animateChanges: Whether to animate updates when an item is added, removed, or
    ///     updated
    ///   - body: The toolbar's contents
    public func keyboardToolbar(
        animateChanges: Bool = true,
        @ToolbarBuilder body: @escaping () -> ToolbarBuilder.Component
    ) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.updateToolbar) { toolbar in
                toolbar.setItems(body().map { $0.asBarButtonItem() }, animated: animateChanges)
                toolbar.sizeToFit()
            }
        }
    }
}
