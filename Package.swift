// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Sibala",
    products: [
        .library(
            name: "Sibala",
            targets: ["Sibala"]),
    ],
    targets: [
        .target(
            name: "Sibala",
            dependencies: []),
        .testTarget(
            name: "SibalaTests",
            dependencies: ["Sibala"]),
    ]
)
