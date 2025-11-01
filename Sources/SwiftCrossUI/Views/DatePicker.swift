import Foundation

@available(tvOS, unavailable)
public struct DatePickerComponents: OptionSet, Sendable {
    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public init() {
        self.rawValue = 0
    }

    public static let date = DatePickerComponents(rawValue: 0x1C)
    public static let hourAndMinute = DatePickerComponents(rawValue: 0x60)

    @available(iOS, unavailable)
    @available(visionOS, unavailable)
    @available(macCatalyst, unavailable)
    public static let hourMinuteAndSecond = DatePickerComponents(rawValue: 0xE0)
}

@available(tvOS, unavailable)
public enum DatePickerStyle: Sendable, Hashable {
    case automatic

    @available(iOS 14, macCatalyst 14, *)
    case graphical

    @available(iOS 13.4, macCatalyst 13.4, *)
    case compact

    @available(iOS 13.4, macCatalyst 13.4, *)
    @available(macOS, unavailable)
    case wheel
}

@available(tvOS, unavailable)
public struct DatePicker<Label: View> {
    private var label: Label
    private var selection: Binding<Date>
    private var range: ClosedRange<Date>
    private var components: DatePickerComponents
    private var style: DatePickerStyle = .automatic

    public nonisolated init(
        selection: Binding<Date>,
        range: ClosedRange<Date> = Date.distantPast...Date.distantFuture,
        displayedComponents: DatePickerComponents = [.hourAndMinute, .date],
        @ViewBuilder label: () -> Label
    ) {
        self.label = label()
        self.selection = selection
        self.range = range
        self.components = displayedComponents
    }

    public nonisolated init(
        _ label: String,
        selection: Binding<Date>,
        range: ClosedRange<Date> = Date.distantPast...Date.distantFuture,
        displayedComponents: DatePickerComponents = [.hourAndMinute, .date]
    ) where Label == Text {
        self.label = Text(label)
        self.selection = selection
        self.range = range
        self.components = displayedComponents
    }

    public typealias Components = DatePickerComponents
}

@available(tvOS, unavailable)
extension DatePicker: View {
    public var body: some View {
        HStack {
            label

            DatePickerImplementation(selection: selection, range: range, components: components)
        }
    }
}

@available(tvOS, unavailable)
internal struct DatePickerImplementation: ElementaryView {
    @Binding private var selection: Date
    private var range: ClosedRange<Date>
    private var components: DatePickerComponents

    init(selection: Binding<Date>, range: ClosedRange<Date>, components: DatePickerComponents) {
        self._selection = selection
        self.range = range
        self.components = components
    }

    let body = EmptyView()

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createDatePicker()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        #if os(tvOS)
            preconditionFailure()
        #else
            if !dryRun {
                backend.updateDatePicker(
                    widget,
                    environment: environment,
                    date: selection,
                    range: range,
                    components: components,
                    onChange: { selection = $0 }
                )
            }

            // I reject your proposedSize and substitute my own
            let naturalSize = backend.naturalSize(of: widget)
            if !dryRun {
                backend.setSize(of: widget, to: naturalSize)
            }
            return ViewUpdateResult.leafView(size: ViewSize(fixedSize: naturalSize))
        #endif
    }
}
