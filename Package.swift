// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "HexGrid",
    products: [
        .library(
            name: "HexGrid",
            targets: ["HexGrid"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HexGrid",
            dependencies: []),
        .testTarget(
            name: "HexGridTests",
            dependencies: ["HexGrid"])
    ]
)
