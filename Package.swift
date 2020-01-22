// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "hex-grid",
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
