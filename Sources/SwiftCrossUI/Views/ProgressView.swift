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

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let naturalSize = backend.naturalSize(of: widget)

        guard isResizable else {
            return ViewLayoutResult.leafView(size: ViewSize(naturalSize))
        }

        let dimension: Double

        if let proposedWidth = proposedSize.width, let proposedHeight = proposedSize.height {
            dimension = min(proposedWidth, proposedHeight)
        } else if let proposedWidth = proposedSize.width {
            dimension = proposedWidth
        } else if let proposedHeight = proposedSize.height {
            dimension = proposedHeight
        } else {
            dimension = Double(min(naturalSize.x, naturalSize.y))
        }

        return ViewLayoutResult.leafView(
            size: ViewSize(dimension, dimension)
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        // Doesn't change the rendered size of ProgressSpinner
        // on UIKitBackend, but still sets container size to
        // (width: n, height: n) n = min(proposedSize.x, proposedSize.y)
        backend.setSize(ofProgressSpinner: widget, to: layout.size.vector)
    }
}

struct ProgressBarView: ElementaryView {
    /// The ideal width of a ProgressBarView.
    static let idealWidth: Double = 100

    var value: Double?

    init(value: Double?) {
        self.value = value
    }

    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createProgressBar()
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let height = backend.naturalSize(of: widget).y
        let size = ViewSize(
            proposedSize.width ?? Self.idealWidth,
            Double(height)
        )

        return ViewLayoutResult.leafView(size: size)
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        backend.updateProgressBar(widget, progressFraction: value, environment: environment)
        backend.setSize(of: widget, to: layout.size.vector)
    }
}
