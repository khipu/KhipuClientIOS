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
    
    func setKhenshinSocketClient(serverUrl: String, publicKey: String, appName: String, appVersion: String, locale: String) {
        if(khenshinSocketClient == nil) {
            khenshinSocketClient = KhenshinClient(serverUrl: serverUrl, publicKey: publicKey, appName: appName, appVersion: appVersion, locale: locale, viewModel: self)
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
            let operationInfo = OperationInfo(acceptManualTransfer: uiState.operationInfo?.acceptManualTransfer,
                                              amount: value,
                                              body: uiState.operationInfo?.body,
                                              email: uiState.operationInfo?.email,
                                              merchant: uiState.operationInfo?.merchant,
                                              operationID: uiState.operationInfo?.operationID,
                                              subject: uiState.operationInfo?.subject,
                                              type: MessageType.operationInfo,
                                              urls: uiState.operationInfo?.urls,
                                              welcomeScreen: uiState.operationInfo?.welcomeScreen)
            uiState.operationInfo = operationInfo
        case OperationType.personalIdentifier:
            uiState.personalIdentifier = value
        default:
            return
        }
    }
    
}
