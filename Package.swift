// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swiftui-relux",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "SwiftUIRelux",
            targets: ["SwiftUIRelux"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/relux-works/swift-relux.git", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(
            name: "SwiftUIRelux",
            dependencies: [
                .product(name: "Relux", package: "swift-relux"),
            ],
            path: "Sources"
        )
    ]
)
