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
    @StateObject var viewModel = KhenshinViewModel()
    var dismiss: (() -> Void)
    let operationId: String
    let options: KhenshinOptions
    let completitionHandler: ((KhipuResult) -> Void)?

    init(operationId: String,
         options: KhenshinOptions,
         onComplete: ((KhipuResult) -> Void)?,
         dismiss: @escaping (() -> Void)) {
        self.operationId = operationId
        self.options = options
        self.completitionHandler = onComplete
        self.dismiss = dismiss
    }
    
    public var body: some View {
        VStack(alignment: .leading, content: {
            VStack {
                if(shouldShowHeader(currentMessageType: viewModel.uiState.currentMessageType)){
                    HeaderComponent(viewModel: viewModel)
                }
                EmptyView()
            }
            switch(viewModel.uiState.currentMessageType) {
            case MessageType.formRequest.rawValue:
                ProgressComponent(khenshinViewModel: viewModel)
                FormComponent(formRequest: viewModel.uiState.currentForm!, viewModel: viewModel)
            case MessageType.operationFailure.rawValue:
                if (viewModel.uiState.operationFailure?.reason == FailureReasonType.formTimeout) {
                    TimeoutMessageComponent(operationFailure: viewModel.uiState.operationFailure!,viewModel: viewModel)
                }else {
                    FailureMessageComponent(operationFailure: viewModel.uiState.operationFailure!,viewModel: viewModel)
                }
            case MessageType.operationWarning.rawValue:
                WarningMessageComponent(operationWarning: viewModel.uiState.operationWarning!,viewModel: viewModel)
            case MessageType.operationSuccess.rawValue:
                SuccessMessageComponent(operationSuccess: viewModel.uiState.operationSuccess!,viewModel: viewModel)
            case MessageType.progressInfo.rawValue:
                ProgressComponent(khenshinViewModel: viewModel)
                ProgressInfoComponent(message: viewModel.uiState.progressInfoMessage)
            case MessageType.authorizationRequest.rawValue:
                ProgressComponent(khenshinViewModel: viewModel)
            default:
                EmptyView()
            }
            if(viewModel.uiState.returnToApp) {
                ExecuteCode {
                    viewModel.disconnectClient()
                    completitionHandler!(buildResult(viewModel.uiState))
                    dismiss()
                }
            }
        })
        .navigationBarBackButtonHidden(true)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.uiState.returnToApp = true
                } label: {
                    Image(systemName: "xmark").tint(Color.red)
                }
            }
            ToolbarItem(placement: .principal) {
                if (options.topBarImageResourceName == nil) {
                    Text(options.topBarTitle ?? appName()).foregroundStyle(Color.red)
                } else {
                    Image(options.topBarImageResourceName!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }.onAppear(perform: {
            viewModel.uiState.operationId = self.operationId
            viewModel.setKhenshinSocketClient(
                serverUrl: options.serverUrl,
                publicKey: options.serverPublicKey,
                appName: appName(),
                appVersion: appVersion(),
                locale: options.locale ?? "\(Locale.current.languageCode ?? "es")_\(Locale.current.regionCode ?? "CL")"
            )
            viewModel.connectClient()
        })
        
    }

    func buildResult(_ state: KhenshinUiState) -> KhipuResult {
        if (viewModel.uiState.operationSuccess != nil) {
            return KhipuResult(
                operationId: cleanString(viewModel.uiState.operationSuccess?.operationID),
                exitTitle: cleanString(viewModel.uiState.operationSuccess?.title),
                exitMessage: cleanString(viewModel.uiState.operationSuccess?.body),
                result: "OK",
                events: cleanEvents(viewModel.uiState.operationSuccess?.events),
                exitUrl: cleanString(viewModel.uiState.operationSuccess?.exitURL),
                failureReason: nil,
                continueUrl: nil
            )
        } else if (viewModel.uiState.operationFailure != nil) {
            return KhipuResult(
                operationId: cleanString(viewModel.uiState.operationFailure?.operationID),
                exitTitle: cleanString(viewModel.uiState.operationFailure?.title),
                exitMessage: cleanString(viewModel.uiState.operationFailure?.body),
                result: "ERROR",
                events: cleanEvents(viewModel.uiState.operationFailure?.events),
                exitUrl: cleanString(viewModel.uiState.operationFailure?.exitURL),
                failureReason: cleanString(viewModel.uiState.operationFailure?.reason?.rawValue),
                continueUrl: nil
            )
        } else if (viewModel.uiState.operationWarning != nil) {
            return KhipuResult(
                operationId: cleanString(viewModel.uiState.operationWarning?.operationID),
                exitTitle: cleanString(viewModel.uiState.operationWarning?.title),
                exitMessage: cleanString(viewModel.uiState.operationWarning?.body),
                result: "WARNING",
                events: cleanEvents(viewModel.uiState.operationWarning?.events),
                exitUrl: cleanString(viewModel.uiState.operationWarning?.exitURL),
                failureReason: cleanString(viewModel.uiState.operationWarning?.reason?.rawValue),
                continueUrl: nil
            )
        } else if (viewModel.uiState.operationMustContinue != nil) {
            return KhipuResult(
                operationId: cleanString(viewModel.uiState.operationMustContinue?.operationID),
                exitTitle: cleanString(viewModel.uiState.operationMustContinue?.title),
                exitMessage: cleanString(viewModel.uiState.operationMustContinue?.body),
                result: "CONTINUE",
                events: cleanEvents(viewModel.uiState.operationMustContinue?.events),
                exitUrl: cleanString(viewModel.uiState.operationMustContinue?.exitURL),
                failureReason: cleanString(viewModel.uiState.operationMustContinue?.reason?.rawValue),
                continueUrl: cleanString(viewModel.uiState.operationInfo?.urls?.info)
            )
        }
        
        return KhipuResult(
            operationId: cleanString(getOperationId(viewModel.uiState)),
            exitTitle: cleanString(viewModel.uiState.translator.t("page.operationFailure.operation.user.canceled.title", default: "")),
            exitMessage: cleanString(viewModel.uiState.translator.t("page.operationFailure.operation.user.canceled.body", default: "")),
            result: "ERROR",
            events: [KhipuEvent](),
            exitUrl: "",
            failureReason: cleanString(FailureReasonType.userCanceled.rawValue),
            continueUrl: nil
        )
    }
    
    func getOperationId(_ uiState: KhenshinUiState) -> String? {
        if (uiState.operationInfo?.operationID == nil || uiState.operationInfo!.operationID!.isEmpty) {
            return uiState.operationId
        } else {
            return uiState.operationInfo?.operationID
        }
    }
    
    func cleanString(_ toClean: String?) -> String {
        return toClean ?? ""
    }
    
    func cleanEvents(_ events: [OperationEvent]?) -> [KhipuEvent] {
        if (events == nil) {
            return [KhipuEvent]()
        }
        return events!.map { KhipuEvent(name: $0.name, timestamp: $0.timestamp, type: $0.type)}
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

@available(iOS 15.0.0, *)
struct KhenshinView_Previews: PreviewProvider {
    static var previews: some View {
        KhenshinView(operationId: "OPERATION ID", options: KhenshinOptions.Builder().build(), onComplete: nil, dismiss: {})
    }
}
