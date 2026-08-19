# 2026 TechMap — 모션 캡처 튜토리얼

ARKit 바디 트래킹으로 **카메라에 잡힌 사람 옆에 로봇이 나타나 그 사람의 동작을
실시간으로 따라 하는 앱**을 만드는 DocC 인터랙티브 튜토리얼입니다.

**👉 튜토리얼 보기: <https://khoralee.github.io/2026TechMap_tutorial/>**

- 대상 독자: Swift/SwiftUI는 알지만 AR·UIKit은 처음인 학습자
- 준비물: A12 칩 이상(iPhone XS/XR 이후)의 실기기(iOS 18+) — 시뮬레이터에서는 동작하지 않습니다
- 구성: 카메라와 사람 찾기 → 로봇 등장, 챕터별 스텝·코드 diff·퀴즈 포함

## 저장소 구조

- `Sources/MotionCapture/MotionCapture.docc/` — 튜토리얼 원본(DocC 카탈로그). 본문·퀴즈와
  각 스텝의 코드 리스팅(`Resources/`)이 모두 여기에 있습니다.
- `Package.swift` — 카탈로그를 빌드하기 위한 **문서 전용** Swift 패키지입니다.
  심벌이 없는 빈 타깃 하나와 [swift-docc-plugin](https://github.com/swiftlang/swift-docc-plugin)만
  두었습니다. 앱 프로젝트(`BodyMotionDemo`)는 비공개이며 이 레포에 포함되지 않습니다.
- `.github/workflows/deploy-docs.yml` — `main`에 push하면 문서를 빌드해 GitHub Pages로
  배포하는 워크플로입니다.

로컬에서 미리 보기:

```sh
swift package --disable-sandbox preview-documentation --target MotionCapture
```

정적 사이트를 직접 만들어 보려면:

```sh
swift package --allow-writing-to-directory ./docs \
  generate-documentation --target MotionCapture \
  --transform-for-static-hosting --hosting-base-path 2026TechMap_tutorial \
  --output-path ./docs
```
