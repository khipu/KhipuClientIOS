//
//  KhenshinViewModel.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 02-05-24.
//

import Foundation
import KhenshinProtocol

@available(iOS 13.0, *)
public class KhenshinViewModel: ObservableObject {
    var khenshinSocketClient: KhenshinClient? = nil
    @Published var uiState = KhenshinUiState()
    
    func setKhenshinSocketClient(serverUrl: String, publicKey: String) {
        if(khenshinSocketClient == nil) {
            khenshinSocketClient = KhenshinClient(serverUrl: serverUrl, publicKey: publicKey, viewModel: self)
            //khenshinSocketClient = KhenshinClient(serverUrl: "https://khenshin-ws.khipu.com", publicKey: "mp4j+M037aSEnCuS/1vr3uruFoeEOm5O1ugB+LLoUyw=", viewModel: self)
        }
    }
    
    func connectClient() {
        khenshinSocketClient?.connect()
    }
    
    public func setSiteOperationComplete(type: OperationType, value: String) {
        switch type{
        case OperationType.bankSelected:
            uiState.bank = value
        case OperationType.accountNumberSelected:
            uiState.bankAccountNumber = value
        case OperationType.amountUpdated:
            uiState.operationInfo.amount = value
        case OperationType.personalIdentifier:
            uiState.personalIdentifier = value
        default:
            return
        }
    }
    
}
