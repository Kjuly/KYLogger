# KYLogger

A local system logger for Apple platforms.

This lightweight logging lib is serverless. It includes a debug logger and a file logger which will save logs locally on the device. Users can choose to send a log file when a bug is reported.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKjuly%2FKYLogger%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Kjuly/KYLogger)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKjuly%2FKYLogger%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Kjuly/KYLogger)  
![macOS][macOS-Badge] ![iOS][iOS-Badge] ![watchOS][watchOS-Badge]  
[![SPM][SPM-Badge]][SPM-Link] [![CocoaPods][CocoaPods-Badge]][CocoaPods-Link] [![Carthage][Carthage-Badge]][Carthage-Link]

[macOS-Badge]: https://img.shields.io/badge/macOS-13.0%2B-blue?labelColor=00367A&color=3081D0
[iOS-Badge]: https://img.shields.io/badge/iOS-15.5%2B-blue?labelColor=00367A&color=3081D0
[watchOS-Badge]: https://img.shields.io/badge/watchOS-6.0%2B-blue?labelColor=00367A&color=3081D0

[SPM-Badge]: https://img.shields.io/github/v/tag/Kjuly/KYLogger?label=SPM&labelColor=2F4858&color=A8DF8E
[SPM-Link]: https://swiftpackageindex.com/Kjuly/KYLogger
[CocoaPods-Badge]: https://img.shields.io/cocoapods/v/KYLogger?label=CocoaPods&labelColor=2F4858&color=A8DF8E
[CocoaPods-Link]: https://cocoapods.org/pods/KYLogger
[Carthage-Badge]: https://img.shields.io/github/v/tag/Kjuly/KYLogger?label=Carthage&labelColor=2F4858&color=A8DF8E
[Carthage-Link]: https://swiftpackageindex.com/Kjuly/KYLogger

## Installation

See the following subsections for details on the different installation methods.

- [Swift Package Manager](INSTALLATION.md#swift-package-manager)
- [CocoaPods](INSTALLATION.md#cocoaPods)
- [Carthage](INSTALLATION.md#carthage)
- [Submodule](INSTALLATION.md#submodule)

## KYLog Usage

```swift
KYLog(.debug, "A debug message")
KYLog(.notice, "A notice message")
KYLog(.success, "A success message")
KYLog(.warn, "A warn message")
KYLog(.error, "A error message")
KYLog(.critical, "A critical message")
```
Outputs:
```
🟣 DEBUG -[KYLoggerDemoApp.swift init()] L18: A debug message
🔵 NOTICE -[KYLoggerDemoApp.swift init()] L19: A notice message
🟢 SUCCESS -[KYLoggerDemoApp.swift init()] L20: A success message
🟡 WARN -[KYLoggerDemoApp.swift init()] L21: A warn message
🔴 ERROR -[KYLoggerDemoApp.swift init()] L22: A error message
❌ CRITICAL -[KYLoggerDemoApp.swift init()] L23: A critical message
```

## KYFileLogger Usage

You can define a global variable to toggle file logging and wrap the logger with a convenience function. Just like the demo project:
```swift
class DemoAppFileLogger {
  public static var isDataSyncLoggingEnabled: Bool = false
}

public func DemoAppSyncFileLog(
  _ type: KYLogType,
  _ message: String,
  function: String = #function,
  file: String = #file,
  line: Int = #line
) {
#if DEBUG
  KYFileLogger.log(type, message, DemoAppFileLogger.isDataSyncLoggingEnabled, function: function, file: file, line: line)
#else
  if DemoAppFileLogger.isDataSyncLoggingEnabled {
    KYFileLogger.log(type, message, function: function, file: file, line: line)
  }
#endif
}

// This message will be saved to disk only if `DemoAppFileLogger.isDataSyncLoggingEnabled = true`.
DemoAppSyncFileLog(.notice, "Some sync messages.")
```
> [!NOTE]
> You can check out the demo project [KYLoggerDemo](KYLoggerDemo) for more details.
