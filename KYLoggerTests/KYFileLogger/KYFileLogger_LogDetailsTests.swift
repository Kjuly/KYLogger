//
//  KYFileLogger_LogDetailsTests.swift
//  KYLoggerTests
//
//  Created by Kjuly on 21/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYLogger

final class KYFileLogger_LogDetailsTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    try? KYFileLogger.cleanAllLogs(atFolder: nil)
  }

  //
  // static KYFileLogger.loadLogDetails(url:)
  //
  func testLoadLogDetails() throws {
    let originalCurrentSessionIdentifier: String? = KYFileLogger._currentSessionIdentifier
    let originalLogFileURL: URL? = KYFileLogger._logFileURL
    defer {
      KYFileLogger._currentSessionIdentifier = originalCurrentSessionIdentifier
      KYFileLogger._logFileURL = originalLogFileURL
    }

    KYFileLogger._currentSessionIdentifier = "TestSessionIdentifier"

    let rootURL: URL = try KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: true)
    let logFileURL = rootURL.appendingPathComponent("test.log")

    //
    // The log file doesn't exist
    XCTAssertEqual(KYFileLogger.loadLogDetails(url: logFileURL), .failure(.fileNotFound))

    //
    // Create log file, and then load
    try? Data().write(to: logFileURL, options: .atomic)
    XCTAssertEqual(KYFileLogger.loadLogDetails(url: logFileURL), .success(""))

    //
    // Append contents, and then load
    KYFileLogger.p_appendLogText("Test log contents.", logFileURL: logFileURL)
    XCTAssertEqual(KYFileLogger.loadLogDetails(url: logFileURL), .success("Test log contents."))
  }
}
