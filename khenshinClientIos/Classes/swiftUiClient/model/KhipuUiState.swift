import Foundation
import KhenshinProtocol

struct KhipuUiState {
    var operationId: String = ""
    var bank: String = ""
    var currentMessageType: String = ""
    var currentForm: FormRequest? = nil
    var currentAuthorizationRequest: AuthorizationRequest? = nil
    var validatedFormItems: [String : Bool] = [:]
    var savedForm: [String : String] = [:]
    var progressInfoMessage: String = ""
    var translator: KhipuTranslator = KhipuTranslator(translations: [:])
    var operationInfo: OperationInfo? = nil
    var operationSuccess: OperationSuccess? = nil
    var operationFailure: OperationFailure? = nil
    var operationMustContinue: OperationMustContinue? = nil
    var operationWarning: OperationWarning? = nil
    var returnToApp: Bool = false
    var openManualUrl: Bool = false
    var isRutKeyboardVisible: Bool = false
    var rutFieldUpdater: FieldUpdater = FieldUpdater()
    var fieldUpdaters: [String: FieldUpdater] = [:]
    var doNotLoadForm: [String: Bool] = [:]
    var hasAskedAuthentication: Bool = false
    var skipExitPage: Bool = false
    var currentProgress: Float = 0
    var bankAccountNumber: String = ""
    var personalIdentifier: String = ""
    var storedUsername: String = ""
    var storedPassword: String = ""
    var storedForm: Bool = false
}
