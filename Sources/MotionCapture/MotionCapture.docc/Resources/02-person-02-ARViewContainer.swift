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
    /// ARSession이 보내는 소식(앵커 추가·갱신)을 받는 우체통.
    final class Coordinator: NSObject, ARSessionDelegate {
        let state: BodyTrackingState

        init(state: BodyTrackingState) {
            self.state = state
        }
    }
}
