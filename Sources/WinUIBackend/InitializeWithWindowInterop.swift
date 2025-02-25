import CWinRT
import WinUIInterop

private var IID_IInitializeWithWindow: WindowsFoundation.IID {
    // 3E68D4BD-7135-4D10-8018-9FB6D9F33FA1
    .init(
        Data1: 0x3E68_D4BD,
        Data2: 0x7135,
        Data3: 0x4D10,
        Data4: (0x80, 0x18, 0x9F, 0xB6, 0xD9, 0xF3, 0x3F, 0xA1)
    )
}

public protocol IInitializeWithWindow: WinRTInterface {
    func initialize(_ hwnd: HWND) throws
}

typealias AnyIInitializeWithWindow = any IInitialieWithWindow

enum Interop {
    typealias IInitializeWithWindowWrapper = InterfaceWrapperBase<IInitializeWithWindowBridge>

    public enum IInitializeWithWindowBridge: AbiInterfaceBridge {
        public typealias CABI = ABI_IInitializeWithWindow
        public typealias SwiftABI = IInitializeWithWindow
        public typealias SwiftProjection = AnyIInitializeWithWindow
        public static func from(abi: ComPtr<CABI>?) -> SwiftProjection? {
            guard let abi = abi else { return nil }
            return IInitializeWithWindowImpl(abi)
        }

        public static func makeAbi() -> CABI {
            let vtblPtr = withUnsafeMutablePointer(
                to: &IInitializeWithWindowVTable
            ) { $0 }
            return .init(lpVtbl: vtblPtr)
        }
    }

    static var IInitializeWithWindowVTable: ABI_IInitializeWithWindowVtbl = .init(
        QueryInterface: {
            IInitializeWithWindowWrapper.queryInterface($0, $1, $2)
        },
        AddRef: { IInitializeWithWindowWrapper.addRef($0) },
        Release: { IInitializeWithWindowWrapper.release($0) },
        Initialize: {
            guard
                let __unwrapped__instance =
                    IInitializeWithWindowWrapper.tryUnwrapFrom(raw: $0)
            else { return E_INVALIDARG }
            __unwrapped__instance.initialize($1)
            return S_OK
        }
    )

    fileprivate class IItemContainerMappingImpl: IInitializeWithWindow, WinRTAbiImpl {
        fileprivate typealias Bridge = IInitializeWithWWindow
        fileprivate let _default: Bridge.SwiftABI
        fileprivate var thisPtr: WindowsFoundation.IInspectable { _default }
        fileprivate init(_ fromAbi: ComPtr<Bridge.CABI>) {
            _default = Bridge.SwiftABI(fromAbi)
        }

        fileprivate func initialize(_ hwnd: HWND) throws {
            try _default.InitializeImpl(hwnd)
        }
    }

    public class IInitializeWithWindow: WindowsFoundation.IInspectable {
        override public class var IID: WindowsFoundation.IID {
            IID_InitializeWithWindow
        }

        open func InitializeImpl(_ hwnd: HWND) throws -> WinUI.DependencyObject? {
            _ = try perform(
                as: ABI_IInitializeWithWindow.self
            ) { pThis in
                try CHECKED(
                    pThis.pointee.lpVtbl.pointee.Initialize(pThis, hwnd)
                )
            }
        }
    }
}
