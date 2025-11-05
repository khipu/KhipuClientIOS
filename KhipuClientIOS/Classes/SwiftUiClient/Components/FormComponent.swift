import Foundation
import SwiftUI
import KhenshinProtocol
import LocalAuthentication

@available(iOS 13.0, *)
class AlertManager: ObservableObject {
    @Published var showAlert = false
    func displayAlert() {
        showAlert = true
    }
    
    func dismissAlert() {
        showAlert = false
    }
}

@available(iOS 15.0.0, *)
public struct FormComponent: View {
    
    @StateObject private var alertManager = AlertManager()
    @State var countDown: Int = 300
    @State private var submittedForm: Bool = false
    @State private var formValues: [String: String] = [:]
    @State private var showTermsCheckbox: Bool = false
    public var formRequest: FormRequest
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    public var body: some View {
        ZStack {
            themeManager.selectedTheme.colors.background
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {
                
                VStack(alignment: .center, spacing: Dimens.large) {
                    let formTitle = formRequest.items.count == 1 && formRequest.items[0].email ?? false ?
                    viewModel.uiState.translator.t("form.email.subtitle") : viewModel.uiState.bank
                    if let iconName = getIconName(formRequest: formRequest), let subtitle = formRequest.title {
                        FormIconHeader(
                            iconName: iconName,
                            title: formTitle,
                            subtitle: subtitle
                        )
                    } else if let title = formRequest.title {
                        FormTitle(text: title)
                    }
                    
                    if formRequest.info != nil && !formRequest.info!.isEmpty {
                        FormInfo(text: formRequest.info!)
                    }
                    
                    ForEach(formRequest.items.indices, id: \.self) { index in
                        DrawComponent(
                            item: formRequest.items[index],
                            hasNextField: index < formRequest.items.count - 1,
                            formValues: $formValues,
                            submitFunction: submitForm,
                            viewModel: viewModel
                        )
                    }
                    
                    FormError(text: formRequest.errorMessage)
                    
                    RememberValues(
                        formRequest: formRequest,
                        viewModel: viewModel)
                    
                    if showTermsCheckbox && getShouldShowContinueButton(formRequest: formRequest) {
                        TermsCheckbox(
                            isAccepted: Binding(
                                get: { viewModel.uiState.termsAccepted },
                                set: { viewModel.uiState.termsAccepted = $0 }
                            ),
                            termsURL: viewModel.uiState.translator.t("default.terms.accept.link.url"),
                            translator: viewModel.uiState.translator
                        )
                    }
                    
                    if getShouldShowContinueButton(formRequest: formRequest) {
                        MainButton(text: getMainButtonText(formRequest: formRequest, khipuUiState: viewModel.uiState),
                                   enabled: validForm() && viewModel.uiState.termsAccepted,
                                   onClick: {
                            submittedForm = true
                            submitForm()
                        },
                                   foregroundColor: themeManager.selectedTheme.colors.onPrimary,
                                   backgroundColor: themeManager.selectedTheme.colors.primary
                        )
                    }
                    
                    SecurityMessage(translator: viewModel.uiState.translator)
                }
                .padding(.horizontal, Dimens.large)
                .padding(.vertical, Dimens.quiteLarge)
                .background(themeManager.selectedTheme.colors.surface)
                .cornerRadius(Dimens.CornerRadius.formContainer, corners: [.topLeft, .topRight])
                .onAppear {
                    startTimer()
                    if let progress = formRequest.progress,
                       let current = progress.current,
                       let total = progress.total {
                        viewModel.setCurrentProgress(currentProgress: Float(1*Float(current)/Float(total)))
                    }
                    showTermsCheckbox = !(viewModel.uiState.termsAccepted )
                }
                
            }
            
            InactivityModalView(isPresented: $alertManager.showAlert, onDismiss: {}, translator: viewModel.uiState.translator).environmentObject(themeManager)
                .preferredColorScheme(themeManager.selectedTheme.colors.colorScheme)
        }
    }
    
