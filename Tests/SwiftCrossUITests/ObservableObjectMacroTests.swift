import Testing
import SwiftSyntaxMacrosTestSupport
import SwiftSyntaxMacros

#if canImport(SCUIMacrosPlugin)
import SwiftCrossUIMacrosPlugin

let testMacros: [String: Macro.Type] = [
    "ObservableObject": ObservableObjectMacro.self,
    "ObservationIgnored": ObservationIgnoredMacro.self
]
#endif

@Suite("Testing @ObservableObject Macro")
struct ObservableTests {
    @Test("Stored property gets Published")
    func testStoredPropertyGetsAttribute() {
        assertMacroExpansion(
            """
            @ObservableObject
            class ViewModel {
                var name: String = ""
            }
            """,
            expandedSource: """
            class ViewModel {
                @SwiftCrossUI.Published
                var name: String = ""
            }
            
            extension ViewModel: SwiftCrossUI.ObservableObject {
            }
            """,
            macros: testMacros
        )
    }
    
    @Test("Computed property gets skipped")
    func testComputedPropertyIsIgnored() {
        assertMacroExpansion(
            """
            @ObservableObject
            class ViewModel {
                var computed: Int { 1 + 1 }
                var explicitGet: Int { get { 0 } }
            }
            """,
            expandedSource: """
            class ViewModel {
                var computed: Int { 1 + 1 }
                var explicitGet: Int { get { 0 } }
            }
            
            extension ViewModel: SwiftCrossUI.ObservableObject {
            }
            """,
            macros: testMacros
        )
    }
    
    @Test("Stored property with observers gets attribute")
    func testPropertyWithObserversGetsAttribute() {
        assertMacroExpansion(
            """
            @ObservableObject
            class ViewModel {
                var observed: String = "" {
                    didSet { print("changed") }
                }
            }
            """,
            expandedSource: """
            class ViewModel {
                @SwiftCrossUI.Published
                var observed: String = "" {
                    didSet { print("changed") }
                }
            }
            
            extension ViewModel: SwiftCrossUI.ObservableObject {
            }
            """,
            macros: testMacros
        )
    }
    
    @Test("Private and static  properties are ignored")
    func testPrivateAndStaticAreIgnored() {
        assertMacroExpansion(
            """
            @ObservableObject
            class ViewModel {
                private var secret = "shh"
                static var shared = "info"
                private(set) var readOnly = "safe"
            }
            """,
            expandedSource: """
            class ViewModel {
                private var secret = "shh"
                static var shared = "info"
                private(set) var readOnly = "safe"
            }
            
            extension ViewModel: SwiftCrossUI.ObservableObject {
            }
            """,
            macros: testMacros
        )
    }
    
    @Test("ObservationIgnored is honored")
    func testObservationIgnoredIsHonored() {
        assertMacroExpansion(
            """
            @ObservableObject
            class ViewModel {
                @ObservationIgnored var skipMe = false
            }
            """,
            expandedSource: """
            class ViewModel {
                @ObservationIgnored var skipMe = false
            }
            
            extension ViewModel: SwiftCrossUI.ObservableObject {
            }
            """,
            macros: testMacros
        )
    }
    
    @Test("Multiple Bindings throw Error")
    func testMultipleBindingsThrowError() {
        assertMacroExpansion(
            """
            @ObservableObject
            class ViewModel {
                var a, b: String
            }
            """,
            expandedSource: """
            class ViewModel {
                var a, b: String
            }
            
            extension ViewModel: SwiftCrossUI.ObservableObject {
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@ObservableObject only supports single variables. Split up your variable declaration or ignore it with @ObservationIgnored",
                    line: 3,
                    column: 5
                )
            ],
            macros: testMacros
        )
    }
}
