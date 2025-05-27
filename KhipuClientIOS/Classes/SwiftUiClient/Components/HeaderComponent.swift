
import Foundation
import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct HeaderComponent: View {
    var showMerchantLogo: Bool
    var showPaymentDetails: Bool
    var operationInfo: OperationInfo?
    var translator: KhipuTranslator
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showMerchantDialog = false
    
    var body: some View {
        if (operationInfo?.merchant?.name) != nil {
            VStack(spacing: 0) {
                headerContent
                Spacer().frame(height:Dimens.Spacing.extraSmall)
                if showPaymentDetails {
                    Divider()
                    Spacer().frame(height:Dimens.Spacing.extraSmall)
                    footerContent
                    Spacer().frame(height: Dimens.Spacing.extraSmall)
                    Divider()
                }
            }
            .sheet(isPresented: $showMerchantDialog) {
                MerchantDialogComponent(
                    onDismissRequest: { showMerchantDialog = false },
                    translator: translator,
                    merchant: (operationInfo?.merchant?.name)!,
                    subject: (operationInfo?.subject)! ,
                    description:(operationInfo?.body)!,
                    amount: (operationInfo?.amount)!,
                    image: (operationInfo?.urls?.image)!
                ).environmentObject(themeManager)
                    .preferredColorScheme(themeManager.selectedTheme.colors.colorScheme)
                
            }
        } else {
            SkeletonHeaderComponent()
        }
    }
    
    private var headerContent: some View {
        HStack() {
            if showMerchantLogo, let logoURLString = operationInfo?.merchant?.logo, let logoURL = URL(string: logoURLString), UIApplication.shared.canOpenURL(logoURL) {
                AsyncImage(url: logoURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: Dimens.Frame.slightlyLarger, height: Dimens.Frame.slightlyLarger)
                        .clipShape(RoundedRectangle(cornerRadius: Dimens.CornerRadius.verySmall))
                } placeholder: {
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading, spacing:Dimens.Spacing.verySmall) {
                Text(operationInfo?.merchant?.name ?? "")
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                
                Text(operationInfo?.subject ?? "")
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing:Dimens.Spacing.verySmall) {
                Text(translator.t("header.amount", default: "").uppercased())
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 10))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                
                Text(operationInfo?.amount ?? "")
                    .font(themeManager.selectedTheme.fonts.font(style: .bold, size: 20))
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
            }
        }.padding(.horizontal,Dimens.Spacing.large)
            .padding(.vertical,Dimens.Padding.veryMedium)
    }
    
    private var footerContent: some View {
        HStack {
            formattedCode()
                .font(themeManager.selectedTheme.fonts.font(style: .medium, size:10))
            
            Spacer()
            
            Button(action: { showMerchantDialog = true }) {
                Text(translator.t("header.details.show",default: ""))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                    .foregroundColor(themeManager.selectedTheme.colors.secondary)
                    .bold()
            }
            
        }.padding(.horizontal,Dimens.Padding.large)
        
    }
    private func formattedCode() -> Text {
        var text = Text("")
        text = text + Text(translator.t("header.code.label", default: "").uppercased()).foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
        text = text + Text(" • \(FieldUtils.formatOperationId(operationId:operationInfo?.operationID ?? ""))").foregroundColor(themeManager.selectedTheme.colors.operationIdText)
        
        return text
    }
}


@available(iOS 15.0.0, *)
struct HeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        return VStack{
            Text("Skeleton:")
            HeaderComponent(showMerchantLogo: false, showPaymentDetails: false,
                            translator: MockDataGenerator.createTranslator())
            .environmentObject(ThemeManager())
            .padding()
            Text("Loaded:")
            HeaderComponent(showMerchantLogo: false, showPaymentDetails: false,operationInfo: MockDataGenerator.createOperationInfo(merchantLogo: "logo",merchantName: "Merchant",operationID: "asdqqwerqwer"),translator: MockDataGenerator.createTranslator())
                .environmentObject(ThemeManager())
                .padding()
        }
    }
}

