import CoreLocation
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
            NavigationBarComponent(title: options.topBarTitle, imageName: options.topBarImageResourceName, imageUrl: options.topBarImageUrl, imageScale: options.topBarImageScale, translator: viewModel.uiState.translator, returnToApp: {
                
                let userCanceled = UserCanceled(
                    message: nil,
                    type: MessageType.userCanceled
                )
                try? viewModel.khipuSocketIOClient?.sendMessage(type: userCanceled.type.rawValue, message: userCanceled.jsonString()!)
                Task {
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    await MainActor.run {
                        viewModel.uiState.returnToApp=true
                    }
                }
            })
            VStack {
                if(shouldShowHeader(currentMessageType: viewModel.uiState.currentMessageType)){
                    if(options.header != nil && options.header?.headerUIView != nil){
                        HeaderRepresentableComponent(viewModel: viewModel, baseView: options.header!.headerUIView!)
                            .frame(maxHeight: CGFloat(integerLiteral: options.header?.height ?? 100))
                    } else {
                        HeaderComponent(showMerchantLogo: viewModel.uiState.showMerchantLogo, showPaymentDetails: viewModel.uiState.showPaymentDetails,operationInfo: viewModel.uiState.operationInfo, translator: viewModel.uiState.translator)
                    }
                }
            }
            ScrollView(.vertical){
                switch(viewModel.uiState.currentMessageType) {
                case MessageType.formRequest.rawValue:
                    ProgressComponent(currentProgress: viewModel.uiState.currentProgress)
                    FormComponent(formRequest: viewModel.uiState.currentForm!, viewModel: viewModel)
                case MessageType.operationFailure.rawValue:
                    if (!options.skipExitPage) {
                        if(viewModel.uiState.operationFailure?.reason == FailureReasonType.bankWithoutAutomaton){
                            RedirectToManualView(operationFailure: viewModel.uiState.operationFailure!, translator: viewModel.uiState.translator, operationInfo: viewModel.uiState.operationInfo!, restartPayment: viewModel.restartPayment)
                        }else if (viewModel.uiState.operationFailure?.reason == FailureReasonType.formTimeout) {
                            TimeoutMessageView(operationFailure: viewModel.uiState.operationFailure!, translator: viewModel.uiState.translator, returnToApp: {viewModel.uiState.returnToApp=true})
                        } else {
                            FailureMessageView(operationFailure: viewModel.uiState.operationFailure!, operationInfo: viewModel.uiState.operationInfo, translator: viewModel.uiState.translator, returnToApp: {viewModel.uiState.returnToApp=true})
                        }
                        FooterComponent(translator: viewModel.uiState.translator, showFooter: viewModel.uiState.showFooter)
                    }
                case MessageType.operationWarning.rawValue:
                    if (!options.skipExitPage) {
                        WarningMessageView(operationWarning: viewModel.uiState.operationWarning!, operationInfo: viewModel.uiState.operationInfo, translator: viewModel.uiState.translator, returnToApp: {viewModel.uiState.returnToApp=true})
                        FooterComponent(translator: viewModel.uiState.translator, showFooter: viewModel.uiState.showFooter)
                    }
                case MessageType.operationSuccess.rawValue:
                    if (!options.skipExitPage && !options.skipExitSuccessPage){
                        SuccessMessageView(operationSuccess: viewModel.uiState.operationSuccess!, translator: viewModel.uiState.translator, operationInfo: viewModel.uiState.operationInfo, returnToApp: {viewModel.uiState.returnToApp=true})
                        FooterComponent(translator: viewModel.uiState.translator, showFooter: viewModel.uiState.showFooter)
                    }
                case MessageType.progressInfo.rawValue:
                    ProgressComponent(currentProgress: viewModel.uiState.currentProgress)
                    ProgressInfoView(message: viewModel.uiState.progressInfoMessage)
                case MessageType.authorizationRequest.rawValue:
                    ProgressComponent(currentProgress: viewModel.uiState.currentProgress)


                    if let authorizationRequest = viewModel.uiState.currentAuthorizationRequest {

                        AuthorizationRequestView(authorizationRequest:authorizationRequest, translator: viewModel.uiState.translator, bank: viewModel.uiState.bank)
                    }
                    FooterComponent(translator: viewModel.uiState.translator, showFooter: viewModel.uiState.showFooter)
                case MessageType.operationMustContinue.rawValue:
                    if (!options.skipExitPage) {
                        MustContinueView(operationMustContinue: viewModel.uiState.operationMustContinue!, translator: viewModel.uiState.translator, operationInfo: viewModel.uiState.operationInfo!, returnToApp: {viewModel.uiState.returnToApp=true})
                        FooterComponent(translator: viewModel.uiState.translator, showFooter: viewModel.uiState.showFooter)
                    }
                case MessageType.geolocationRequest.rawValue:
                    LocationAccessRequestComponent(viewModel: viewModel)
                default:
                    ProgressComponent(currentProgress: viewModel.uiState.currentProgress)
                    EndToEndEncryptionView(translator: viewModel.uiState.translator)
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
        ).overlay(
            VStack {
                Spacer()
                if isConnected() && !viewModel.uiState.operationFinished {
                    ToastComponent(text: viewModel.uiState.translator.t("default.socket.disconnected"))
                        .padding()
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                }
            }
        )
        .animation(.default, value: isConnected())
        .environmentObject(themeManager)
        .task(priority: .userInitiated) {
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
                skipExitSuccessPage: options.skipExitSuccessPage,
                showFooter: options.showFooter,
                showMerchantLogo: options.showMerchantLogo,
                showPaymentDetails: options.showPaymentDetails,
                clientIP: await NetworkUtil.fetchPublicIP(ipv6: false, timeout: 2)
            )
            viewModel.connectClient()
            themeManager.selectedTheme.setColorSchemeAndCustomColors(colorScheme: colorScheme, colors: options.colors)
            viewModel.uiState.storedBankForms = storedBankForms.split(separator: "|")
                .map { String($0) }
        }
        .onChange(of: viewModel.uiState.returnToApp) { returnToApp in
            guard returnToApp else { return }
            if(returnToApp) {
                viewModel.disconnectClient()
                completitionHandler!(buildResult(viewModel.uiState))
                hostingControllerContainer.hostingController?.dismiss(animated: true)
            }
        }
    }

    func buildResult(_ state: KhipuUiState) -> KhipuResult {
        if (state.operationSuccess != nil) {

            return KhipuResult(
                operationId: cleanString(state.operationSuccess?.operationID),
                exitTitle: cleanString(state.operationSuccess?.title),
                exitMessage: cleanString(state.operationSuccess?.body),
                result: "OK",
                events: cleanEvents(state.operationSuccess?.events),
                exitUrl: cleanString(state.operationSuccess?.exitURL),
                failureReason: nil,
                continueUrl: nil
            )
        } else if (state.operationFailure != nil) {

            return KhipuResult(
                operationId: cleanString(state.operationFailure?.operationID),
                exitTitle: cleanString(state.operationFailure?.title),
                exitMessage: cleanString(state.operationFailure?.body),
                result: "ERROR",
                events: cleanEvents(state.operationFailure?.events),
                exitUrl: cleanString(state.operationFailure?.exitURL),
                failureReason: cleanString(state.operationFailure?.reason?.rawValue),
                continueUrl: nil
            )
        } else if (state.operationWarning != nil) {
            return KhipuResult(
                operationId: cleanString(state.operationWarning?.operationID),
                exitTitle: cleanString(state.operationWarning?.title),
                exitMessage: cleanString(state.operationWarning?.body),
                result: "WARNING",
                events: cleanEvents(state.operationWarning?.events),
                exitUrl: cleanString(state.operationWarning?.exitURL),
                failureReason: cleanString(state.operationWarning?.reason?.rawValue),
                continueUrl: nil
            )
        } else if (state.operationMustContinue != nil) {

            return KhipuResult(
                operationId: cleanString(state.operationMustContinue?.operationID),
                exitTitle: cleanString(state.operationMustContinue?.title),
                exitMessage: cleanString(state.operationMustContinue?.body),
                result: "CONTINUE",
                events: cleanEvents(state.operationMustContinue?.events),
                exitUrl: cleanString(state.operationMustContinue?.exitURL),
                failureReason: cleanString(state.operationMustContinue?.reason?.rawValue),
                continueUrl: cleanString(state.operationInfo?.urls?.info)
            )
        }

        // A terminal message we could not read. Must come after the four branches above, so
        // that a message which did deserialize still wins, and before the cancellation
        // fallback below, which would otherwise claim the payer cancelled.
        //
        // `failureReason` is nil rather than some code of our own: the protocol enum has no
        // value for "could not read the message", and nil states the only true thing — we do
        // not know why. Titles are empty instead of new translation keys, because inventing
        // copy for an internal failure is not this fix's job.
        if (state.unprocessableMessageType != nil) {
            return KhipuResult(
                operationId: cleanString(getOperationId(state)),
                exitTitle: "",
                exitMessage: "",
                result: "ERROR",
                events: [KhipuEvent](),
                exitUrl: "",
                failureReason: nil,
                continueUrl: nil
            )
        }

        return KhipuResult(
            operationId: cleanString(getOperationId(state)),
            exitTitle: cleanString(state.translator.t("page.operationFailure.operation.user.canceled.title", default: "")),
            exitMessage: cleanString(state.translator.t("page.operationFailure.operation.user.canceled.body", default: "")),
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


    func isConnected() -> Bool {
        return !viewModel.uiState.connectedSocket || !viewModel.uiState.connectedNetwork
    }
}

@available(iOS 15.0.0, *)
struct KhipuView_Previews: PreviewProvider {
    static var previews: some View {
        KhipuView(operationId: "rgq1gwc0rprl", options: KhipuOptions.Builder().build(), onComplete: nil, hostingControllerContainer: HostingControllerContainer())
    }
}
