import SwiftUI

@available(iOS 15.0, *)
struct ProgressComponent: View {
    @ObservedObject var khenshinViewModel: KhenshinViewModel

    var body: some View {
        VStack {
            ProgressView(value: Double(khenshinViewModel.uiState.currentProgress))
                .progressViewStyle(LinearProgressViewStyle(tint: Color.primary))
                .background(Color(UIColor.systemFill).opacity(0.2))
                .padding()
                .accessibility(identifier: "linearProgressIndicator")
        }
        .padding(.horizontal)
    }
}
