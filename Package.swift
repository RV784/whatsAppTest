// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "whatsapp-with-vonage",
    platforms: [.iOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/appwrite/sdk-for-swift", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "whatsapp-with-vonage",
            dependencies: [
                .product(name: "Appwrite", package: "sdk-for-swift"),
                .product(name: "JWTKit", package: "jwt-kit")
            ],
            resources: [
                .copy("Resources")
            ]
        )
    ]
)
