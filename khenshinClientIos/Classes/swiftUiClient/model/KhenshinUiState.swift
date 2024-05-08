//
//  KhenshinUiState.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 02-05-24.
//

import Foundation
import KhenshinProtocol

struct KhenshinUiState {
    //static func == (lhs: KhenshinUiState, rhs: KhenshinUiState) -> Bool {
    //    return lhs.operationId == rhs.operationId
    //}
    
    var connected: Bool = false
    var operationFinished: Bool = false
    var operationId: String = ""
    var bank: String
    var currentMessageType: String = ""
    var currentForm: FormRequest
    var currentAuthorizationRequest: AuthorizationRequest
    var validatedFormItems: [String : Bool]
    //var savedForm: Map
    var progressInfoMessage: String
    var translator: KhenshinTranslator = KhenshinTranslator(translations: [:])
    var operationInfo: OperationInfo
    var operationSuccess: OperationSuccess
    var operationFailure: OperationFailure
    var operationMustContinue: OperationMustContinue
    var operationWarning: OperationWarning
    var returnToApp: Bool = false
    var openManualUrl: Bool = false
    var isRutKeyboardVisible: Bool = false
    //var rutFieldUpdater: FieldUpdater
    //var fieldUpdaters: MutableMap
    //var doNotLoadForm: MutableMap
    var hasAskedAuthentication: Bool = false
    var skipExitPage: Bool = false
    //var currentProgress: Float
    var bankAccountNumber: String
    var personalIdentifier: String
}
