import SwiftUI
import RealityKit
import ARKit

/// SwiftUI 세계에 UIKit 뷰(ARView)를 올려 주는 어댑터.
struct ARViewContainer: UIViewRepresentable {
    let state: BodyTrackingState

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // 사람(몸)을 추적하는 모드로 카메라 세션을 시작합니다.
        arView.session.delegate = context.coordinator
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)

        // 로봇을 매달아 둘 빈 깃발(앵커)을 씬에 미리 꽂아 둡니다.
        arView.scene.addAnchor(context.coordinator.characterAnchor)

        // 로봇 모델은 약 14MB라 비동기로 로딩합니다.
        context.coordinator.loadCharacter()

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(state: state)
    }
}

extension ARViewContainer {
    /// ARSession이 보내는 소식(앵커 추가·갱신)을 받는 우체통.
    final class Coordinator: NSObject, ARSessionDelegate {
        let state: BodyTrackingState

        /// 로봇을 매달아 둘 빈 앵커. 씬에 상주하며 매 프레임 사람 위치로 이동합니다.
        let characterAnchor = AnchorEntity()

        /// 로딩이 끝난 로봇 모델 (로딩 전에는 nil)
        var character: BodyTrackedEntity?

        /// 로봇을 사람 옆에 세울 거리(m) — 0으로 바꾸면 사람과 겹쳐 섭니다.
        let characterOffsetDistance: Float = 1.0

        init(state: BodyTrackingState) {
            self.state = state
        }

        func loadCharacter() {
            Task {
                do {
                    let robot = try await BodyTrackedEntity(named: "robot")
                    robot.scale = [1.0, 1.0, 1.0]   // 사람과 같은 실물 크기
                    character = robot
                } catch {
                    state.loadErrorMessage = "로봇 모델을 불러오지 못했어요: \(error.localizedDescription)"
                }
            }
        }

        /// 새 앵커가 '처음' 생길 때 한 번만 호출됩니다 — 사람을 처음 발견한 순간.
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard anchors.contains(where: { $0 is ARBodyAnchor }) else { return }
            print("사람 감지됨!")
            state.isPersonDetected = true
        }
    }
}
