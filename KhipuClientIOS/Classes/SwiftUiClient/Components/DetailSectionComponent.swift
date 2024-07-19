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
        VStack(alignment: .center, spacing:Dimens.Spacing.large) {
            
            DetailItem(label:params.amountLabel, value: params.amountValue)
            DetailItem(label:params.merchantNameLabel, value: params.merchantNameValue)
            DashedLine()
            DetailItem(label:params.codOperacionLabel, value:[FieldUtils.formatOperationId(operationId:operationId),FieldUtils.getFailureReasonCode(reason:reason)].joined(separator: " "),shouldCopyValue: true)
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
            Spacer()
            if !shouldCopyValue {
                Text(value)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                
            } else {
                CopyToClipboardOperationId(text: value, textToCopy: FieldUtils.formatOperationId(operationId:value), background:themeManager.selectedTheme.colors.onSecondaryContainer)
            }
        }
        .padding(.vertical,Dimens.Padding.verySmall)
    }
}

/*
 @available(iOS 15.0, *)
 struct DetailSection_Previews:PreviewProvider{
 static var previews: some View{
 return DetailSectionComponent(reason: FieldUtils.getFailureReasonCode(reason: FailureReasonType.formTimeout), operationId: "operationID", viewModel: KhipuViewModel())
 .environmentObject(ThemeManager())
 .padding()
 }
 }
 */

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
