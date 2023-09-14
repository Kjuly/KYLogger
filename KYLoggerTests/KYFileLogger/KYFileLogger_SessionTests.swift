//
//  KYFileLogger_SessionTests.swift
//  KYLoggerTests
//
//  Created by Kjuly on 20/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYLogger

final class KYFileLogger_SessionTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    try? KYFileLogger.cleanAllLogs(atFolder: nil)
  }

  // MARK: - Tests for Session

  //
  // static KYFileLogger.startSessionIfNeeded(config:)
  // static KYFileLogger.endSessionIfNeeded()
  //
  func testSessionLifeCycle() throws { // swiftlint:disable:this function_body_length
    // Cache & restore original values
    let originalCurrentSessionIdentifier: String? = KYFileLogger._currentSessionIdentifier
    let originalLogFileURL: URL? = KYFileLogger._logFileURL
    defer {
      KYFileLogger._currentSessionIdentifier = originalCurrentSessionIdentifier
      KYFileLogger._logFileURL = originalLogFileURL
    }

    KYFileLogger._currentSessionIdentifier = nil
    KYFileLogger._logFileURL = nil

    var currentSessionIdentifier: String
    var currentLogFileURL: URL

    var logDetails: String
    var expectedLogDetails: String

    //
    // Session w/o custom config.
    //
    // Start a pure new session
    try? KYFileLogger.startSessionIfNeeded(config: nil)
    currentSessionIdentifier = KYFileLogger._currentSessionIdentifier!
    currentLogFileURL = KYFileLogger._logFileURL!
    XCTAssertNotNil(currentSessionIdentifier)
    XCTAssertNotNil(currentLogFileURL)

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    XCTAssertEqual(logDetails, "\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n")

    // The same session, do nothing
    try? KYFileLogger.startSessionIfNeeded(config: nil)
    XCTAssertEqual(KYFileLogger._currentSessionIdentifier, currentSessionIdentifier)
    XCTAssertEqual(KYFileLogger._logFileURL, currentLogFileURL)

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    XCTAssertEqual(logDetails, "\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n")

    // End session, and continue after a tiny delay (different session identifier & log file).
    KYFileLogger.endSessionIfNeeded()
    sleep(1)

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    expectedLogDetails = """
\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n
\n\n# END File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n
"""
    XCTAssertEqual(logDetails, expectedLogDetails)

    try? KYFileLogger.startSessionIfNeeded(config: nil)
    XCTAssertNotNil(KYFileLogger._currentSessionIdentifier)
    XCTAssertNotNil(KYFileLogger._logFileURL)
    XCTAssertNotEqual(KYFileLogger._currentSessionIdentifier, currentSessionIdentifier)
    XCTAssertNotEqual(KYFileLogger._logFileURL, currentLogFileURL)

    currentSessionIdentifier = KYFileLogger._currentSessionIdentifier!
    currentLogFileURL = KYFileLogger._logFileURL!

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    XCTAssertEqual(logDetails, "\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n")

    // End session
    KYFileLogger.endSessionIfNeeded()
    XCTAssertNil(KYFileLogger._currentSessionIdentifier)

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    expectedLogDetails = """
\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n
\n\n# END File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n
"""
    XCTAssertEqual(logDetails, expectedLogDetails)

    // End session 2nd time will do nothing.
    KYFileLogger.endSessionIfNeeded()
    XCTAssertNil(KYFileLogger._currentSessionIdentifier)

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    expectedLogDetails = """
\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n
\n\n# END File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n
"""
    XCTAssertEqual(logDetails, expectedLogDetails)

    //
    // Session w/ custom config
    //
    let dateFormat = "yyyyMMdd"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let expectedSessionIdentifier = dateFormatter.string(from: KYFileLogger.p_dateNow())

    let config = KYFileLoggerConfig(preferredFolderName: nil, filenamePrefix: nil, filenameDateFormat: dateFormat)
    try? KYFileLogger.startSessionIfNeeded(config: config)
    currentSessionIdentifier = KYFileLogger._currentSessionIdentifier!
    currentLogFileURL = KYFileLogger._logFileURL!
    XCTAssertEqual(currentSessionIdentifier, expectedSessionIdentifier)
    XCTAssertEqual(currentLogFileURL.lastPathComponent, "\(expectedSessionIdentifier).log")

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    XCTAssertEqual(logDetails, "\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n")

    // The same session, do nothing
    try? KYFileLogger.startSessionIfNeeded(config: config)
    XCTAssertEqual(KYFileLogger._currentSessionIdentifier, currentSessionIdentifier)
    XCTAssertEqual(KYFileLogger._logFileURL, currentLogFileURL)

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    XCTAssertEqual(logDetails, "\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n")

    // End session, and continue instantly (same session identifier & log file).
    KYFileLogger.endSessionIfNeeded()
    try? KYFileLogger.startSessionIfNeeded(config: config)
    XCTAssertNotNil(KYFileLogger._currentSessionIdentifier)
    XCTAssertNotNil(KYFileLogger._logFileURL)
    XCTAssertEqual(KYFileLogger._currentSessionIdentifier, currentSessionIdentifier)
    XCTAssertEqual(KYFileLogger._logFileURL, currentLogFileURL)

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    expectedLogDetails = """
\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n
\n\n# END File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n
\n\n# CONTINUE File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n
"""
    XCTAssertEqual(logDetails, expectedLogDetails)

    // End session
    KYFileLogger.endSessionIfNeeded()
    XCTAssertNil(KYFileLogger._currentSessionIdentifier)

    logDetails = try KYFileLogger.loadLogDetails(url: currentLogFileURL).get()
    expectedLogDetails = """
\n\n# START File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n
\n\n# END File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n
\n\n# CONTINUE File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n
\n\n# END File Logging Session w/ Identifier: \(currentSessionIdentifier)\n\n\n
"""
    XCTAssertEqual(logDetails, expectedLogDetails)
  }

  // MARK: - Tests for Session Identifier

  //
  // static KYFileLogger.p_sessionIdentifier(prefix:dateFormat:)
  // static KYFileLogger.p_setSessionIdentifier(_:)
  //
  func testSessionIdentifier() throws {
    // Cache & restore original session identifier
    let originalSessionIdentifier = UserDefaults.standard.string(forKey: KYFileLogger.kKYLoggerKeyOfFileLogSessionIdentifier_)
    UserDefaults.standard.set(nil, forKey: KYFileLogger.kKYLoggerKeyOfFileLogSessionIdentifier_)
    defer {
      UserDefaults.standard.set(originalSessionIdentifier, forKey: KYFileLogger.kKYLoggerKeyOfFileLogSessionIdentifier_)
      XCTAssertEqual(UserDefaults.standard.string(forKey: KYFileLogger.kKYLoggerKeyOfFileLogSessionIdentifier_), originalSessionIdentifier)
    }

    let dateFormat = "yyyyMMddHHmm" // removed seconds part
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let expectedSessionIdentifierTimestampPart = dateFormatter.string(from: KYFileLogger.p_dateNow())

    XCTAssertNil(UserDefaults.standard.value(forKey: KYFileLogger.kKYLoggerKeyOfFileLogSessionIdentifier_))
    var sessionIdentifier = KYFileLogger.p_sessionIdentifier(prefix: nil, dateFormat: nil)
    XCTAssertTrue(sessionIdentifier.hasPrefix(expectedSessionIdentifierTimestampPart))
    XCTAssertNotNil(UserDefaults.standard.value(forKey: KYFileLogger.kKYLoggerKeyOfFileLogSessionIdentifier_))
    // Return the same one
    XCTAssertEqual(KYFileLogger.p_sessionIdentifier(prefix: nil, dateFormat: nil), sessionIdentifier)

    //
    // Clean & reset w/ prefix & date format
    KYFileLogger.p_setSessionIdentifier(nil)
    XCTAssertNil(UserDefaults.standard.value(forKey: KYFileLogger.kKYLoggerKeyOfFileLogSessionIdentifier_))

    sessionIdentifier = KYFileLogger.p_sessionIdentifier(prefix: "TestPrefix_", dateFormat: dateFormat)
    XCTAssertEqual(sessionIdentifier, "TestPrefix_\(expectedSessionIdentifierTimestampPart)")
    XCTAssertEqual(sessionIdentifier, UserDefaults.standard.string(forKey: KYFileLogger.kKYLoggerKeyOfFileLogSessionIdentifier_))
    // Return the same one
    XCTAssertEqual(KYFileLogger.p_sessionIdentifier(prefix: nil, dateFormat: nil), sessionIdentifier)
  }
}
