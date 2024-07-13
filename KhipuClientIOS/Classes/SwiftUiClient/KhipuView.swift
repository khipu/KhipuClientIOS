//
//  KhenshinView.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 02-05-24.
//

import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
public struct KhipuView: View {
    @StateObject var themeManager = ThemeManager()
    @StateObject var viewModel = KhipuViewModel()
    @AppStorage("storedBankCredentials") private var storedBankForms: String = ""
    @AppStorage("browserId") private var browserId: String?
    @Environment(\.colorScheme) var colorScheme
    let operationId: String
    let options: KhipuOptions
    let completitionHandler: ((KhipuResult) -> Void)?
    let hostingControllerContainer: HostingControllerContainer

    init(operationId: String,
         options: KhipuOptions,
         onComplete: ((KhipuResult) -> Void)?,
         hostingControllerContainer: HostingControllerContainer) {
        self.operationId = operationId
        self.options = options
        self.completitionHandler = onComplete
        self.hostingControllerContainer = hostingControllerContainer
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBarComponent(title: options.topBarTitle, imageName: options.topBarImageResourceName, imageUrl: options.topBarImageUrl, viewModel: viewModel)
            VStack {
                if(shouldShowHeader(currentMessageType: viewModel.uiState.currentMessageType)){
                    if(options.header != nil && options.header?.headerUIView != nil){
                        HeaderRepresentableComponent(viewModel: viewModel, baseView: options.header!.headerUIView!)
                            .frame(maxHeight: CGFloat(integerLiteral: options.header?.height ?? 100))
                    } else {
                        HeaderComponent(viewModel: viewModel)
                    }
                }
            }
            ScrollView(.vertical){
                switch(viewModel.uiState.currentMessageType) {
                case MessageType.formRequest.rawValue:
                    ProgressComponent(viewModel: viewModel)
                    FormComponent(formRequest: viewModel.uiState.currentForm!, viewModel: viewModel)
                case MessageType.operationFailure.rawValue:
                    if (!options.skipExitPage) {
                        if(viewModel.uiState.operationFailure?.reason == FailureReasonType.bankWithoutAutomaton){
                            RedirectToManualComponent(operationFailure: viewModel.uiState.operationFailure!,viewModel: viewModel)
                        }else if (viewModel.uiState.operationFailure?.reason == FailureReasonType.formTimeout) {
                            TimeoutMessageComponent(operationFailure: viewModel.uiState.operationFailure!,viewModel: viewModel)

                        } else {
                            FailureMessageComponent(operationFailure: viewModel.uiState.operationFailure!,viewModel: viewModel)
                        }
                        FooterComponent(viewModel: viewModel)


                    }
                case MessageType.operationWarning.rawValue:
                    if (!options.skipExitPage) {
                        WarningMessageComponent(operationWarning: viewModel.uiState.operationWarning!,viewModel: viewModel)
                        FooterComponent(viewModel: viewModel)
                    }
                case MessageType.operationSuccess.rawValue:
                    if (!options.skipExitPage){
                        SuccessMessageComponent(operationSuccess: viewModel.uiState.operationSuccess!,viewModel: viewModel)
                        FooterComponent(viewModel: viewModel)
                    }
                case MessageType.progressInfo.rawValue:
                    ProgressComponent(viewModel: viewModel)
                    ProgressInfoComponent(message: viewModel.uiState.progressInfoMessage)
                case MessageType.authorizationRequest.rawValue:
                    ProgressComponent(viewModel: viewModel)
                    AuthorizationRequestView(viewModel: viewModel)
                    FooterComponent(viewModel: viewModel)
                case MessageType.operationMustContinue.rawValue:
                    if (!options.skipExitPage) {
                        MustContinueComponent(viewModel: viewModel, operationMustContinue: viewModel.uiState.operationMustContinue!)
                        FooterComponent(viewModel: viewModel)
                    }

                default:
                    EndToEndEncryption(viewModel: viewModel)
                }
                if(viewModel.uiState.returnToApp) {
                    ExecuteCode {
                        viewModel.disconnectClient()
                        completitionHandler!(buildResult(viewModel.uiState))
                        hostingControllerContainer.hostingController?.dismiss(animated: true)
                    }
                }
                Spacer()
            }
        }
        .background(themeManager.selectedTheme.colors.background)
        .navigationBarBackButtonHidden(true)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .onAppear(perform: {
            if(browserId == nil) {
                browserId = UUID().uuidString
            }
            viewModel.uiState.operationId = self.operationId
            viewModel.setKhipuSocketIOClient(
                serverUrl: options.serverUrl,
                browserId: browserId!,
                publicKey: options.serverPublicKey,
                appName: appName(),
                appVersion: appVersion(),
                locale: options.locale ?? "\(Locale.current.languageCode ?? "es")_\(Locale.current.regionCode ?? "CL")",
                skipExitPage: options.skipExitPage, 
                showFooter: options.showFooter
            )
            viewModel.connectClient()
            themeManager.selectedTheme.setColorSchemeAndCustomColors(colorScheme: colorScheme, colors: options.colors)
            viewModel.uiState.storedBankForms = storedBankForms.split(separator: "|")
                .map { String($0) }
        })
        .environmentObject(themeManager)



    }

    func buildResult(_ state: KhipuUiState) -> KhipuResult {
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

    func getOperationId(_ uiState: KhipuUiState) -> String? {
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
struct KhipuView_Previews: PreviewProvider {
    static var previews: some View {
        KhipuView(operationId: "rgq1gwc0rprl", options: KhipuOptions.Builder().build(), onComplete: nil, hostingControllerContainer: HostingControllerContainer())
    }
}
