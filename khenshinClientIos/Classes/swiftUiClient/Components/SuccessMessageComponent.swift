//
//  SuccessMessageComponent.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 15-05-24.
//

import SwiftUI
import KhenshinProtocol

@available(iOS 15.0, *)
struct SuccessMessageComponent: View {
    let operationSuccess: OperationSuccess
    @StateObject private var khenshinViewModel = KhenshinViewModel()
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: Dimensions.large) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: Dimensions.extraLarge))
                    .foregroundColor(CustomColorPalette.success)
                
                Text(operationSuccess.title ?? "")
                    .font(.title2)
                    .foregroundColor(Color(uiColor: .label))
                
                Text(operationSuccess.body ?? "")
                    .font(.body)
                    .foregroundColor(Color(uiColor: .label))
                    .multilineTextAlignment(.center)
                
                Text(khenshinViewModel.uiState.translator.t("default.operation.code.label"))
                    .font(.footnote)
                    .foregroundColor(Color(uiColor: .label))
                
                Text(formatOperationId(operationSuccess.operationID ?? ""))
                    .font(.body)
                    .foregroundColor(Color(uiColor: .systemBlue))
                    .padding(.horizontal, Dimensions.medium)
                    .padding(.vertical, Dimensions.small)
                    .background(
                        Color(uiColor: .lightGray)
                            .opacity(0.3)
                            .cornerRadius(Dimensions.small)
                    )
                
                Spacer()
                MainButton(
                    //colors: ButtonColors(
                    //    containerColor: CustomColorPalette.success,
                    //    contentColor: CustomColorPalette.onSuccess
                    //),
                    text: khenshinViewModel.uiState.translator.t("default.end.and.go.back"),
                    enabled: true,
                    onClick: {
                        khenshinViewModel.uiState.returnToApp = true
                    }
                )
            }
        }
    }
}

struct Dimensions {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 48
    static let veryLarge: CGFloat = 64
}

@available(iOS 15.0, *)
struct CustomColorPalette {
    static let success: Color = Color(uiColor: .systemGreen)
    static let onSuccess: Color = Color(uiColor: .white)
}
//
//struct ButtonColors {
//    let containerColor: Color
//    let contentColor: Color
//}
//
//struct MainButton: View {
//    let colors: ButtonColors
//    let onClick: () -> Void
//    let isEnabled: Bool
//    let text: String
//
//    var body: some View {
//        Button(action: onClick) {
//            Text(text)
//                .font(.body)
//                .foregroundColor(colors.contentColor)
//                .padding(.vertical, Dimensions.small)
//                .padding(.horizontal, Dimensions.medium)
//        }
//        .background(colors.containerColor)
//        .cornerRadius(Dimensions.small)
//        .disabled(!isEnabled)
//    }
//}

//struct SuccessMessageComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        SuccessMessageComponent()
//    }
//}
