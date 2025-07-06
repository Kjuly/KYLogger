//
//  KYFileLoggerTests.swift
//  KYLoggerTests
//
//  Created by Kjuly on 20/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYLogger

final class KYFileLoggerTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  // MARK: - Tests for Public

  //
  // static KYFileLogger.currentLogFileURL()
  //
  func testCurrentLogFileURL() throws {
    // Cache & restore original value
    let logFileURL = KYFileLogger._logFileURL
    defer {
      KYFileLogger._logFileURL = logFileURL
    }

    KYFileLogger._logFileURL = nil
    XCTAssertNil(KYFileLogger.currentLogFileURL())

    KYFileLogger._logFileURL = URL(string: "https://example.com")
    XCTAssertEqual(KYFileLogger.currentLogFileURL(), URL(string: "https://example.com"))
  }

  //
  // static KYFileLogger.log(_:_:_:function:file:line:)
  //
  func testLog() throws {
    let originalCurrentSessionIdentifier = KYFileLogger._currentSessionIdentifier
    let originalLogFileURL = KYFileLogger._logFileURL
    defer {
      KYFileLogger._currentSessionIdentifier = originalCurrentSessionIdentifier
      KYFileLogger._logFileURL = originalLogFileURL

      try? KYFileLogger.cleanAllLogs(atFolder: nil)
    }

    // Prepare an empty log file
    let rootURL: URL = try KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: true)
    let logFileURL = rootURL.appendingPathComponent("Test.log")
    try? Data().write(to: logFileURL, options: .atomic)

    KYFileLogger._currentSessionIdentifier = "TestSession"
    KYFileLogger._logFileURL = logFileURL

    var logDetails: String
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, "")

    // Append 1st log
    KYFileLogger.log(.debug, "Test Debug Log 1")
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, "🟣 DEBUG -[KYFileLoggerTests.swift testLog()] L67: Test Debug Log 1\n")

    // Append 2nd log
    KYFileLogger.log(.error, "Test Error Log 2")
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, """
      🟣 DEBUG -[KYFileLoggerTests.swift testLog()] L67: Test Debug Log 1
      🔴 ERROR -[KYFileLoggerTests.swift testLog()] L72: Test Error Log 2\n
      """)
  }

  //
  // static KYFileLogger.logWithText(_:isFileLoggingEnabled:)
  //
  func testLogWithText() throws {
    let originalCurrentSessionIdentifier = KYFileLogger._currentSessionIdentifier
    let originalLogFileURL = KYFileLogger._logFileURL
    defer {
      KYFileLogger._currentSessionIdentifier = originalCurrentSessionIdentifier
      KYFileLogger._logFileURL = originalLogFileURL

      try? KYFileLogger.cleanAllLogs(atFolder: nil)
    }

    // Prepare an empty log file
    let rootURL: URL = try KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: true)
    let logFileURL = rootURL.appendingPathComponent("Test.log")
    try? Data().write(to: logFileURL, options: .atomic)

    KYFileLogger._currentSessionIdentifier = "TestSession"
    KYFileLogger._logFileURL = logFileURL

    var logDetails: String
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, "")

    // Append 1st log
    KYFileLogger.logWithText("Test Debug Log 1")
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, "Test Debug Log 1\n")

    // Append 2nd log
    KYFileLogger.logWithText("Test Error Log 2")
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, """
      Test Debug Log 1
      Test Error Log 2\n
      """)
  }

  // MARK: - Tests for Internal

  //
  // static KYFileLogger.p_appendLogText(_:logFileURL:)
  //
  func testP_appendLogText() throws {
    // Cache & restore original value
    let originalCurrentSessionIdentifier = KYFileLogger._currentSessionIdentifier
    defer {
      KYFileLogger._currentSessionIdentifier = originalCurrentSessionIdentifier

      try? KYFileLogger.cleanAllLogs(atFolder: nil)
    }

    KYFileLogger._currentSessionIdentifier = "TestSession"

    // Prepare an empty log file
    let rootURL: URL = try KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: true)
    let logFileURL = rootURL.appendingPathComponent("Test.log")
    try? Data().write(to: logFileURL, options: .atomic)

    var logDetails: String
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, "")

    // Append 1st log
    KYFileLogger.p_appendLogText("Test Log 1\n", logFileURL: logFileURL)
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, "Test Log 1\n")

    // Append 2nd log
    KYFileLogger.p_appendLogText("Test Log 2\n", logFileURL: logFileURL)
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, "Test Log 1\nTest Log 2\n")

    // Append 3rd log, but do nothing because of the session identifier is unavailable.
    KYFileLogger._currentSessionIdentifier = nil
    KYFileLogger.p_appendLogText("Test Log 3\n", logFileURL: logFileURL)
    logDetails = try KYFileLogger.loadLogDetails(url: logFileURL).get()
    XCTAssertEqual(logDetails, "Test Log 1\nTest Log 2\n")
  }
}
