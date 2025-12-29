# Logging

SwiftCrossUI's logging mechanism

SwiftCrossUI uses [swift-log](https://github.com/apple/swift-log) for logging
warnings. By default, it will log messages to the console; however, you can
use any log handler you want. To do so, add your handler of choice to your
package dependencies, then implement ``App/logHandler(label:metadataProvider:)-9yiqb``
in your ``App`` conformance.

- Tip: If you wish to use a separate log handler for any other libraries you may
  use in your application, you can simply call `LoggingSystem.bootstrap(_:)` in
  ``App/init()`` and pass it that handler. SwiftCrossUI provides the handler
  returned by ``App/logHandler(label:metadataProvider:)-9yiqb`` directly to
  its global `Logger` instance, and does not call `bootstrap(_:)` at any point.
