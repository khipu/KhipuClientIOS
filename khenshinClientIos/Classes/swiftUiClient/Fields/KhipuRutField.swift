//
//  TextField.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 09-05-24.
//

import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct KhipuRutField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @State var passwordVisible: Bool = false
    @State var rutValue: String = ""
    @State var error: String = ""
    @State var lastModificationTime: TimeInterval = 0
    @ObservedObject var viewModel: KhenshinViewModel
    @State var currentTime: TimeInterval = Date().timeIntervalSince1970
    
    var body: some View {
        VStack(alignment: .leading, spacing:0) {
            Text(formItem.label ?? "")
                .font(.subheadline)
                .padding(.horizontal, 16)
            HStack {
                TextField(formItem.label ?? "", text: $rutValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 0)
            .onChange(of: rutValue) { newValue in
                onChange(newValue: newValue)
            }
            
            if !(formItem.hint?.isEmpty ?? true) {
                Text(formItem.hint ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            if shouldDisplayError() {
                HStack {
                    Spacer()
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .onAppear {
            startTimer()
        }
    }
    
    func shouldDisplayError() -> Bool {
        return !error.isEmpty && (currentTime - lastModificationTime > 1)
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            currentTime = Date().timeIntervalSince1970
        }
    }
    
    private func onChange(newValue: String) {
        rutValue = newValue
        error = validateRutField(value: newValue, formItem: formItem)
        isValid(error.isEmpty)
        returnValue(newValue)
        lastModificationTime = Date().timeIntervalSince1970
    }
    
    private func validateRutField(value: String, formItem: FormItem) -> String {
        if value.isEmpty {
            return viewModel.uiState.translator.t("form.validation.error.rut.nullable")
        }
        if (!ValidationUtils.isValidRut(value)){
            return viewModel.uiState.translator.t("form.validation.error.rut.invalid")
        }
        return ""
    }
}
