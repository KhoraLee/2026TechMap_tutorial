// swift-tools-version: 5.9

import PackageDescription

// DocC 튜토리얼만 담는 문서 전용 패키지입니다.
// 실제 앱 코드(BodyMotionDemo)는 별도의 비공개 Xcode 프로젝트에 있고,
// 여기에는 튜토리얼 카탈로그(MotionCapture.docc)와 그 카탈로그를 빌드하기 위한
// 빈 타깃만 두어 GitHub Actions에서 macOS 러너로 빠르게 문서를 빌드합니다.
let package = Package(
    name: "MotionCapture",
    products: [
        .library(name: "MotionCapture", targets: ["MotionCapture"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.5.0")
    ],
    targets: [
        .target(name: "MotionCapture")
    ]
)