    func startTimer() {
        if formRequest.timeout != nil {
            countDown = formRequest.timeout!
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                countDown -= 1
                if countDown == 60 {
                    alertManager.showAlert = true
                }
            }
        }
    }
    
    private func getMainButtonText(formRequest: FormRequest, khipuUiState: KhipuUiState) -> String {
        if !(formRequest.continueLabel?.isEmpty ?? true) {
            return formRequest.continueLabel ?? ""
        }
        return khipuUiState.translator.t("default.continue.label")
    }
    
    private func validForm() -> Bool {
        return viewModel.uiState.validatedFormItems.isEmpty || viewModel.uiState.validatedFormItems.filter { !$0.value }.isEmpty
    }
    
    private func submitForm() -> Void {
        if validForm() {
            submitNovalidate(formRequest: formRequest, viewModel: viewModel)
        }
    }
    
    func submitNovalidate(formRequest: FormRequest, viewModel: KhipuViewModel) -> Void {
        let answers = formRequest.items.map {
            FormItemAnswer(
                id: $0.id,
                type: $0.type,
                value: formValues[$0.id] ?? ""
            )
        }
        let response = FormResponse(
            answers: answers,
            id: formRequest.id,
            type: MessageType.formResponse
        )
        do {
            try viewModel.khipuSocketIOClient?.sendMessage(type: response.type.rawValue, message: response.jsonString() ?? "")
        } catch {
            print("Error sending form")
        }
        if(self.formRequest.rememberValues ?? false && viewModel.uiState.storedBankForms.contains(viewModel.uiState.bank)) {
            let username = answers.first {$0.id == "username"}?.value ?? ""
            let password = answers.first {$0.id == "password"}?.value ?? ""
            let credentials = Credentials(username: username, password: password)
            try! CredentialsStorageUtil.storeCredentials(credentials: credentials, server: viewModel.uiState.bank)
        } else if(self.formRequest.rememberValues ?? false && !viewModel.uiState.storedBankForms.contains(viewModel.uiState.bank)) {
            try! CredentialsStorageUtil.deleteCredentials(server: viewModel.uiState.bank)
        }
    }
    
    private func getShouldShowContinueButton(formRequest: FormRequest) -> Bool {
        return !(formRequest.items.count == 1 && (formRequest.items.first?.type == FormItemTypes.groupedList || formRequest.items.first?.type == FormItemTypes.list))
    }
    
    private func getIconName(formRequest: FormRequest) -> String? {
        let hasId: (String) -> Bool = { id in
            formRequest.items.contains(where: { $0.id == id })
        }
        
        if hasId("username") { return "bank-login" }
        if hasId("account") { return "origin-account" }
        if hasId("password") || hasId("coordinates") { return "bank-authorization" }
        if hasId("email") { return "envelope-simple" }
        return nil
    }
    
    private func getSubtitle(formRequest: FormRequest) -> String {
        return viewModel.uiState.translator.t("form.subtitle.default")
    }
}

@available(iOS 15.0, *)
private struct RememberValues: View {
    public var formRequest: FormRequest
    @ObservedObject var viewModel: KhipuViewModel
    @State private var storedForm: Bool = false
    @AppStorage("storedBankCredentials") private var storedBankForms: String = ""
    @EnvironmentObject private var themeManager: ThemeManager
    
