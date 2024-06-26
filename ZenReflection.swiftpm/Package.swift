// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Zen Reflection",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Zen Reflection",
            targets: ["AppModule"],
            bundleIdentifier: "jp.ac.kyusan-u.ZenReflection",
            teamIdentifier: "QU5MY7WAK3",
            displayVersion: "0.1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .microphone(purposeString: "This app uses a microphone."),
                .fileAccess(.userSelectedFiles, mode: .readWrite),
                .fileAccess(.musicFolder, mode: .readWrite)
            ],
            appCategory: .healthcareFitness
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)