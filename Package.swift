// swift-tools-version:5.3
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
            dependencies: [
            .target(name: "HexGrid")
        ]),
    ]
)
