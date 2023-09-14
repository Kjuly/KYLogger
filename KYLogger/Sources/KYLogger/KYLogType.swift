//
//  KYLogger.swift
//  KYLogger
//
//  Created by Kjuly on 30/8/2022.
//  Copyright © 2022 Kjuly. All rights reserved.
//

import Foundation

@objc public enum KYLogType: Int {
  case debug = 1
  case notice
  case success
  case warn
  case error
  case critical
  // Module Specific
  case moduleCycle
  case arc

  public var text: String {
    switch self {
    case .debug: return "🟣 DEBUG"
    case .notice: return "🔵 NOTICE"
    case .success: return "🟢 SUCCESS"
    case .warn: return "🟡 WARN"
    case .error: return "🔴 ERROR"
    case .critical: return "❌ CRITICAL"
    // Module Specific
    case .moduleCycle: return "🧩 MODULE CYCLE"
    case .arc: return "♻️ ARC" // Automatic Reference Counting (ARC)
    }
  }
}
