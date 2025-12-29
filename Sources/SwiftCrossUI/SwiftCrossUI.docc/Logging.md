# Logging

SwiftCrossUI's logging mechanism

SwiftCrossUI uses [swift-log](https://github.com/apple/swift-log) for logging
warnings. By default, it will log messages to the console; however, you can
use any swift-log backend you want.

To do so, add your backend of choice to your package dependencies, then call
`LoggingSystem.bootstrap(_:)` in your ``App``'s initializer. This initializer
is called before anything else happens, so you can also perform other early
setup tasks in here.

> Important: Calling `LoggingSystem.bootstrap(_:)` anywhere outside of
> ``App/init()`` will not correctly set the logging backend for SwiftCrossUI, as
> the library's internal logger is set up immediately after the initializer
> returns.
