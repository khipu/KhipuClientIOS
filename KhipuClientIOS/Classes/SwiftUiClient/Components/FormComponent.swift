//
//  FormComponent.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 08-05-24.
//

import Foundation

import SwiftUI
import KhenshinProtocol
import LocalAuthentication


@available(iOS 15.0.0, *)
public struct FormComponent: View {
    
    @State private var submittedForm: Bool = false
    @State private var formValues: [String: String] = [:]
    @AppStorage("storedCredentials") private var storedForm: Bool = false
    public var formRequest: FormRequest
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    public var body: some View {
        VStack {
            FormTitle(text: formRequest.title!)
            if(!viewModel.uiState.bank.isEmpty) {
                FormPill(text: viewModel.uiState.bank)
            }
            if(formRequest.info != nil && !formRequest.info!.isEmpty) {
                FormInfo(text: formRequest.info!)
            }
            ForEach(formRequest.items.indices, id: \.self) { index in
                DrawComponent(
                    item: formRequest.items[index],
                    hasNextField: index < formRequest.items.count - 1,
                    formValues: $formValues,
                    submitFunction: submitForm,
                    viewModel: viewModel,
                    storedForm: $storedForm
                )
            }
            RememberValues(
                formRequest: formRequest,
                storedForm: $storedForm,
                viewModel: viewModel)
            if(getShouldShowContinueButton(formRequest: formRequest)) {
                MainButton(text: getMainButtonText(formRequest: formRequest, khipuUiState: viewModel.uiState),
                           enabled: validForm(),
                           onClick: {
                    submittedForm = true
                    submitForm()
                },
                           foregroundColor: themeManager.selectedTheme.colors.onPrimary,
                           backgroundColor: themeManager.selectedTheme.colors.primary
                )
            }
        }
        .padding(.all, themeManager.selectedTheme.dimens.extraMedium)
        .onAppear {
            if let progress = viewModel.uiState.currentForm!.progress,
               let current = progress.current,
               let total = progress.total {
                
                let currentProgress = Float(current) / Float(total)
                viewModel.setCurrentProgress(currentProgress: currentProgress)
                viewModel.uiState.storedForm = storedForm
            }
        }
    }
    
    private func getMainButtonText(formRequest: FormRequest, khipuUiState: KhipuUiState) -> String {
        if formRequest.continueLabel == nil || formRequest.continueLabel?.isEmpty ?? true {
            return khipuUiState.translator.t("default.continue.label")
        } else {
            return formRequest.continueLabel ?? ""
        }
    }
    
    private func validForm() -> Bool {
        return viewModel.uiState.validatedFormItems.isEmpty || viewModel.uiState.validatedFormItems.filter { !$0.value }.isEmpty
    }
    
    private func submitForm() -> Void {
        if(validForm()) {
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
        if(self.formRequest.rememberValues ?? false && storedForm) {
            let credentials = Credentials(username: answers[0].value, password: answers[1].value)
            try! CredentialsStorageUtil.storeCredentials(credentials: credentials, server: viewModel.uiState.bank)
        } else if(self.formRequest.rememberValues ?? false && !storedForm) {
            try! CredentialsStorageUtil.deleteCredentials(server: viewModel.uiState.bank)
        }
    }
    
    private func getShouldShowContinueButton(formRequest: FormRequest) -> Bool {
        return !(formRequest.items.count == 1 && (formRequest.items.first?.type == FormItemTypes.groupedList || formRequest.items.first?.type == FormItemTypes.list))
    }
    
    
}

@available(iOS 15.0, *)
private struct RememberValues: View {
    public var formRequest: FormRequest
    @Binding var storedForm: Bool
    @ObservedObject var viewModel: KhipuViewModel
    
    public var body: some View {
        if(formRequest.rememberValues ?? false) {
            Toggle(isOn: $storedForm) {
                Text("Recordar credenciales")
            }
            .toggleStyle(iOSCheckboxToggleStyle())
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
    @Binding var storedForm: Bool
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
            KhipuCheckboxField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.coordinates:
            KhipuCoordinatesField(
                formItem: item,
                isValid: validationFun,
                returnValue: getValueFun,
                submitFunction: submitFunction
            )
        case FormItemTypes.dataTable:
            KhipuDataTableField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.groupedList:
            KhipuGroupedListField(
                formItem: item,
                isValid: validationFun,
                returnValue: getValueFun,
                submitFunction: submitFunction
            )
        case FormItemTypes.headerCheckbox:
            KhipuHeaderCheckboxField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.imageChallenge:
            KhipuImageChallengeField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.list:
            KhipuListField(
                formItem: item,
                isValid: validationFun,
                returnValue: getValueFun,
                submitFunction: submitFunction
            )
        case FormItemTypes.otp:
            KhipuOtpField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.rut:
            KhipuRutField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun,
                viewModel: viewModel
            )
        case FormItemTypes.separator:
            KhipuSeparatorField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.formItemTypesSWITCH:
            KhipuSwitchField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun
            )
        case FormItemTypes.text:
            KhipuTextField(
                formItem: item,
                hasNextField: hasNextField,
                isValid: validationFun,
                returnValue: getValueFun,
                viewModel: viewModel
            )
        }
    }    
}


