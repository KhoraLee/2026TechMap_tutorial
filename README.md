# 2026 TechMap — 모션 캡처 튜토리얼

ARKit 바디 트래킹으로 **카메라에 잡힌 사람 옆에 로봇이 나타나 그 사람의 동작을
실시간으로 따라 하는 앱**을 만드는 DocC 인터랙티브 튜토리얼입니다.

**👉 튜토리얼 보기: <https://khoralee.github.io/2026TechMap_tutorial/>**

- 대상 독자: Swift/SwiftUI는 알지만 AR·UIKit은 처음인 학습자
- 준비물: A12 칩 이상(iPhone XS/XR 이후)의 실기기(iOS 18+) — 시뮬레이터에서는 동작하지 않습니다
- 구성: 카메라와 사람 찾기 → 로봇 등장, 챕터별 스텝·코드 diff·퀴즈 포함

## 저장소 구조

`docs/`는 Xcode의 `xcodebuild docbuild`로 생성한 DocC 아카이브를
`docc process-archive transform-for-static-hosting`으로 변환한 정적 사이트이며,
GitHub Pages(main 브랜치 `/docs`)로 배포됩니다.
