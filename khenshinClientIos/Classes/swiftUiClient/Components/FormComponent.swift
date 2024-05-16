//
//  FormComponent.swift
//  APNGKit
//
//  Created by Mauricio Castillo on 08-05-24.
//

import Foundation

import SwiftUI
import KhenshinProtocol


@available(iOS 15.0.0, *)
public struct FormComponent: View {
    
    @State private var submittedForm: Bool = false
    @State private var formValues: [String: String] = [:]
    public var formRequest: FormRequest
    @ObservedObject public var viewModel: KhenshinViewModel
    
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
                    khenshinViewModel: viewModel,
                    item: formRequest.items[index],
                    hasNextField: index < formRequest.items.count - 1,
                    formValues: $formValues,
                    submitFunction: submitForm,
                    viewModel: viewModel
                )
            }
            if(getShouldShowContinueButton(formRequest: formRequest)) {
                MainButton(text: getMainButtonText(formRequest: formRequest, khenshinUiState: viewModel.uiState),
                           enabled: validForm(),
                           onClick: {
                                submittedForm = true
                                submitForm()
                            }
                )
            }
        }
        .padding([.leading, .trailing], 20)
    }
    
    private func getMainButtonText(formRequest: FormRequest, khenshinUiState: KhenshinUiState) -> String {
        if formRequest.continueLabel == nil || formRequest.continueLabel?.isEmpty ?? true {
            return khenshinUiState.translator.t("default.continue.label")
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
    
    func submitNovalidate(formRequest: FormRequest, viewModel: KhenshinViewModel) -> Void {
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
            try viewModel.khenshinSocketClient?.sendMessage(type: response.type.rawValue, message: response.jsonString() ?? "")
        } catch {
            print("Error sending form")
        }
    }
    
    private func getShouldShowContinueButton(formRequest: FormRequest) -> Bool {
        return !(formRequest.items.count == 1 && (formRequest.items.first?.type == FormItemTypes.groupedList || formRequest.items.first?.type == FormItemTypes.list))
    }
    
}

@available(iOS 15.0, *)
struct DrawComponent: View {
    
    var khenshinViewModel: KhenshinViewModel
    var item: FormItem
    var hasNextField: Bool
    @Binding var formValues: [String: String]
    var submitFunction: () -> Void
    @ObservedObject var viewModel: KhenshinViewModel
    
    public var body: some View {
        let validationFun: (Bool) -> Void = { valid in
            khenshinViewModel.uiState.validatedFormItems[item.id] = valid
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


