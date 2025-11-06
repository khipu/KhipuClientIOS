
import Foundation
import SwiftUI
import KhenshinProtocol

@available(iOS 15.0.0, *)
struct HeaderComponent: View {
    var showMerchantLogo: Bool
    var showPaymentDetails: Bool
    var operationInfo: OperationInfo?
    var translator: KhipuTranslator
    var currentProgress: Float
    var onClose: (() -> Void)? = nil
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showMerchantDialog = false

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ProgressComponent(currentProgress: currentProgress)
            if (operationInfo?.merchant?.name) != nil {
                headerContent
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
    }

    private var topBar: some View {
        HStack(alignment: .center, spacing: Dimens.slightlyLarger) {
            if let logoImage = KhipuClientBundleHelper.image(named: "logo-khipu-color") {
                Image(uiImage: logoImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Dimens.Image.khipuLogoWidth, height: Dimens.Image.khipuLogoHeight)
            }

            Spacer()
        }
        .padding(.horizontal, Dimens.large)
        .padding(.vertical, Dimens.medium)
        .background(themeManager.selectedTheme.colors.surface)
    }
    
    private var headerContent: some View {
        HStack(alignment: .center, spacing: Dimens.Spacing.headerContent) {
            if showMerchantLogo, let logoURLString = operationInfo?.merchant?.logo, let logoURL = URL(string: logoURLString), UIApplication.shared.canOpenURL(logoURL) {
                AsyncImage(url: logoURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Dimens.Image.merchantLogo, height: Dimens.Image.merchantLogo)
                        .clipShape(RoundedRectangle(cornerRadius: Dimens.CornerRadius.moderatelySmall))
                        .overlay(
                            RoundedRectangle(cornerRadius: Dimens.CornerRadius.moderatelySmall)
                                .stroke(themeManager.selectedTheme.colors.surface, lineWidth: 1)
                        )
                } placeholder: {
                    RoundedRectangle(cornerRadius: Dimens.CornerRadius.moderatelySmall)
                        .fill(themeManager.selectedTheme.colors.disabled)
                        .frame(width: Dimens.Image.merchantLogo, height: Dimens.Image.merchantLogo)
                }
            }

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(operationInfo?.merchant?.name ?? "")
                            .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                            .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                            .tracking(0.15)
                            .lineSpacing(6)
                            .lineLimit(1)

                        Text(operationInfo?.subject ?? "")
                            .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 14))
                            .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                            .tracking(0.15)
                            .lineSpacing(6)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 0) {
                        Text(operationInfo?.amount ?? "")
                            .font(themeManager.selectedTheme.fonts.font(style: .bold, size: 18))
                            .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                            .lineSpacing(12)

                        if showPaymentDetails {
                            Button(action: { showMerchantDialog = true }) {
                                Text(translator.t("header.details.show").uppercased())
                                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 13))
                                    .foregroundColor(themeManager.selectedTheme.colors.info)
                                    .tracking(0.46)
                                    .lineSpacing(9)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, Dimens.large)
        .padding(.vertical, Dimens.veryMedium)
    }
}


@available(iOS 15.0.0, *)
struct HeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        let themeManager = ThemeManager()
        return VStack(spacing: 20) {
            Text("Skeleton:")
            HeaderComponent(
                showMerchantLogo: false,
                showPaymentDetails: false,
                translator: MockDataGenerator.createTranslator(),
                currentProgress: 0.5, onClose: { print("Close tapped") }
            )
            .environmentObject(themeManager)

            Text("With Logo & Details:")
            HeaderComponent(
                showMerchantLogo: true,
                showPaymentDetails: true,
                operationInfo: MockDataGenerator.createOperationInfo(
                    merchantLogo: "logo",
                    merchantName: "CMR Falabella",
                    operationID: "asdqqwerqwer"
                ),
                translator: MockDataGenerator.createTranslator(),
                currentProgress: 0.5,
                onClose: { print("Close tapped") }
            )
            .environmentObject(themeManager)
            .background(themeManager.selectedTheme.colors.background)

            Text("Without Details Button:")
            HeaderComponent(
                showMerchantLogo: true,
                showPaymentDetails: false,
                operationInfo: MockDataGenerator.createOperationInfo(
                    merchantLogo: "logo",
                    merchantName: "CMR Falabella",
                    operationID: "asdqqwerqwer"
                ),
                translator: MockDataGenerator.createTranslator(),
                currentProgress: 0.5,
                onClose: { print("Close tapped") }
            )
            .environmentObject(themeManager)
            .background(themeManager.selectedTheme.colors.background)
        }
        .padding()
    }
}

