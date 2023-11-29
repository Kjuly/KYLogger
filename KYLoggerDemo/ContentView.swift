//
//  ContentView.swift
//  KYLoggerDemo
//
//  Created by Kjuly on 11/10/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import SwiftUI
import KYLogger

struct ContentView: View {

  @ObservedObject var viewModel: ContentViewModel

  @State var shouldAppendLogForDataSync: Bool = false
  @State var isConfirmingToCleanAllLogs = false

  init(viewModel: ContentViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    Form {
      Section("Settings") {
        Toggle("Generic File Logging", isOn: $viewModel.isGenericLoggingEnabled)
          .onChange(of: self.viewModel.isGenericLoggingEnabled) { newValue in
            try? DemoAppFileLogger.switchGenericFileLogging(enabled: newValue)
            if newValue {
              self.viewModel.refreshLogFiles()
            }
          }
        Toggle("Data Sync File Logging", isOn: $viewModel.isDataSyncLoggingEnabled)
          .onChange(of: self.viewModel.isDataSyncLoggingEnabled) { newValue in
            try? DemoAppFileLogger.switchDataSyncFileLogging(enabled: newValue)
            if newValue {
              self.viewModel.refreshLogFiles()
            }
          }
      }

      if self.viewModel.isGenericLoggingEnabled || self.viewModel.isDataSyncLoggingEnabled {
        Section("Append Log") {
          Toggle("For Data Sync", isOn: $shouldAppendLogForDataSync)

          _appendLogButton(for: .debug, "A debug line")
          _appendLogButton(for: .notice, "A notice line")
          _appendLogButton(for: .success, "A success line")
          _appendLogButton(for: .warn, "A warning line")
          _appendLogButton(for: .error, "An error line")
          _appendLogButton(for: .critical, "A critical line")
        }
      }

      if !self.viewModel.logFileItems.isEmpty {
        Section("Logs") {
          ForEach(self.viewModel.logFileItems, id: \.filename) { item in
            NavigationLink(item.filename) {
              _detailsViewForLog(item.fileURL)
            }
            .monospacedDigit()
          }
        }

        Section {
          Button("Clean All Logs", role: .destructive) {
            self.isConfirmingToCleanAllLogs = true
          }
          .confirmationDialog("Clean All Logs", isPresented: $isConfirmingToCleanAllLogs) {
            Button("Clean All", role: .destructive) {
              try? DemoAppFileLogger.cleanAllLogs()
              self.viewModel.refreshLogFiles()
            }
            Button("Cancel", role: .cancel) {}
          } message: {
            Text("Are you sure to clean all logs?")
          }
        }
      }
    }
    .listStyle(.insetGrouped)
  }

  // MARK: - Private

  @ViewBuilder
  private func _appendLogButton(for type: KYLogType, _ text: String) -> some View {
    Button(type.text) {
      if self.shouldAppendLogForDataSync {
        DemoAppSyncFileLog(type, text + " (sync)")
      } else {
        DemoAppFileLog(type, text)
      }
    }
  }

  @ViewBuilder
  private func _detailsViewForLog(_ fileURL: URL) -> some View {
    switch KYFileLogger.loadLogDetails(url: fileURL) {
    case .success(let details):
      ScrollView {
        Text(details)
      }

    case .failure(let error):
      Text("Failed to load log details.\n\(error.localizedDescription)")
        .multilineTextAlignment(.center)
    }
  }
}

// MARK: - ContentView Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewModel: .init())
  }
}
