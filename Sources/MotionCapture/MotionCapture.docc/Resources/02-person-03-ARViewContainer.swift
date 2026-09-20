import SwiftUI
import RealityKit
import ARKit

/// SwiftUI 세계에 UIKit 뷰(ARView)를 올려 주는 어댑터.
struct ARViewContainer: UIViewRepresentable {
    let state: BodyTrackingState

    func makeUIView(context: Context) -> ARView {
        ARView(frame: .zero)
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(state: state)
    }
}

extension ARViewContainer {
    /// ARSession의 delegate. 앵커가 추가·갱신될 때 ARKit이 이 객체의 메서드를 호출합니다.
    final class Coordinator: NSObject, ARSessionDelegate {
        let state: BodyTrackingState

        init(state: BodyTrackingState) {
            self.state = state
        }

        /// 새 앵커가 '처음' 생길 때 한 번만 호출됩니다 — 사람을 처음 발견한 순간.
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard anchors.contains(where: { $0 is ARBodyAnchor }) else { return }
            print("사람 감지됨!")
            state.isPersonDetected = true
        }
    }
}
