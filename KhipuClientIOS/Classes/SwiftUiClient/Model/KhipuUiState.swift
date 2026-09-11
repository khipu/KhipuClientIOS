import CoreLocation
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
    /// Message type of a terminal message that could not be read, or nil.
    ///
    /// Distinguishes "the operation ended because we could not decode the message" from
    /// "the person cancelled". Both leave every `operation*` object nil, so without this
    /// `buildResult` cannot tell them apart and reports the wrong cause to the merchant.
    var unprocessableMessageType: String? = nil
    var returnToApp: Bool = false
    var openManualUrl: Bool = false
    var isRutKeyboardVisible: Bool = false
    var rutFieldUpdater: FieldUpdater = FieldUpdater()
    var fieldUpdaters: [String: FieldUpdater] = [:]
    var doNotLoadForm: [String: Bool] = [:]
    var hasAskedAuthentication: Bool = false
    var skipExitPage: Bool = false
    var skipExitSuccessPage: Bool = false
    var currentProgress: Float = 0
    var bankAccountNumber: String = ""
    var personalIdentifier: String = ""
    var storedUsername: String = ""
    var storedPassword: String = ""
    var storedBankForms: [String] = []
    var showFooter: Bool = true
    var connectedSocket: Bool = true
    var connectedNetwork: Bool = true
    var operationFinished: Bool = false
    var showMerchantLogo: Bool = true
    var showPaymentDetails: Bool = true
    var locationAuthStatus: CLAuthorizationStatus = .notDetermined
    var currentLocation: CLLocation?
    var geolocationAcquired: Bool = false
    var geolocationAccessDeclinedAtWarningView: Bool = false
    var geolocationRequested: Bool = false
}
