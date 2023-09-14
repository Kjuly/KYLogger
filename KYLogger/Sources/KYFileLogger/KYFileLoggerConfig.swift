//
//  KYFileLoggerConfig.swift
//  KYLogger
//
//  Created by Kjuly on 20/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

public struct KYFileLoggerConfig {

  public var preferredFolderName: String?

  public var filenamePrefix: String?
  public var filenameDateFormat: String?

  public init(preferredFolderName: String?, filenamePrefix: String?, filenameDateFormat: String?) {
    self.preferredFolderName = preferredFolderName
    self.filenamePrefix = filenamePrefix
    self.filenameDateFormat = filenameDateFormat
  }
}
