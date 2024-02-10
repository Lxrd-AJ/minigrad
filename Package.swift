// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MiniGrad",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MiniGrad",
            targets: ["MiniGrad"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MiniGrad", 
            swiftSettings: [
                .define("ACCELERATE_NEW_LAPACK"),
                .define("ACCELERATE_LAPACK_ILP64"),
                .unsafeFlags([
                    "-DACCELERATE_NEW_LAPACK",
                    "-DACCELERATE_LAPACK_ILP64"
                ])
            ]
        ),
        .testTarget(
            name: "MiniGradTests",
            dependencies: ["MiniGrad"],
            resources: [
                .copy("Resources/veles.jpeg")
            ]
        ),
    ]
)
