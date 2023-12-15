// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "KYLogger",
  platforms: [
    .iOS("15.5"),
    .watchOS(.v6),
    .macOS(.v12),
  ],
  products: [
    .library(
      name: "KYLogger",
      targets: [
        "KYLogger",
        "KYLoggerObjC",
      ]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "KYLogger",
      dependencies: [
      ],
      path: "KYLogger/Sources"),
    .target(
      name: "KYLoggerObjC",
      dependencies: [
      ],
      path: "KYLogger/SourcesObjC"),
    .testTarget(
      name: "KYLoggerTests",
      dependencies: [
        "KYLogger",
      ],
      path: "KYLoggerTests"),
  ]
)
