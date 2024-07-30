import SwiftUI

@available(iOS 15.0.0, *)
struct MerchantDialogComponent: View {
    var onDismissRequest: () -> Void
    var translator: KhipuTranslator
    var merchant: String?
    var subject: String
    var description: String
    var amount: String
    var image: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: onDismissRequest) {
                            Image(systemName: "xmark")
                                .padding()
                        }
                    }
                    .padding(.trailing, Dimens.Padding.medium)
                    .padding(.top, Dimens.Padding.medium)
                    
                    VStack(alignment: .center, spacing: Dimens.Spacing.large) {
                        Text(translator.t("modal.merchant.info.title"))
                            .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 20))
                            .padding(.top, Dimens.Padding.medium)
                        
                        if let merchant = merchant,!merchant.isEmpty {
                            InfoView(title: translator.t("modal.merchant.info.destinatary.label"), value: merchant)
                            InfoView(title: translator.t("modal.merchant.info.subject.label"), value: subject)
                        }

                        if let imageUrl = image, let url = URL(string: imageUrl) {
                            VStack(alignment: .leading, spacing: 0) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty, .failure:
                                        EmptyView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: Dimens.Image.huge, height: Dimens.Image.huge)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, Dimens.Padding.extraMedium)
                                .padding(.vertical, Dimens.Padding.medium)
                            }
                        }
                        
                        
                        if !description.isEmpty {
                            InfoView(title: translator.t("modal.merchant.info.description.label"), value: description)
                        }
                        
                        InfoView(title: translator.t("modal.merchant.info.amount.label"), value: amount)
                        
                        MainButton(
                            text: translator.t("modal.merchant.info.close.button"),
                            enabled: true,
                            onClick: onDismissRequest,
                            foregroundColor: themeManager.selectedTheme.colors.onPrimary,
                            backgroundColor: themeManager.selectedTheme.colors.primary
                        )
                    }
                    .padding(.horizontal, Dimens.Padding.large)
                    .padding(.bottom, Dimens.Padding.quiteLarge)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(Dimens.CornerRadius.medium)
                .shadow(radius: Dimens.Padding.medium)
                Spacer()
            }
        }
    }
}

@available(iOS 15.0.0, *)
struct InfoView: View {
    let title: String
    let value: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(themeManager.selectedTheme.fonts.font(style: .bold, size: 14))
                .foregroundStyle(themeManager.selectedTheme.colors.onSurface)
            Text(value)
                .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 14))
                .foregroundStyle(themeManager.selectedTheme.colors.onSurface)
        }
        .padding(.horizontal, Dimens.Padding.extraMedium)
        .padding(.vertical, Dimens.Padding.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 15.0.0, *)
struct MerchantDialogComponent_Previews: PreviewProvider {
    static var previews: some View {
        let onDismissRequest: () -> Void = {}
        return MerchantDialogComponent(
            onDismissRequest: onDismissRequest,
            translator: MockDataGenerator.createTranslator(),
            merchant: "Merchant",
            subject: "Subject",
            description: "Description",
            amount: "$ 1.000",
            image: ""
        ).padding()
            .environmentObject(ThemeManager())
    }
}


@available(iOS 15.0.0, *)
struct MerchantDialogComponentCMR_Previews: PreviewProvider {
    static var previews: some View {
        let onDismissRequest: () -> Void = {}
        return MerchantDialogComponent(
            onDismissRequest: onDismissRequest,
            translator: MockDataGenerator.createTranslator(),
            merchant: "",
            subject: "Subject",
            description: "Description",
            amount: "$ 1.000",
            image: ""
        ).padding()
            .environmentObject(ThemeManager())
    }
}
