//
//  KYFileLoggerErrorTests.swift
//  KYLoggerTests
//
//  Created by Kjuly on 21/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import XCTest
@testable import KYLogger

final class KYFileLoggerErrorTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  //
  // KYFileLoggerError.getter:errorDescription
  //
  func testExample() throws {
    XCTAssertEqual(KYFileLoggerError.failedToCreateFolder("AAA").localizedDescription, "AAA")
    XCTAssertEqual(KYFileLoggerError.failedToCreateLogFile("BBB").localizedDescription, "BBB")
    XCTAssertEqual(KYFileLoggerError.others("CCC").localizedDescription, "CCC")
  }
}
