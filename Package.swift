// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BridgeeIOSExample",
    platforms: [
        .iOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.18.0")
    ],
    targets: [
        .target(
            name: "BridgeeIOSExample",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk")
            ]
        )
    ]
)
