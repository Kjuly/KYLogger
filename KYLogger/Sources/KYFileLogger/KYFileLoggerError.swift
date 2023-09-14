//
//  KYFileLoggerError.swift
//  KYLogger
//
//  Created by Kjuly on 20/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

public enum KYFileLoggerError: Error {
  case failedToCreateFolder(String)
  case failedToCreateLogFile(String)
  case others(String)
}

extension KYFileLoggerError: Equatable {}

extension KYFileLoggerError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .failedToCreateFolder(let errorMessage):
      return errorMessage
    case .failedToCreateLogFile(let errorMessage):
      return errorMessage
    case .others(let errorMessage):
      return errorMessage
    }
  }
}
