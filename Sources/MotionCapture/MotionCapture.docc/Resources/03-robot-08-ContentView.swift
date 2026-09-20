import SwiftUI
import ARKit

struct ContentView: View {
    /// AR 세계(Coordinator)와 SwiftUI 화면을 잇는 공유 상태
    @State private var trackingState = BodyTrackingState()

    var body: some View {
        // 바디 트래킹은 A12 칩 이상 실기기에서만 지원됩니다.
        // 시뮬레이터와 구형 기기에서는 isSupported가 false입니다.
        if ARBodyTrackingConfiguration.isSupported {
            ZStack(alignment: .top) {
                ARViewContainer(state: trackingState)
                    .ignoresSafeArea()

                VStack(spacing: 8) {
                    detectionBadge
                    if let message = trackingState.loadErrorMessage {
                        errorBanner(message)
                    }
                }
                .padding(.top, 8)
            }
        } else {
            unsupportedView
        }
    }

    /// 사람 감지 상태를 보여주는 상단 배지
    private var detectionBadge: some View {
        Text(trackingState.isPersonDetected ? "🟢 사람 감지됨" : "⚪️ 사람을 찾는 중…")
            .font(.headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.thinMaterial, in: Capsule())
    }

    /// 로봇 모델 로딩 실패 시 보여주는 빨간 배너
    private func errorBanner(_ message: String) -> some View {
        Text(message)
            .font(.callout)
            .foregroundStyle(.white)
            .padding()
            .background(.red.opacity(0.85), in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
    }

    /// 미지원 기기(및 시뮬레이터)에서 보여주는 안내 화면
    private var unsupportedView: some View {
        ContentUnavailableView(
            "이 기기는 모션 캡처를 지원하지 않아요",
            systemImage: "figure.walk.motion",
            description: Text("바디 트래킹은 A12 칩 이상을 탑재한 실제 iPhone/iPad에서만 동작합니다. 시뮬레이터에서는 항상 이 화면이 보입니다.")
        )
    }
}

#Preview {
    ContentView()
}
