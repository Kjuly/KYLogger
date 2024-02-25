//
//  KYLog.swift
//  KYLogger
//
//  Created by Kjuly on 25/9/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if DEBUG
public func KYLog(
  _ type: KYLogType,
  _ message: String,
  function: String = #function,
  file: String = #file,
  line: Int = #line
) {
  let fileString: NSString = NSString(string: file)
  print("\(type.text) -[\(fileString.lastPathComponent) \(function)] L\(line): \(message)")
}

public func KYPrint(_ type: KYLogType, _ message: String) {
  print("\(type.text): \(message)")
}
#else
public func KYLog(_ type: KYLogType, _ message: String) {}
public func KYPrint(_ type: KYLogType, _ message: String) {}
#endif // END #if DEBUG
