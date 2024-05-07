//
//  KhenshinView.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 02-05-24.
//

import SwiftUI

@available(iOS 15.0.0, *)
public struct KhenshinView: View {
    var dismiss: (() -> Void)
    @StateObject var viewModel = KhenshinViewModel()
    let operationId: String
    let options: KhenshinOptions
    let completitionHandler: ((KhenshinResult) -> Void)?
    
    init(operationId: String,
         options: KhenshinOptions,
         onComplete: ((KhenshinResult) -> Void)?,
         dismiss: @escaping (() -> Void)) {
        self.operationId = operationId
        self.options = options
        self.completitionHandler = onComplete
        self.dismiss = dismiss
    }
    
    public var body: some View {
        VStack {
            Text("Mensaje recibido \(viewModel.uiState.currentMessageType)")
            Text(viewModel.uiState.connected ? "Connected" : "Disconnected")            
        }.onAppear(perform: {
            viewModel.setKhenshinSocketClient(
                serverUrl: options.serverUrl,
                publicKey: options.serverPublicKey)
            viewModel.connectClient()
        })
        if(viewModel.uiState.returnToApp) {
            Button("Done") {
                completitionHandler!(buildResult(viewModel.uiState))
                dismiss()
            }
        }
    }
    
    func buildResult(_ state: KhenshinUiState) -> KhenshinResult {
        return KhenshinResult(
            operationId: operationId,
            exitTitle: "Exit Title",
            exitMessage: "Exit Message",
            exitUrl: "Exit url",
            continueUrl: "Continue url",
            result: "Result",
            failureReason: "Failure reason"
        )
    }
}

@available(iOS 15.0.0, *)
struct KhenshinView_Previews: PreviewProvider {
    static var previews: some View {
        KhenshinView(operationId: "OPERATION ID", options: KhenshinOptions.Builder().build(), onComplete: nil, dismiss: {})
    }
}
