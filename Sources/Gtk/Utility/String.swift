import Foundation

extension Collection where Element == UnsafePointer<CChar>? {
    /// Creates an UnsafeMutableBufferPointer with enough space to hold the elements of self.
    public func unsafeCopy() -> UnsafeMutableBufferPointer<Element> {
        let copy = UnsafeMutableBufferPointer<Element>.allocate(
            capacity: count + 1
        )
        _ = copy.initialize(from: self)
        copy[count] = nil
        return copy
    }
}

extension Collection where Element == CChar {
    /// Creates an UnsafeMutableBufferPointer with enough space to hold the elements of self.
    public func unsafeCopy() -> UnsafeMutableBufferPointer<Element> {
        let copy = UnsafeMutableBufferPointer<Element>.allocate(
            capacity: count + 1
        )
        _ = copy.initialize(from: self)
        copy[count] = 0
        return copy
    }
}

extension String {
    /// Create UnsafeMutableBufferPointer holding a null-terminated UTF8 copy of the string
    public func unsafeUTF8Copy() -> UnsafeMutableBufferPointer<CChar> {
        self.utf8CString.unsafeCopy()
    }
}
