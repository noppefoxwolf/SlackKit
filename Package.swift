// swift-tools-version:5.0

import PackageDescription

// MARK: Targets

let SlackKit: Target = .target(name: "SlackKit",
                               dependencies: ["SKCore", "SKClient", "SKRTMAPI", "SKServer"],
                               path: "SlackKit/Sources")

let SKClient: Target = .target(name: "SKClient",
                               dependencies: ["SKCore"],
                               path: "SKClient/Sources")

let SKCore: Target   = .target(name: "SKCore",
                               path: "SKCore/Sources")

let SKRTMAPI: Target = .target(name: "SKRTMAPI",
                               path: "SKRTMAPI/Sources")
SKRTMAPI.dependencies = [
    "SKCore",
    "SKWebAPI",
    "Starscream",
]

let SKServer: Target = .target(name: "SKServer",
                               dependencies: ["SKCore", "SKWebAPI", "Swifter"],
                               path: "SKServer/Sources")

let SKWebAPI: Target = .target(name: "SKWebAPI",
                               dependencies: ["SKCore"],
                               path: "SKWebAPI/Sources")

let SlackKitTests: Target = .testTarget(name: "SlackKitTests",
                                        dependencies: ["SlackKit", "SKCore", "SKClient", "SKRTMAPI", "SKServer"],
                                        path: "SlackKitTests")
// MARK: Package

let package = Package(
    name: "SlackKit",
    products: [
        .library(name: "SlackKit", targets: ["SlackKit"]),
        .library(name: "SKClient", targets: ["SKClient"]),
        .library(name: "SKCore", targets: ["SKCore"]),
        .library(name: "SKRTMAPI", targets: ["SKRTMAPI"]),
        .library(name: "SKServer", targets: ["SKServer"]),
        .library(name: "SKWebAPI", targets: ["SKWebAPI"])
    ],
    targets: [
        SlackKit, SKClient, SKCore, SKRTMAPI, SKServer, SKWebAPI, SlackKitTests
    ]
)

package.dependencies = [
    .package(url: "https://github.com/httpswift/swifter.git", .upToNextMinor(from: "1.4.6")),
    .package(url: "https://github.com/daltoniam/Starscream", .upToNextMinor(from: "3.1.0"))
]
