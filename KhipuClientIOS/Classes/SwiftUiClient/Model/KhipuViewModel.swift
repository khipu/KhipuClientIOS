import Foundation
import KhenshinProtocol

@available(iOS 13.0, *)
public class KhipuViewModel: ObservableObject {
    var khipuSocketIOClient: KhipuSocketIOClient? = nil
    @Published var uiState = KhipuUiState()

    func setKhipuSocketIOClient(serverUrl: String, browserId: String, publicKey: String, appName: String, appVersion: String, locale: String, skipExitPage: Bool, showFooter:Bool) {
        if(khipuSocketIOClient == nil) {
            khipuSocketIOClient = KhipuSocketIOClient(serverUrl: serverUrl, browserId: browserId, publicKey: publicKey, appName: appName, appVersion: appVersion, locale: locale, skipExitPage: skipExitPage, showFooter: showFooter,viewModel: self)
        }
    }

    func restartPayment(){
        uiState.bank = ""
        khipuSocketIOClient?.reconnect()
        notifyViewUpdate()
    }

    func notifyViewUpdate() {
        objectWillChange.send()
    }

    func connectClient() {
        khipuSocketIOClient?.connect()
    }

    func disconnectClient() {
        khipuSocketIOClient?.disconnect()
        khipuSocketIOClient = nil
    }

    public func setCurrentProgress(currentProgress: Float){
        uiState.currentProgress=currentProgress
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
