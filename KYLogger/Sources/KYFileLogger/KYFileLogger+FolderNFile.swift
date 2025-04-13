//
//  KYFileLogger+FolderNFile.swift
//  KYLogger
//
//  Created by Kjuly on 20/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

extension KYFileLogger {

  public static func defaultRootFolerName() -> String {
#if DEBUG
    if NSClassFromString("XCTest") != nil {
      return "file_logs_tests"
    }
#endif
    return "file_logs"
  }

  public static func rootFolderURL(name: String?, createIfNonexistent: Bool) throws -> URL {
    let documentFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let folderName = name ?? defaultRootFolerName()
    let rootURL = documentFolderURL.appendingPathComponent(folderName, isDirectory: true)

    if !createIfNonexistent {
      return rootURL
    }

    if let isReachable = try? rootURL.checkResourceIsReachable(), isReachable {
      return rootURL
    }

    KYLog(.notice, "Creating \"\(folderName)\" Folder ...")
    do {
      try FileManager.default.createDirectory(at: rootURL, withIntermediateDirectories: true)
    } catch {
      KYLog(.error, error.localizedDescription)
      throw KYFileLoggerError.failedToCreateFolder(error.localizedDescription)
    }
    return rootURL
  }

  public static func countOfLogFiles(atFolder name: String?) -> Int {
    let rootURL: URL? = try? rootFolderURL(name: name, createIfNonexistent: false)
    guard
      let rootURL,
      let isReachable = try? rootURL.checkResourceIsReachable(),
      isReachable
    else {
      return 0
    }

    do {
      let contents = try FileManager.default.contentsOfDirectory(atPath: rootURL.path)
      return contents.filter { $0.hasSuffix(".log") }.count
    } catch {
      return 0
    }
  }

  public static func cleanAllLogs(atFolder name: String?) throws {
    guard var rootURL: URL = try? rootFolderURL(name: name, createIfNonexistent: false) else {
      return
    }

    // Clean root folder.
    KYLog(.debug, "Cleaning all logs at \(rootURL)...")
    try? FileManager.default.removeItem(at: rootURL)

#if !os(watchOS)
    // Check and clean zip file if needed.
    rootURL.appendPathExtension("zip")
    try? FileManager.default.removeItem(at: rootURL)
#endif

    _logFileURL = nil
  }
}
