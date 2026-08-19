// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "TrueFaceIOSSample",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(
            name: "TrueFaceIOSSample",
            targets: ["TrueFaceIOSSample"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/trueface-dev/ios-artifact.git",
            from: "0.2.6"
        )
    ],
    targets: [
        .executableTarget(
            name: "TrueFaceIOSSample",
            dependencies: [
                .product(name: "TrueFaceLiveness", package: "ios-artifact")
            ],
            path: "Sources",
            exclude: ["Info.plist"]
        )
    ]
)
