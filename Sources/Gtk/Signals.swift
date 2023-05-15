//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

enum ConnectFlags {
    case after
    case swapped

    fileprivate func toGConnectFlags() -> GConnectFlags {
        switch self {
        case .after:
            return G_CONNECT_AFTER
        case .swapped:
            return G_CONNECT_SWAPPED
        }
    }
}

@discardableResult
func connectSignal<T>(_ instance: UnsafeMutablePointer<T>?, name: String, data: UnsafeRawPointer, connectFlags: ConnectFlags = .after, handler: @escaping GCallback) -> UInt {
    return .init(g_signal_connect_data(instance, name, handler, data.cast(), nil, connectFlags.toGConnectFlags()))
}

@discardableResult
func connectSignal<T>(_ instance: UnsafeMutablePointer<T>?, name: String, connectFlags: ConnectFlags = .after, handler: @escaping GCallback) -> UInt {
    return .init(g_signal_connect_data(instance, name, handler, nil, nil, connectFlags.toGConnectFlags()))
}

func disconnectSignal<T>(_ instance: UnsafeMutablePointer<T>?, handlerId: UInt) {
    g_signal_handler_disconnect(instance, .init(handlerId))
}
