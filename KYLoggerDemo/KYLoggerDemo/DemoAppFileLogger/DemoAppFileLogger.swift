//
//  DemoAppFileLogger.swift
//  KYLoggerDemo
//
//  Created by Kjuly on 9/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import KYLogger

// MARK: - DemoAppFileLogger (Convenient)

public func DemoAppFileLog( // swiftlint:disable:this identifier_name
  _ type: KYLogType,
  _ message: String,
  function: String = #function,
  file: String = #file,
  line: Int = #line
) {
#if DEBUG
  KYFileLogger.log(type, message, DemoAppFileLogger.isGenericLoggingEnabled, function: function, file: file, line: line)
#else
  if DemoAppFileLogger.isGenericLoggingEnabled {
    KYFileLogger.log(type, message, function: function, file: file, line: line)
  }
#endif
}

public func DemoAppSyncFileLog( // swiftlint:disable:this identifier_name
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

// MARK: - DemoAppFileLogger

public class DemoAppFileLogger {

  static var folderName: String = "debug_logs"

  public private(set) static var isGenericLoggingEnabled: Bool = false
  public private(set) static var isDataSyncLoggingEnabled: Bool = false

  // MARK: - Public (Logging State)

  public static func restoreState() {
    isGenericLoggingEnabled = UserDefaults.demo_isGenericFileLoggingEnabled()
    isDataSyncLoggingEnabled = UserDefaults.demo_isDataSyncFileLoggingEnabled()
  }

  public static func hasOptionEnabled() -> Bool {
    return (isGenericLoggingEnabled || isDataSyncLoggingEnabled)
  }

  // MARK: - Public (Logging Switch)

  public static func switchGenericFileLogging(enabled: Bool) throws {
    if isGenericLoggingEnabled == enabled {
      return
    }
    isGenericLoggingEnabled = enabled
    UserDefaults.demo_setGenericFileLoggingEnabled(enabled)

    if enabled {
      try startSessionIfNeeded()
      KYFileLogger.log(.notice, "# Turned ON Generic Logging.\n\n")

    } else {
      KYFileLogger.log(.notice, "# Turned OFF Generic Logging.\n\n")

      // End session only if all logging options are OFF.
      if !hasOptionEnabled() {
        endSessionIfNeeded()
      }
    }
  }

  public static func switchDataSyncFileLogging(enabled: Bool) throws {
    if isDataSyncLoggingEnabled == enabled {
      return
    }
    isDataSyncLoggingEnabled = enabled
    UserDefaults.demo_setDataSyncFileLoggingEnabled(enabled)

    if enabled {
      try startSessionIfNeeded()
      KYFileLogger.log(.notice, "# Turned ON Data Sync Logging.\n\n")

    } else {
      KYFileLogger.log(.notice, "# Turned OFF Data Sync Logging.\n\n")

      // End session only if all logging options are OFF.
      if !hasOptionEnabled() {
        endSessionIfNeeded()
      }
    }
  }

  public static func disableFileLoggingForAllOptions() {
    if isGenericLoggingEnabled {
      isGenericLoggingEnabled = false
      UserDefaults.demo_setGenericFileLoggingEnabled(false)
    }

    if isDataSyncLoggingEnabled {
      isDataSyncLoggingEnabled = false
      UserDefaults.demo_setDataSyncFileLoggingEnabled(false)
    }

    endSessionIfNeeded()
  }

  // MARK: - Public (Session)

  public static func startSessionIfNeeded() throws {
    if KYFileLogger.isSessionAlive() {
      return
    }

    let config = KYFileLoggerConfig(preferredFolderName: folderName, filenamePrefix: nil, filenameDateFormat: nil)
    try KYFileLogger.startSessionIfNeeded(config: config)

    KYFileLogger.logWithText("""
      - Generic File Logging: \(isGenericLoggingEnabled)
      - Data Sync File Logging: \(isDataSyncLoggingEnabled)\n
      """)
  }

  public static func endSessionIfNeeded() {
    KYFileLogger.endSessionIfNeeded()
  }

  // MARK: - Public (Folder & File)

  public static func currentLogFileURL() -> URL? {
    return KYFileLogger.currentLogFileURL()
  }

  public static func countOfLogFiles() -> Int {
    return KYFileLogger.countOfLogFiles(atFolder: folderName)
  }

  public static func cleanAllLogs() throws {
    try KYFileLogger.cleanAllLogs(atFolder: folderName)
  }
}
