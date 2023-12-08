//
//  UserDefaults+DemoAppFileLogger.swift
//  KYLoggerDemo
//
//  Created by Kjuly on 9/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

extension UserDefaults {

  // MARK: - Public (Generic Logging)

  static let kDemoAppFileLoggerKeyOfGenericFileLoggingEnabled_ = "com.kjuly.KYLoggerDemo.FileLogging.Generic"

  public static func demo_isGenericFileLoggingEnabled() -> Bool {
    return standard.bool(forKey: kDemoAppFileLoggerKeyOfGenericFileLoggingEnabled_)
  }

  public static func demo_setGenericFileLoggingEnabled(_ enabled: Bool) {
    standard.setValue(enabled, forKey: kDemoAppFileLoggerKeyOfGenericFileLoggingEnabled_)
  }

  // MARK: - Public (Data Sync Logging)

  static let kDemoAppFileLoggerKeyOfDataSyncFileLoggingEnabled_ = "com.kjuly.KYLoggerDemo.FileLogging.DataSync"

  public static func demo_isDataSyncFileLoggingEnabled() -> Bool {
    return standard.bool(forKey: kDemoAppFileLoggerKeyOfDataSyncFileLoggingEnabled_)
  }

  public static func demo_setDataSyncFileLoggingEnabled(_ enabled: Bool) {
    standard.set(enabled, forKey: kDemoAppFileLoggerKeyOfDataSyncFileLoggingEnabled_)
  }
}
