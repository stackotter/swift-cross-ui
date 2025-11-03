import Foundation

public struct ProgressView<Label: View>: View {
    private var label: Label
    private var progress: Double?
    private var kind: Kind
    private var isSpinnerResizable: Bool = false

    private enum Kind {
        case spinner
        case bar
    }

    public var body: some View {
        if label as? EmptyView == nil {
            progressIndicator
            label
        } else {
            progressIndicator
        }
    }

    @ViewBuilder
    private var progressIndicator: some View {
        switch kind {
            case .spinner:
                ProgressSpinnerView(isResizable: isSpinnerResizable)
            case .bar:
                ProgressBarView(value: progress)
        }
    }

    public init(_ label: Label) {
        self.label = label
        self.kind = .spinner
    }

    public init(_ label: Label, _ progress: Progress) {
        self.label = label
        self.kind = .bar

        if !progress.isIndeterminate {
            self.progress = progress.fractionCompleted
        }
    }

    /// Creates a progress bar view. If `value` is `nil`, an indeterminate progress
    /// bar will be shown.
    public init<Value: BinaryFloatingPoint>(_ label: Label, value: Value?) {
        self.label = label
        self.kind = .bar
        self.progress = value.map(Double.init)
    }

    /// Makes the ProgressView resize to fit the available space.
    /// Only affects ``Kind/spinner``.
    public func resizable(_ isResizable: Bool = true) -> Self {
        var progressView = self
        progressView.isSpinnerResizable = isResizable
        return progressView
    }
}

extension ProgressView where Label == EmptyView {
    public init() {
        self.label = EmptyView()
        self.kind = .spinner
    }

    public init(_ progress: Progress) {
        self.label = EmptyView()
        self.kind = .bar

        if !progress.isIndeterminate {
            self.progress = progress.fractionCompleted
        }
    }

    /// Creates a progress bar view. If `value` is `nil`, an indeterminate progress
    /// bar will be shown.
    public init<Value: BinaryFloatingPoint>(value: Value?) {
        self.label = EmptyView()
        self.kind = .bar
        self.progress = value.map(Double.init)
    }
}

extension ProgressView where Label == Text {
    public init(_ label: String) {
        self.label = Text(label)
        self.kind = .spinner
    }

    public init(_ label: String, _ progress: Progress) {
        self.label = Text(label)
        self.kind = .bar

        if !progress.isIndeterminate {
            self.progress = progress.fractionCompleted
        }
    }

    /// Creates a progress bar view. If `value` is `nil`, an indeterminate progress
    /// bar will be shown.
    public init<Value: BinaryFloatingPoint>(_ label: String, value: Value?) {
        self.label = Text(label)
        self.kind = .bar
        self.progress = value.map(Double.init)
    }
}

struct ProgressSpinnerView: ElementaryView {
    let isResizable: Bool

    init(isResizable: Bool = false) {
        self.isResizable = isResizable
    }

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createProgressSpinner()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let naturalSize = backend.naturalSize(of: widget)
        guard isResizable else {
            // Required to reset its size when resizability
            // gets changed at runtime
            backend.setSize(of: widget, to: naturalSize)
            return ViewUpdateResult.leafView(size: ViewSize(fixedSize: naturalSize))
        }
        let minimumDimension = max(min(proposedSize.x, proposedSize.y), 10)
        let size = SIMD2(
            minimumDimension,
            minimumDimension
        )
        if !dryRun {
            // Doesn't change the rendered size of ProgressSpinner
            // on UIKitBackend, but still sets container size to
            // (width: n, height: n) n = min(proposedSize.x, proposedSize.y)
            backend.setSize(of: widget, to: size)
        }
        return ViewUpdateResult.leafView(
            size: ViewSize(
                size: size,
                idealSize: naturalSize,
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            )
        )
    }
}

struct ProgressBarView: ElementaryView {
    var value: Double?

    init(value: Double?) {
        self.value = value
    }

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createProgressBar()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let height = backend.naturalSize(of: widget).y
        let size = SIMD2(
            proposedSize.x,
            height
        )

        if !dryRun {
            backend.updateProgressBar(widget, progressFraction: value, environment: environment)
            backend.setSize(of: widget, to: size)
        }

        return ViewUpdateResult.leafView(
            size: ViewSize(
                size: size,
                idealSize: SIMD2(100, height),
                minimumWidth: 0,
                minimumHeight: height,
                maximumWidth: nil,
                maximumHeight: Double(height)
            )
        )
    }
}
