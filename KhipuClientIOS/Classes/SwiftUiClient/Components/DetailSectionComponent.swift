import SwiftUI
import KhenshinProtocol
import SwiftUI


struct DetailSectionParams {
    let amountLabel: String
    let amountValue: String
    let merchantNameLabel: String
    let merchantNameValue: String
    let codOperacionLabel: String
}

@available(iOS 15.0.0, *)
struct DetailSectionComponent: View {
    var operationId: String
    var reason: FailureReasonType?
    var params: DetailSectionParams
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Dimens.Spacing.large) {
            DetailItem(label: params.amountLabel, value: params.amountValue)
            DetailItem(label: params.merchantNameLabel, value: params.merchantNameValue)
            DashedLine()
            DetailItem(label: params.codOperacionLabel, value: [FieldUtils.formatOperationId(operationId: operationId), FieldUtils.getFailureReasonCode(reason: reason)].joined(separator: " "), shouldCopyValue: true)
        }
        .padding(Dimens.Padding.large)
        .frame(maxWidth: .infinity, alignment: .top)
        .cornerRadius(Dimens.CornerRadius.moderatelySmall)
    }
}

@available(iOS 15.0.0, *)
struct DetailItem: View {
    var label: String
    var value: String
    var shouldCopyValue: Bool = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(label)
                .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                .frame(minWidth: Dimens.Frame.veryHuge, maxWidth: Dimens.Frame.veryHuge, alignment: .topLeading)
            VStack(alignment: .leading) {
                if !shouldCopyValue {
                    Text(value)
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                        .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                        .frame(maxWidth: .infinity, minHeight: Dimens.Frame.large, maxHeight: Dimens.Frame.large, alignment: .topLeading)
                } else {
                    CopyToClipboardOperationId(text: value, textToCopy: FieldUtils.formatOperationId(operationId:value), background:themeManager.selectedTheme.colors.onSecondaryContainer)
                        .frame(maxWidth: .infinity, minHeight: Dimens.Frame.large, maxHeight: Dimens.Frame.large, alignment: .topLeading)
                }
            }
            Spacer()
        }
        .padding(.vertical, Dimens.Padding.verySmall)
    }
}

@available(iOS 15.0, *)
struct DetailSection_Previews:PreviewProvider{
    static var previews: some View{
        let detailSectionParams = DetailSectionParams(amountLabel: "Monto", amountValue: "$", merchantNameLabel: "Destinatario", merchantNameValue: "Merchant", codOperacionLabel: "Cod. Operación")
        
        return DetailSectionComponent(operationId: "operationID", reason: FailureReasonType.formTimeout, params: detailSectionParams)
            .environmentObject(ThemeManager())
            .padding()
    }
}

@available(iOS 15.0, *)
struct DetailItem_Previews:PreviewProvider{
    static var previews: some View{
        return DetailItem(
            label: "Label",
            value: "Value",
            shouldCopyValue: true
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
