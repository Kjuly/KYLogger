//
//  KYFileLogger_FolderNFileTests.swift
//  KYLoggerTests
//
//  Created by Kjuly on 20/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYLogger

final class KYFileLogger_FolderNFileTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    try? KYFileLogger.cleanAllLogs(atFolder: nil)
  }

  // MARK: - Private

  private func _getDocumentFolderURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }

  // MARK: - Tests

  //
  // static KYFileLogger.defaultRootFolerName()
  //
  func testDefaultRootFolerName() throws {
    XCTAssertEqual(KYFileLogger.defaultRootFolerName(), "file_logs_tests")
  }

  //
  // static KYFileLogger.rootFolderURL(name:createIfNonexistent:)
  //
  func testRootFolderURL() {
    let documentFolderURL = _getDocumentFolderURL()

    //
    // Tests w/ default folder
    var folderName = KYFileLogger.defaultRootFolerName()
    var expectedRootURL: URL = documentFolderURL.appendingPathComponent(folderName, isDirectory: true)

    XCTAssertEqual(try? KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: false), expectedRootURL)
    XCTAssertFalse(FileManager.default.fileExists(atPath: expectedRootURL.path))

    XCTAssertEqual(try? KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: true), expectedRootURL)
    XCTAssertTrue(FileManager.default.fileExists(atPath: expectedRootURL.path))

    XCTAssertEqual(try? KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: true), expectedRootURL)
    XCTAssertTrue(FileManager.default.fileExists(atPath: expectedRootURL.path))

    try? KYFileLogger.cleanAllLogs(atFolder: folderName)

    //
    // Tests w/ custom folder
    folderName = "another_logs_folder_tests"
    expectedRootURL = documentFolderURL.appendingPathComponent(folderName, isDirectory: true)
    XCTAssertEqual(try KYFileLogger.rootFolderURL(name: folderName, createIfNonexistent: false), expectedRootURL)
    XCTAssertFalse(FileManager.default.fileExists(atPath: expectedRootURL.path))

    XCTAssertEqual(try KYFileLogger.rootFolderURL(name: folderName, createIfNonexistent: true), expectedRootURL)
    XCTAssertTrue(FileManager.default.fileExists(atPath: expectedRootURL.path))

    try? KYFileLogger.cleanAllLogs(atFolder: folderName)

    //
    // Tests w/ invalue folder name (will be auto-converted to "/")
    folderName = ":::"
    expectedRootURL = documentFolderURL.appendingPathComponent(folderName, isDirectory: true)
    XCTAssertEqual(try KYFileLogger.rootFolderURL(name: folderName, createIfNonexistent: false), expectedRootURL)
    XCTAssertFalse(FileManager.default.fileExists(atPath: expectedRootURL.path))

    XCTAssertEqual(try KYFileLogger.rootFolderURL(name: folderName, createIfNonexistent: true), expectedRootURL)
    XCTAssertTrue(FileManager.default.fileExists(atPath: expectedRootURL.path))

    try? KYFileLogger.cleanAllLogs(atFolder: folderName)
  }

  //
  // static KYFileLogger.countOfLogFiles(atFolder:)
  //
  func testCountOfLogFiles() throws {
    //
    // The folder doesn't exist
    XCTAssertEqual(KYFileLogger.countOfLogFiles(atFolder: nil), 0)

    //
    // Empty folder
    let rootURL: URL = try KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: true)
    XCTAssertEqual(KYFileLogger.countOfLogFiles(atFolder: nil), 0)

    //
    // Some log files exist
    let logFileURL_A = rootURL.appendingPathComponent("A.log")
    let logFileURL_B = rootURL.appendingPathComponent("B.log")
    let logFileURL_C = rootURL.appendingPathComponent("C.log")

    let emptyData = Data()
    try? emptyData.write(to: logFileURL_A, options: .atomic)
    XCTAssertEqual(KYFileLogger.countOfLogFiles(atFolder: nil), 1)

    try? emptyData.write(to: logFileURL_B, options: .atomic)
    XCTAssertEqual(KYFileLogger.countOfLogFiles(atFolder: nil), 2)

    try? emptyData.write(to: logFileURL_C, options: .atomic)
    XCTAssertEqual(KYFileLogger.countOfLogFiles(atFolder: nil), 3)
  }

  //
  // static KYFileLogger.cleanAllLogs(atFolder:)
  //
  func testCleanAllLogs() {
    let documentFolderURL = _getDocumentFolderURL()
    let folderName = KYFileLogger.defaultRootFolerName()
    let rootURL: URL = documentFolderURL.appendingPathComponent(folderName, isDirectory: true)

    //
    // Clean, but there's no folder
    try? KYFileLogger.cleanAllLogs(atFolder: nil)
    XCTAssertFalse(FileManager.default.fileExists(atPath: rootURL.path))

    //
    // Create folder, and then clean.
    _ = try? KYFileLogger.rootFolderURL(name: nil, createIfNonexistent: true)
    XCTAssertTrue(FileManager.default.fileExists(atPath: rootURL.path))

    try? KYFileLogger.cleanAllLogs(atFolder: nil)
    XCTAssertFalse(FileManager.default.fileExists(atPath: rootURL.path))
  }
}
