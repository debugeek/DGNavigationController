// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "DGNavigationController",
    products: [
        .library(name: "DGNavigationController", targets: ["DGNavigationController"])
    ],
    dependencies: [
        .package(url: "https://github.com/debugeek/DGExtension.git", .branch("main")),
        .package(url: "https://github.com/debugeek/DGFoundation.git", .branch("main"))
    ],
    targets: [
        .target(name: "DGNavigationController", dependencies: ["DGExtension", "DGFoundation"])
    ]
)
