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

        // 로봇을 매달아 둘 빈 앵커를 씬에 미리 넣어 둡니다.
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

        /// 추적 중인 앵커가 갱신될 때마다(매 프레임, 최대 60회/초) 호출됩니다.
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }

                // 배지 갱신 — 값이 바뀔 때만 써서 매 프레임 화면 갱신을 피합니다.
                if state.isPersonDetected != bodyAnchor.isTracked {
                    state.isPersonDetected = bodyAnchor.isTracked
                }

                // 사람 골반의 월드 좌표에 옆 오프셋을 더해 characterAnchor를 옮깁니다.
                let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
                characterAnchor.position = bodyPosition + sideOffset(from: session, to: bodyPosition)

                // 스켈레톤 포즈는 앵커의 '회전 기준' 상대값이라 회전도 함께 복사해야
                // 로봇이 사람과 같은 방향을 봅니다.
                characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation

                // "모델 로딩 완료 + 사람 감지" 두 조건이 처음 동시에 충족된 프레임에
                // 딱 한 번만 로봇을 앵커에 매답니다.
                if let character, character.parent == nil {
                    characterAnchor.addChild(character)
                }
            }
        }

        /// "카메라 → 사람" 방향과 수직인 수평 방향의 오프셋을 계산합니다.
        /// 방향을 매 프레임 카메라 기준으로 다시 구하므로, 어디서 찍어도 로봇이
        /// 화면상 사람의 왼쪽, 사람과 같은 거리(깊이)에 섭니다 — 방향을 월드 좌표에
        /// 고정하면 시점에 따라 로봇이 카메라 앞을 가로막아 화면을 꽉 채우게 됩니다.
        private func sideOffset(from session: ARSession, to bodyPosition: SIMD3<Float>) -> SIMD3<Float> {
            guard let camera = session.currentFrame?.camera else { return .zero }
            let cameraPosition = simd_make_float3(camera.transform.columns.3)
            let toBody = bodyPosition - cameraPosition
            let side = simd_cross([0, 1, 0], toBody)   // 하늘 방향 축과의 외적 = 수평 '옆' 방향
            guard simd_length(side) > 0.001 else { return .zero }   // 바로 위/아래에서 비추는 극단 시점
            return simd_normalize(side) * characterOffsetDistance
        }
    }
}
