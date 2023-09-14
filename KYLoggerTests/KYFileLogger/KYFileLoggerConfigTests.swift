//
//  KYFileLoggerConfigTests.swift
//  KYLoggerTests
//
//  Created by Kjuly on 21/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYLogger

final class KYFileLoggerConfigTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  //
  // KYFileLoggerConfig.init(preferredFolderName:filenamePrefix:filenameDateFormat:)
  //
  func testInit() throws {
    let config = KYFileLoggerConfig(preferredFolderName: "A",
                                    filenamePrefix: "B",
                                    filenameDateFormat: "yyyyMMddHHmm")
    XCTAssertEqual(config.preferredFolderName, "A")
    XCTAssertEqual(config.filenamePrefix, "B")
    XCTAssertEqual(config.filenameDateFormat, "yyyyMMddHHmm")
  }
}
