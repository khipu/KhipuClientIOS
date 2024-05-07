//
//  KhenshinView.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 02-05-24.
//

import SwiftUI

@available(iOS 15.0.0, *)
public struct KhenshinView: View {
    @StateObject var viewModel = KhenshinViewModel()
    let operationId: String
    let options: KhenshinOptions
    
    init(operationId: String, options: KhenshinOptions) {
        self.operationId = operationId
        self.options = options
    }
    
    public var body: some View {
        Text("Mensaje recibido \(viewModel.uiState.currentMessageType)")
        Text(viewModel.uiState.connected ? "Connected" : "Disconnected")
            .onAppear(perform: {() in
                viewModel.setKhenshinSocketClient(
                    serverUrl: options.serverUrl,
                    publicKey: options.serverPublicKey)
                viewModel.connectClient()
            })
    }
}

@available(iOS 15.0.0, *)
struct KhenshinView_Previews: PreviewProvider {
    static var previews: some View {
        KhenshinView(operationId: "OPERATION ID", options: KhenshinOptions.Builder().build())
    }
}
