import SwiftUI

@available(iOS 13.0, *)
struct HeaderRepresentableComponent: UIViewRepresentable {
    @ObservedObject var viewModel: KhipuViewModel
    var baseView: (UIView & KhipuHeaderProtocol)
    
    func makeUIView(context: Context) -> UIView {
        return baseView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if (uiView is KhipuHeaderProtocol) {
            let header = uiView as! any KhipuHeaderProtocol as KhipuHeaderProtocol
            header.setSubject(viewModel.uiState.operationInfo?.subject ?? "")
            header.setAmount(viewModel.uiState.operationInfo?.amount ?? "")
            header.setMerchantName(viewModel.uiState.operationInfo?.merchant?.name ?? "")
            header.setPaymentMethod(viewModel.uiState.bank)
        }
    }
}
