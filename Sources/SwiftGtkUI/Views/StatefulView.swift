import Foundation
import OpenCombine

/// A view that has dynamic state. The view will get rerendered whenever a published member of the model changes.
public protocol StatefulView: View {
    associatedtype Model: ObservableObject
    
    var model: Model { get }
}
