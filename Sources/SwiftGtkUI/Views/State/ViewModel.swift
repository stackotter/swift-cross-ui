import Foundation

public protocol ViewModel: AnyObject {
    var didChange: Publisher { get }
}

public protocol PublishedValue {
    var publisher: Publisher { get }
}

extension ViewModel {
    public var didChange: Publisher {
        let publisher = Publisher()
        var mirror: Mirror? = Mirror(reflecting: self)
        while let aClass = mirror {
            for (name, property) in aClass.children {
                guard let property = property as? PublishedValue else {
                    print("Skipping \(name)")
                    continue
                }
                
                print("Observing \(name)")
                
                publisher.link(toDownstream: property.publisher)
            }
            mirror = aClass.superclassMirror
        }
        return publisher
    }
}

public class Publisher {
    private var observations = List<() -> Void>()
    private var cancellables: [Cancellable] = []
    
    public init() {}
    
    public func send() {
        DispatchQueue.main.async {
            for observation in self.observations {
                observation()
            }
        }
    }
    
    public func observe(with closure: @escaping () -> Void) -> Cancellable {
        let node = observations.append(closure)
        
        return Cancellable { [weak self] in
            self?.observations.remove(node)
            for cancellable in self?.cancellables ?? [] {
                cancellable.cancel()
            }
        }
    }
    
    public func link(toDownstream publisher: Publisher) {
        cancellables.append(publisher.observe(with: {
            self.send()
        }))
    }
}

@propertyWrapper
public struct Observed<Value>: PublishedValue {
    public var projectedValue: Publisher {
        publisher
    }
    
    public var wrappedValue: Value {
        didSet {
            valueDidChange()
        }
    }
    
    public var publisher = Publisher()
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    public func valueDidChange() {
        publisher.send()
    }
}

public class Cancellable {
    private var closure: (() -> Void)?
    
    public init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    deinit {
        cancel()
    }
    
    public func cancel() {
        closure?()
        closure = nil
    }
}

public struct List<Value> {
    public private(set) var firstNode: Node?
    public private(set) var lastNode: Node?
}

public extension List {
    class Node {
        var value: Value
        fileprivate(set) weak var previous: Node?
        fileprivate(set) var next: Node?
        
        init(value: Value) {
            self.value = value
        }
    }
}

extension List: Sequence {
    public func makeIterator() -> AnyIterator<Value> {
        var node = firstNode
        
        return AnyIterator {
            // Iterate through all of our nodes by continuously
            // moving to the next one and extract its value:
            let value = node?.value
            node = node?.next
            return value
        }
    }
}

public extension List {
    @discardableResult
    mutating func append(_ value: Value) -> Node {
        let node = Node(value: value)
        node.previous = lastNode
        
        lastNode?.next = node
        lastNode = node
        
        if firstNode == nil {
            firstNode = node
        }
        
        return node
    }
}

public extension List {
    mutating func remove(_ node: Node) {
        node.previous?.next = node.next
        node.next?.previous = node.previous
        
        // Using "triple-equals" we can compare two class
        // instances by identity, rather than by value:
        if firstNode === node {
            firstNode = node.next
        }
        
        if lastNode === node {
            lastNode = node.previous
        }
        
        // Completely disconnect the node by removing its
        // sibling references:
        node.next = nil
        node.previous = nil
    }
}
