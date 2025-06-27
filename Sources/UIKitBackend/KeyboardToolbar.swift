import SwiftCrossUI
import UIKit

/// An item which can be displayed in a keyboard toolbar. Implementers of this do not have
/// to implement ``SwiftCrossUI/View``.
///
/// Toolbar items are expected to be "stateless". Mutations of `@State` properties of toolbar
/// items will not cause the toolbar to be updated. The toolbar is only updated when the view
/// containing the ``View/keyboardToolbar(animateChanges:body:)`` modifier is updated, so any
/// state necessary for the toolbar should live in the view itself.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public protocol ToolbarItem {
    /// The type of bar button item used to represent this item in UIKit.
    associatedtype ItemType: UIBarButtonItem

    /// Convert the item to an instance of `ItemType`.
    @MainActor
    func createBarButtonItem() -> ItemType

    /// Update the item with new information (e.g. updated bindings). May be a no-op.
    @MainActor
    func updateBarButtonItem(_ item: inout ItemType)
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
@resultBuilder
public enum ToolbarBuilder {
    public enum Component {
        case expression(any ToolbarItem)
        case block([Component])
        case array([Component])
        indirect case optional(Component?)
        indirect case eitherFirst(Component)
        indirect case eitherSecond(Component)
    }
    public typealias FinalResult = Component

    public static func buildExpression(_ expression: any ToolbarItem) -> Component {
        .expression(expression)
    }

    public static func buildBlock(_ components: Component...) -> Component {
        .block(components)
    }

    public static func buildArray(_ components: [Component]) -> Component {
        .array(components)
    }

    public static func buildOptional(_ component: Component?) -> Component {
        .optional(component)
    }

    public static func buildEither(first component: Component) -> Component {
        .eitherFirst(component)
    }

