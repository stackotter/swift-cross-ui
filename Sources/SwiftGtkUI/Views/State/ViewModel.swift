import Foundation

public protocol ViewModel: AnyObject {
    var didChange: Publisher { get }
}

extension ViewModel {
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
