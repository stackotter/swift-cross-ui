//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

protocol SignalBox {
    associatedtype CallbackType

    var callback: CallbackType { get }

    init(callback: CallbackType)
}

typealias SignalCallbackZero = () -> Void
typealias SignalCallbackOne = (UnsafeMutableRawPointer) -> Void
typealias SignalCallbackTwo = (UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Void
typealias SignalCallbackThree = (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Void
typealias SignalCallbackFour = (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Void
typealias SignalCallbackFive = (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Void
typealias SignalCallbackSix = (UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer) -> Void

/// Provides a box that captures a callback for a signal so it makes easier to add signals.
class SignalBoxZero: SignalBox {
    typealias CallbackType = SignalCallbackZero

    let callback: CallbackType

    required init(callback: @escaping CallbackType) {
        self.callback = callback
    }
}

class SignalBoxOne: SignalBox {
    typealias CallbackType = SignalCallbackOne

    let callback: CallbackType

    required init(callback: @escaping CallbackType) {
        self.callback = callback
    }
}

class SignalBoxTwo: SignalBox {
    typealias CallbackType = SignalCallbackTwo

    let callback: CallbackType

    required init(callback: @escaping CallbackType) {
        self.callback = callback
    }
}

class SignalBoxThree: SignalBox {
    typealias CallbackType = SignalCallbackThree

    let callback: CallbackType

    required init(callback: @escaping CallbackType) {
        self.callback = callback
    }
}

class SignalBoxFour: SignalBox {
    typealias CallbackType = SignalCallbackFour

    let callback: CallbackType

    required init(callback: @escaping CallbackType) {
        self.callback = callback
    }
}

class SignalBoxFive: SignalBox {
    typealias CallbackType = SignalCallbackFive

    let callback: CallbackType

    required init(callback: @escaping CallbackType) {
        self.callback = callback
    }
}

class SignalBoxSix: SignalBox {
    typealias CallbackType = SignalCallbackSix

    let callback: CallbackType

    required init(callback: @escaping CallbackType) {
        self.callback = callback
    }
}
