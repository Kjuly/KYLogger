//
//  KYFileLogger+Session.swift
//  KYLogger
//
//  Created by Kjuly on 20/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

extension KYFileLogger {

  // MARK: - Public

  public static func isSessionAlive() -> Bool {
    return _currentSessionIdentifier != nil
  }

  public static func startSessionIfNeeded(config: KYFileLoggerConfig?) throws {
    if _currentSessionIdentifier != nil {
      return
    }

    // Start a pure new session w/ an identifier.
    let currentSessionIdentifier = p_sessionIdentifier(prefix: config?.filenamePrefix, dateFormat: config?.filenameDateFormat)
    _currentSessionIdentifier = currentSessionIdentifier

    // Create a log file.
    let logFileFolderURL: URL = try rootFolderURL(name: config?.preferredFolderName, createIfNonexistent: true)
    let logFileURL = logFileFolderURL.appendingPathComponent("\(currentSessionIdentifier).log")
    _logFileURL = logFileURL

    KYLog(.notice, "Start File Logging Session w/ Identifier \"\(currentSessionIdentifier)\" at path: \(logFileURL)")

    if FileManager.default.fileExists(atPath: logFileURL.path) {
      // Append a log of "Session Continue".
      let log = "\n\n# CONTINUE File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n"
      p_appendLogText(log)

    } else {
      do {
        try Data().write(to: logFileURL, options: .atomic)
      } catch {
        KYLog(.error, "The log file creation was failed.")
        throw KYFileLoggerError.failedToCreateLogFile(error.localizedDescription)
      }
      // Append a log of "Session Start".
      let log = "\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n"
      p_appendLogText(log)
    }
  }

  public static func endSessionIfNeeded() {
    guard let currentSessionIdentifier = _currentSessionIdentifier else {
      return
    }

    // Append a log of "Session End".
    let log = "\n\n# END File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n"
    p_appendLogText(log)

    _currentSessionIdentifier = nil
    p_setSessionIdentifier(nil)

    KYLog(.notice, "End File Logging Session")
  }

  // MARK: - Internal (Session Identifier)

  static let kKYLoggerKeyOfFileLogSessionIdentifier_ = "com.kjuly.KYLogger.FileLogSessionIdentifier"

  /// Get the session identifier.
  ///
  /// It will also be used as the log filename, e.g. "\<session-identifier\>.log".
  ///
  /// If you want to use the same log file during multiple sessions, you can use a shorter date format
  /// (e.g. "yyyyMMdd" will keep using one log file during a day, no matter how many sessions there are).
  ///
  /// - Parameters:
  ///   - prefix: Any prefix for the identifier, default: "" (empty)
  ///   - dateFormat: The date format that used to generate an identifier, default: "yyyyMMddHHmmss"
  ///
  /// - Returns: A session identifier in string.
  ///
  static func p_sessionIdentifier(prefix: String?, dateFormat: String?) -> String {
    if let identifier = UserDefaults.standard.string(forKey: kKYLoggerKeyOfFileLogSessionIdentifier_) {
      return identifier
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat ?? "yyyyMMddHHmmss"

    let identifier: String = (prefix ?? "") + dateFormatter.string(from: p_dateNow())
    p_setSessionIdentifier(identifier)

    return identifier
  }

  static func p_setSessionIdentifier(_ sessionIdentifier: String?) {
    UserDefaults.standard.setValue(sessionIdentifier, forKey: kKYLoggerKeyOfFileLogSessionIdentifier_)
  }

  static func p_dateNow() -> Date {
    if #available(iOS 15, watchOS 8, *) {
      return .now
    } else {
      return .init(timeIntervalSinceNow: 0)
    }
  }
}
