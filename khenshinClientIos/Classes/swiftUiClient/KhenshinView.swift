//
//  KhenshinView.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 02-05-24.
//

import SwiftUI
import KhenshinProtocol

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
                if(shouldShowHeader(currentMessageType: viewModel.uiState.currentMessageType)){
                    HeaderComponent(viewModel: viewModel)
                }
                Text("Mensaje recibido \(viewModel.uiState.currentMessageType)")
                Text(viewModel.uiState.connected ? "Connected" : "Disconnected")
            }.onAppear(perform: {
                viewModel.uiState.operationId = self.operationId
                viewModel.setKhenshinSocketClient(
                    serverUrl: options.serverUrl,
                    publicKey: options.serverPublicKey,
                    appName: Bundle.main.applicationName,
                    appVersion: Bundle.main.versionNumber,
                    locale: options.locale ?? "\(Locale.current.languageCode ?? "es")_\(Locale.current.regionCode ?? "CL")"
                )
                viewModel.connectClient()
            }).navigationTitle(options.topBarTitle ?? "<APPNAME>")
        
            switch(viewModel.uiState.currentMessageType) {
            case MessageType.formRequest.rawValue:
                FormComponent(formRequest: viewModel.uiState.currentForm!, viewModel: viewModel)
            default:
                Text("default")
            }
            if(viewModel.uiState.operationFinished) {
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
    
    func shouldShowHeader(currentMessageType: String) -> Bool {
        let excludedTypes = [
            MessageType.operationSuccess.rawValue,
            MessageType.operationFailure.rawValue,
            MessageType.operationMustContinue.rawValue,
            MessageType.operationWarning.rawValue
        ]

        return !excludedTypes.contains(currentMessageType)
    }
}

extension Bundle {
    /// Application name shown under the application icon.
    var applicationName: String {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            object(forInfoDictionaryKey: "CFBundleName") as? String ?? "NoAppName"
    }
    
    var versionNumber: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ??
            object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "NoAppVersion"
    }
}

@available(iOS 15.0.0, *)
struct KhenshinView_Previews: PreviewProvider {
    static var previews: some View {
        KhenshinView(operationId: "OPERATION ID", options: KhenshinOptions.Builder().build(), onComplete: nil, dismiss: {})
    }
}
