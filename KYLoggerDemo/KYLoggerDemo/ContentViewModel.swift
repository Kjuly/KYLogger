//
//  ContentViewModel.swift
//  KYLoggerDemo
//
//  Created by Kjuly on 11/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation
import SwiftUI
import KYLogger

class ContentViewModel: ObservableObject {

  @Published var isGenericLoggingEnabled: Bool = false
  @Published var isDataSyncLoggingEnabled: Bool = false

  @Published var logFileItems: [KYLoggerDemoLogFileModel] = []

  init() {
    isGenericLoggingEnabled = DemoAppFileLogger.isGenericLoggingEnabled
    isDataSyncLoggingEnabled = DemoAppFileLogger.isDataSyncLoggingEnabled

    refreshLogFiles()
  }

  func refreshLogFiles() {
    guard
      let rootURL: URL = try? KYFileLogger.rootFolderURL(name: DemoAppFileLogger.folderName, createIfNonexistent: true),
      let documentContents: [URL] = try? FileManager.default.contentsOfDirectory(
        at: rootURL,
        includingPropertiesForKeys: [.nameKey],
        options: .skipsHiddenFiles)
    else {
      self.logFileItems = []
      return
    }

    if documentContents.isEmpty {
      self.logFileItems = []
    } else {
      self.logFileItems = documentContents.map {
        KYLoggerDemoLogFileModel(filename: $0.lastPathComponent, fileURL: $0)
      }.sorted(by: >)
    }
  }
}

struct KYLoggerDemoLogFileModel: Comparable {

  let filename: String
  let fileURL: URL

  static func < (lhs: KYLoggerDemoLogFileModel, rhs: KYLoggerDemoLogFileModel) -> Bool {
    return lhs.filename < rhs.filename
  }
}
