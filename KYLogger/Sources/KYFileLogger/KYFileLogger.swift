//
//  KYFileLogger.swift
//  KYLogger
//
//  Created by Kjuly on 8/2/2017.
//  Copyright © 2017 Kjuly. All rights reserved.
//

import Foundation

@objc
public class KYFileLogger: NSObject {

  static var _currentSessionIdentifier: String?
  static var _logFileURL: URL?

  // MARK: - Public (Log)

  public static func currentLogFileURL() -> URL? {
    return _logFileURL
  }

  public static func log(
    _ type: KYLogType,
    _ message: String,
    _ isFileLoggingEnabled: Bool = true,
    function: String = #function,
    file: String = #file,
    line: Int = #line
  ) {
#if DEBUG
    let fileString: NSString = NSString(string: file)
    let text = "\(type.text) -[\(fileString.lastPathComponent) \(function)] L\(line): \(message)"
    print(text)
    if isFileLoggingEnabled {
      p_appendLogText(text + "\n")
    }
#else
    if isFileLoggingEnabled {
      let fileString: NSString = NSString(string: file)
      let text = "\(type.text) -[\(fileString.lastPathComponent) \(function)] L\(line): \(message)\n"
      p_appendLogText(text)
    }
#endif
  }

  @objc
  public static func logWithText(_ text: String, isFileLoggingEnabled: Bool = true) {
#if DEBUG
    print(text)
#endif
    if isFileLoggingEnabled {
      p_appendLogText(text + "\n")
    }
  }

  // MARK: - Internal (Log Text)

  static func p_appendLogText(_ text: String, logFileURL: URL? = _logFileURL) {
    if _currentSessionIdentifier == nil {
      return
    }

    guard
      let logFileURL,
      let data = text.data(using: .utf8),
      let fileHandler = try? FileHandle(forWritingTo: logFileURL)
    else {
      return
    }

    defer {
      do {
        try fileHandler.close()
      } catch {
        KYLog(.error, "Failed to close the file \(logFileURL)")
      }
    }

    do {
      try fileHandler.truncate(atOffset: fileHandler.seekToEndOfFile())
    } catch {
      KYLog(.error, "Failed to seek to the end of the file \(logFileURL)")
      return
    }

    fileHandler.write(data)

    /*
    do {
      try
      try fileHandler.write(contentsOf: data)
    } catch {
      KYLog(.error, "Failed to write text to file \(logFileURL)")
    }*/
  }
}
