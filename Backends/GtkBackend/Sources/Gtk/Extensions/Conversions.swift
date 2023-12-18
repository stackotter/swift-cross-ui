//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

extension gboolean {
    func toBool() -> Bool {
        return self >= 1
    }
}

extension Bool {
    func toGBoolean() -> gboolean {
        return self ? 1 : 0
    }
}

extension Int {
    func toBool() -> Bool {
        return self >= 1
    }
}

extension UnsafeMutablePointer {
    func cast<T>() -> UnsafeMutablePointer<T> {
        let pointer = UnsafeRawPointer(self).bindMemory(to: T.self, capacity: 1)
        return UnsafeMutablePointer<T>(mutating: pointer)
    }
}

extension UnsafeRawPointer {
    func cast<T>() -> UnsafeMutablePointer<T> {
        let pointer = UnsafeRawPointer(self).bindMemory(to: T.self, capacity: 1)
        return UnsafeMutablePointer<T>(mutating: pointer)
    }
}

extension UnsafeMutableRawPointer {
    func cast<T>() -> UnsafeMutablePointer<T> {
        let pointer = UnsafeRawPointer(self).bindMemory(to: T.self, capacity: 1)
        return UnsafeMutablePointer<T>(mutating: pointer)
    }
}
