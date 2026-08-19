import Observation

/// AR 세션에서 일어나는 일을 SwiftUI 화면에 전달하는 상태 저장소.
/// Coordinator(AR 세계)가 값을 쓰고, ContentView(SwiftUI 세계)가 값을 읽습니다.
@Observable
final class BodyTrackingState {
    /// 지금 카메라에 사람이 잡혀 있는지
    var isPersonDetected = false

    /// 로봇 모델 로딩에 실패했을 때의 에러 메시지 (성공하면 nil 유지)
    var loadErrorMessage: String?
}