    public var body: some View {
        if formRequest.rememberValues ?? false {
            HStack(alignment: .center, spacing: 0) {
                Toggle(isOn: $storedForm) {
                    Text("Recordar credenciales")
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                        .tracking(0.15)
                }
                .toggleStyle(MaterialCheckboxToggleStyle())
                .onChange(of: storedForm, perform: { newValue in
                    if(newValue) {
                        if(!viewModel.uiState.storedBankForms.contains(viewModel.uiState.bank)) {
                            viewModel.uiState.storedBankForms.append(viewModel.uiState.bank)
                        }
                    } else {
                        viewModel.uiState.storedBankForms = viewModel.uiState.storedBankForms.filter { $0 != viewModel.uiState.bank }
                    }
                    storedBankForms = viewModel.uiState.storedBankForms.joined(separator: "|")
                    storedForm = newValue
                })
                .onAppear {
                    storedForm = viewModel.uiState.storedBankForms.contains(viewModel.uiState.bank)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

@available(iOS 15.0, *)
struct DrawComponent: View {
    
    var item: FormItem
    var hasNextField: Bool
    @Binding var formValues: [String: String]
    var submitFunction: () -> Void
    @ObservedObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    public var body: some View {
        let validationFun: (Bool) -> Void = { valid in
            viewModel.uiState.validatedFormItems[item.id] = valid
        }
        let getValueFun: (String) -> Void = { value in
            formValues[item.id] = value
        }
        switch item.type {
        case FormItemTypes.checkbox:
            CheckboxField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun,
                viewModel: viewModel
            )
        case FormItemTypes.coordinates:
            CoordinatesField(
                formItem: item,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.dataTable:
            DataTableField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.groupedList:
            GroupedListField(
                formItem: item,
                isValid: validationFun,
                returnValue: getValueFun,
                submitFunction: submitFunction,
                noResultsTitle: viewModel.uiState.translator.t("form.bank.no-results"),
                noResultsInfo: viewModel.uiState.translator.t("form.bank.try-another")
            )
        case FormItemTypes.headerCheckbox:
            HeaderCheckboxField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun,
                viewModel: viewModel
            )
        case FormItemTypes.imageChallenge:
            ImageChallengeField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun,
                viewModel: viewModel
            )
        case FormItemTypes.list:
            ListField(
                formItem: item,
                isValid: validationFun,
                returnValue: getValueFun,
                submitFunction: submitFunction
            )
        case FormItemTypes.otp:
            OtpField(
                formItem: item,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.rut:
            RutField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun,
                viewModel: viewModel
            )
        case FormItemTypes.separator:
            SeparatorField(formItem: item)
        case FormItemTypes.formItemTypesSWITCH:
            SwitchField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun,
                viewModel: viewModel
            )
        case FormItemTypes.text:
            SimpleTextField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun,
                viewModel: viewModel
            )
        }
    }
}

@available(iOS 15.0.0, *)
public struct FormComponent_Previews: PreviewProvider {
    static public var previews: some View {
        let request = MockDataGenerator.createFormRequest()
        let viewModel = KhipuViewModel()
        viewModel.uiState = KhipuUiState(currentForm: request)
        viewModel.uiState.translator = MockDataGenerator.createTranslator()
        return FormComponent(
            formRequest: request,
            viewModel: viewModel
        )
        .environmentObject(ThemeManager())
    }
}

@available(iOS 15.0, *)
struct RememberValues_Previews: PreviewProvider {
    static var previews: some View {
        
        return RememberValues(formRequest:MockDataGenerator.createFormRequest(), viewModel: KhipuViewModel())
            .environmentObject(ThemeManager())
            .padding()
    }
}

@available(iOS 15.0, *)
struct DrawComponent_Previews: PreviewProvider {
    static var previews: some View {
        let submitFunction: () -> Void = {}
        let getFunction: () -> [String: String] = { ["key":"value"]}
        let setFunction: ([String: String]) -> Void = { param in }
        
        return VStack {
            Text("DataTable:").underline().padding()
            DrawComponent(
                item: MockDataGenerator.createDataTableFormItem(
                    id: "item1",
                    label: "item1",
                    dataTable: DataTable(
                        rows: [
                            DataTableRow(cells: [
                                DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil)
                            ])
                        ],
                        rowSeparator: nil
                    )
                ),
                hasNextField: false,
                formValues: Binding(get: getFunction, set: setFunction),
                submitFunction: submitFunction,
                viewModel: KhipuViewModel())
            .environmentObject(ThemeManager())
            .padding()
            Text("OTP:").underline().padding()
            DrawComponent(
                item: MockDataGenerator.createOtpFormItem(),
                hasNextField: false,
                formValues: Binding(get: getFunction, set: setFunction),
                submitFunction: submitFunction,
                viewModel: KhipuViewModel())
            .environmentObject(ThemeManager())
            .padding()
        }
    }
}

@available(iOS 13.0, *)
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

@available(iOS 13.0, *)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
