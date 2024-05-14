//
//  KhenshinUiState.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 02-05-24.
//

import Foundation
import KhenshinProtocol

struct KhenshinUiState {
    var operationId: String = ""
    var bank: String = ""
    var currentMessageType: String = ""
    var currentForm: FormRequest? = nil
    var currentAuthorizationRequest: AuthorizationRequest? = nil
    var validatedFormItems: [String : Bool] = [:]
    var savedForm: [String : String] = [:]
    var progressInfoMessage: String = ""
    var translator: KhenshinTranslator = KhenshinTranslator(translations: [:])
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
}
