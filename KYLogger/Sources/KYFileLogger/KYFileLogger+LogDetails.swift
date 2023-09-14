//
//  KYFileLogger+LogDetails.swift
//  KYLogger
//
//  Created by Kjuly on 21/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

public enum KYFileLoggerLogDetailsError: Error {
  case fileNotFound
  case failedToRead
}

extension KYFileLogger {

  public static func loadLogDetails(url: URL) -> Result<String, KYFileLoggerLogDetailsError> {
    guard FileManager.default.fileExists(atPath: url.path) else {
      return .failure(.fileNotFound)
    }

    do {
      let contents = try String(contentsOf: url, encoding: .utf8)
      return .success(contents)
    } catch {
      return .failure(.failedToRead)
    }
  }
}
