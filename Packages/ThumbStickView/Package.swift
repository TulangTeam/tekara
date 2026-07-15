// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The package that contains a UI for thumbstick control.
*/

import PackageDescription

let package = Package(
    name: "ThumbStickView",
    platforms: [.macOS(.v26), .visionOS(.v26), .iOS(.v26), .tvOS(.v26)],
    products: [.library(name: "ThumbStickView", targets: ["ThumbStickView"])],
    targets: [.target(
        name: "ThumbStickView",
        swiftSettings: [.enableUpcomingFeature("MemberImportVisibility")]
    )]
)