    public static func buildEither(second component: Component) -> Component {
        .eitherSecond(component)
    }
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension Button: ToolbarItem {
    public final class ItemType: UIBarButtonItem {
        var callback: @MainActor @Sendable () -> Void

        init(title: String, callback: @escaping @MainActor @Sendable () -> Void) {
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

    public func createBarButtonItem() -> ItemType {
        ItemType(title: label, callback: action)
    }

    public func updateBarButtonItem(_ item: inout ItemType) {
        item.callback = action
        item.title = label
    }
}

// Despite the fact that this is unavailable on tvOS, the `introduced: 14`
// clause is required for all current Swift versions to accept it.
// See https://forums.swift.org/t/contradictory-available-s-are-required/78831
@available(iOS 14, macCatalyst 14, *)
@available(tvOS, unavailable, introduced: 14)
@available(visionOS, unavailable)
extension Spacer: ToolbarItem {
    public func createBarButtonItem() -> UIBarButtonItem {
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

    public func updateBarButtonItem(_: inout UIBarButtonItem) {
        // no-op
    }
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
struct FixedWidthToolbarItem<Base: ToolbarItem>: ToolbarItem {
    var base: Base
    var width: Int?

    func createBarButtonItem() -> Base.ItemType {
        let item = base.createBarButtonItem()
        if let width {
            item.width = CGFloat(width)
        }
        return item
    }

    func updateBarButtonItem(_ item: inout Base.ItemType) {
        base.updateBarButtonItem(&item)
        if let width {
            item.width = CGFloat(width)
        }
    }
}

// Setting width on a flexible space is ignored, you must use a fixed space from the outset
@available(iOS 14, macCatalyst 14, *)
@available(tvOS, unavailable, introduced: 14)
@available(visionOS, unavailable)
struct FixedWidthSpacerItem: ToolbarItem {
    var width: Int?

    func createBarButtonItem() -> UIBarButtonItem {
        if let width {
            .fixedSpace(CGFloat(width))
        } else {
            .flexibleSpace()
        }
    }

    func updateBarButtonItem(_ item: inout UIBarButtonItem) {
        item = createBarButtonItem()
    }
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
struct ColoredToolbarItem<Base: ToolbarItem>: ToolbarItem {
    var base: Base
    var color: Color

    func createBarButtonItem() -> Base.ItemType {
        let item = base.createBarButtonItem()
        item.tintColor = color.uiColor
        return item
    }

    func updateBarButtonItem(_ item: inout Base.ItemType) {
        base.updateBarButtonItem(&item)
        item.tintColor = color.uiColor
    }
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension ToolbarItem {
    /// A toolbar item with the specified width.
    ///
    /// If `width` is positive, the item will have that exact width. If `width` is zero or
    /// nil, the item will have its natural size.
    public func frame(width: Int?) -> any ToolbarItem {
        if #available(iOS 14, macCatalyst 14, *),
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

@available(tvOS, unavailable)
@available(visionOS, unavailable)
indirect enum ToolbarItemLocation: Hashable {
    case expression(inside: ToolbarItemLocation?)
    case block(index: Int, inside: ToolbarItemLocation?)
    case array(index: Int, inside: ToolbarItemLocation?)
    case optional(inside: ToolbarItemLocation?)
    case eitherFirst(inside: ToolbarItemLocation?)
    case eitherSecond(inside: ToolbarItemLocation?)
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
final class KeyboardToolbar: UIToolbar {
    var locations: [ToolbarItemLocation: UIBarButtonItem] = [:]

    func setItems(
        _ components: ToolbarBuilder.FinalResult,
        animated: Bool
    ) {
        var newItems: [UIBarButtonItem] = []
        var newLocations: [ToolbarItemLocation: UIBarButtonItem] = [:]

        visitItems(component: components, inside: nil) { location, expression in
            let item =
                if let oldItem = locations[location] {
                    updateErasedItem(expression, oldItem)
                } else {
                    expression.createBarButtonItem()
                }

            newItems.append(item)
            newLocations[location] = item
        }

        super.setItems(newItems, animated: animated)
        self.locations = newLocations
    }

    /// Used to open the existential to call ``ToolbarItem/updateBarButtonItem(_:)``.
    private func updateErasedItem<T: ToolbarItem>(_ expression: T, _ item: UIBarButtonItem)
        -> UIBarButtonItem
    {
        if var castedItem = item as? T.ItemType {
            expression.updateBarButtonItem(&castedItem)
            return castedItem
        } else {
            return expression.createBarButtonItem()
        }
    }

    /// DFS on the `component` tree
    private func visitItems(
        component: ToolbarBuilder.Component,
        inside container: ToolbarItemLocation?,
        callback: (ToolbarItemLocation, any ToolbarItem) -> Void
    ) {
        switch component {
            case .expression(let expression):
                callback(.expression(inside: container), expression)
            case .block(let elements):
                for (i, element) in elements.enumerated() {
                    visitItems(
                        component: element, inside: .block(index: i, inside: container),
                        callback: callback)
                }
            case .array(let elements):
                for (i, element) in elements.enumerated() {
                    visitItems(
                        component: element, inside: .array(index: i, inside: container),
                        callback: callback)
                }
            case .optional(let element):
                if let element {
                    visitItems(
                        component: element, inside: .optional(inside: container), callback: callback
                    )
                }
            case .eitherFirst(let element):
                visitItems(
                    component: element, inside: .eitherFirst(inside: container), callback: callback)
            case .eitherSecond(let element):
                visitItems(
                    component: element, inside: .eitherSecond(inside: container), callback: callback
                )
        }
    }
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
enum ToolbarKey: EnvironmentKey {
    static let defaultValue: ((KeyboardToolbar) -> Void)? = nil
}

@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension EnvironmentValues {
    var updateToolbar: ((KeyboardToolbar) -> Void)? {
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
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public func keyboardToolbar(
        animateChanges: Bool = true,
        @ToolbarBuilder body: @escaping () -> ToolbarBuilder.FinalResult
    ) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.updateToolbar) { toolbar in
                toolbar.setItems(body(), animated: animateChanges)
                toolbar.sizeToFit()
            }
        }
    }
}
