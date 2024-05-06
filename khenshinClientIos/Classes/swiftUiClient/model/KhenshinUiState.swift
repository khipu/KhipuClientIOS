//
//  KhenshinUiState.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 02-05-24.
//

import Foundation

struct KhenshinUiState: Hashable {
    var connected: Bool = false
    var operationFinished: Bool = false
    var operationId: String = ""
    //var bank: String
    var currentMessageType: String = ""
    //var currentForm: FormRequest
    //var currentAuthorizationRequest: AuthorizationRequest
    //var validatedFormItems: Map
    //var savedForm: Map
    //var progressInfoMessage: String
    //var translator: KhenshinTranslator
    //var operationInfo: OperationInfo
    //var operationSuccess: OperationSuccess
    //var operationFailure: OperationFailure
    //var operationMustContinue: OperationMustContinue
    //var operationWarning: OperationWarning
    var returnToApp: Bool = false
    var openManualUrl: Bool = false
    var isRutKeyboardVisible: Bool = false
    //var rutFieldUpdater: FieldUpdater
    //var fieldUpdaters: MutableMap
    //var doNotLoadForm: MutableMap
    var hasAskedAuthentication: Bool = false
    var skipExitPage: Bool = false
    //var currentProgress: Float
    //var bankAccountNumber: String
    //var personalIdentifier: String
}
