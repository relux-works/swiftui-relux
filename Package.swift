// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swiftui-relux",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "SwiftUIRelux",
            targets: ["SwiftUIRelux"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/relux-works/swift-relux.git", .upToNextMajor(from: "9.0.0")),
        .package(url: "https://github.com/relux-works/swiftui-reluxrouter.git", .upToNextMajor(from: "11.0.0"))
    ],
    targets: [
        .target(
            name: "SwiftUIRelux",
            dependencies: [
                .product(name: "Relux", package: "swift-relux"),
                .product(name: "ReluxRouter", package: "swiftui-reluxrouter"),
            ],
            path: "Sources"
        )
    ]
)
