import Observation

/// AR 세션에서 일어나는 일을 SwiftUI 화면에 전달하는 상태 저장소.
/// Coordinator가 값을 쓰고, ContentView가 값을 읽는 공유 상태.
@Observable
final class BodyTrackingState {
    /// 지금 카메라에 사람이 잡혀 있는지
    var isPersonDetected = false
}
