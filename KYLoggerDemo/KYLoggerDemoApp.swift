//
//  KYLoggerDemoApp.swift
//  KYLoggerDemo
//
//  Created by Kjuly on 11/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI
import KYLogger

@main
struct KYLoggerDemoApp: App {

  init() {
    DemoAppFileLogger.restoreState()

    if DemoAppFileLogger.hasOptionEnabled() {
      try? DemoAppFileLogger.startSessionIfNeeded()
    } else {
      DemoAppFileLogger.endSessionIfNeeded()
    }
  }

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView(viewModel: .init())
          .navigationTitle("KYLogger Demo")
#if os(iOS)
          .navigationBarTitleDisplayMode(.inline)
#endif
      }
    }
  }
}
