import SwiftUI
import KhenshinProtocol


@available(iOS 15.0.0, *)
struct TimeoutMessageComponent: View {
    let operationFailure: OperationFailure
    @ObservedObject public var viewModel: KhenshinViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: Dimens.verySmall) {
            Text(viewModel.uiState.translator.t("page.timeout.session.closed"))
                .foregroundColor(Color(.label))
                .font(.title2)
                .multilineTextAlignment(.center)
            Spacer().frame(height: Dimens.extraSmall)
            FormWarning(text: viewModel.uiState.translator.t("page.timeout.try.again"))
            Spacer().frame(height: Dimens.extraLarge)
            
            
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: Dimens.huge))
                .foregroundColor(Color.gray.opacity(0.7))

            
            Text(viewModel.uiState.translator.t("page.timeout.end"))
                .foregroundColor(Color(.label))
                .font(.footnote)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: Dimens.extraLarge)

            Text(viewModel.uiState.translator.t("default.operation.code.label"))
                .foregroundColor(Color(.label))
                .font(.footnote)
                .multilineTextAlignment(.center)
            
            CopyToClipboardOperationId(text: operationFailure.operationID ?? "", textToCopy: FieldUtils.formatOperationId(operationId: operationFailure.operationID ?? ""), background:Color(red: 60/255, green: 180/255, blue: 229/255))
            
            Spacer()
            
            MainButton(
                text: viewModel.uiState.translator.t("page.redirectManual.redirecting"),
                enabled: true,
                onClick: {
                    viewModel.uiState.returnToApp = true
                }
            )
        }
        .padding(.all, Dimens.extraMedium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
