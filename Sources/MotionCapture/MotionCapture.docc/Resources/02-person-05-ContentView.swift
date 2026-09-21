import SwiftUI

struct ContentView: View {
    /// Coordinator와 SwiftUI 화면을 잇는 공유 상태
    @State private var trackingState = BodyTrackingState()

    var body: some View {
        ARViewContainer(state: trackingState)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
