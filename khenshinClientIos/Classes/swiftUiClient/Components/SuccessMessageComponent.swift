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
            
            VStack(spacing: Dimens.moderatelyLarge) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: Dimens.extraLarge))
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
                    .padding(.horizontal, Dimens.extraMedium)
                    .padding(.vertical, Dimens.extraSmall)
                    .background(
                        Color(uiColor: .lightGray)
                            .opacity(0.3)
                            .cornerRadius(Dimens.extraSmall)
                    )
                
                Spacer()
                MainButton(
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

@available(iOS 15.0, *)
struct CustomColorPalette {
    static let success: Color = Color(uiColor: .systemGreen)
    static let onSuccess: Color = Color(uiColor: .white)
}
