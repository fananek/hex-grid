// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "hex-grid",
    products: [
        .library(
            name: "HexGrid",
            targets: ["HexGrid"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "HexGrid",
            dependencies: []),
        .testTarget(
            name: "HexGridTests",
            dependencies: [
            .target(name: "HexGrid")
        ]),
    ]
)
