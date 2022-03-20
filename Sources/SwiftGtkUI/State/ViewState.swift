import Foundation

public protocol ViewState: AnyObject {
    var didChange: Publisher { get }
}

extension ViewState {
    public var didChange: Publisher {
        let publisher = Publisher()
        var mirror: Mirror? = Mirror(reflecting: self)
        while let aClass = mirror {
            for (_, property) in aClass.children {
                guard let property = property as? PublishedValue else {
                    continue
                }
                
                publisher.link(toDownstream: property.publisher)
            }
            mirror = aClass.superclassMirror
        }
        return publisher
    }
}
