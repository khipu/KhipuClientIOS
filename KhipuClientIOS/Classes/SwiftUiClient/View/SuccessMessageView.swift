import SwiftUI
import KhenshinProtocol

@available(iOS 16.0, *)
struct SuccessMessageView: View {
    let operationSuccess: OperationSuccess
    var translator: KhipuTranslator
    var operationInfo: OperationInfo?
    var returnToApp: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var secondsRemaining = 9
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            TopBarComponent(onClose: returnToApp)
                .environmentObject(themeManager)
            
            VStack(alignment: .center, spacing: Dimens.Spacing.verySmall) {
                Text(translator.t("page.operationComplete.header.title"))
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 20))
                    .foregroundColor(themeManager.selectedTheme.colors.success)
            }
            .padding(.vertical, Dimens.Padding.medium)
            .frame(maxWidth: .infinity, minHeight: Dimens.huge, alignment: .center)
            
            VStack(alignment: .center, spacing: Dimens.Spacing.quiteLarge) {
                ZStack {
                    RoundedRectangle(cornerRadius: Dimens.CornerRadius.medium)
                        .fill(themeManager.selectedTheme.colors.successBackground)
                        .frame(width: Dimens.Frame.checkmarkContainer, height: Dimens.Frame.checkmarkContainer)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Dimens.Frame.quiteLarge, height: Dimens.Frame.quiteLarge)
                        .foregroundColor(themeManager.selectedTheme.colors.success)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, Dimens.Padding.large)
                
                VStack(alignment: .center, spacing: Dimens.Spacing.veryMedium) {
                    Text(operationSuccess.title ?? "Transferencia completada")
                        .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                        .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                        .frame(maxWidth: .infinity)
                    
                    Text(translator.t("page.operationComplete.subtitle"))
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                    
                    Text(operationSuccess.body ?? "")
                        .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                        .foregroundColor(themeManager.selectedTheme.colors.onBackground)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, Dimens.Padding.large)
                .frame(maxWidth: .infinity)
                
                DashedLine()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, Dimens.Padding.large)
                
                VStack(alignment: .center, spacing: Dimens.Spacing.moderatelyMedium) {
                    if let operationInfo = operationInfo {
                        // Monto transferido
                        VStack(spacing: Dimens.Spacing.verySmall) {
                            Text(translator.t("default.sent.amount.label"))
                                .textCase(.uppercase)
                                .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 12))
                                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                                .tracking(1)
                                .frame(maxWidth: .infinity)
                            
                            Text(operationInfo.amount ?? "")
                                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Fecha transacción
                        VStack(spacing: Dimens.Spacing.verySmall) {
                            Text(translator.t("default.date.label"))
                                .textCase(.uppercase)
                                .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 12))
                                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                                .tracking(1)
                                .frame(maxWidth: .infinity)
                            
                            Text(getCurrentFormattedDate())
                                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Emisor cobro
                        if let merchant = operationInfo.merchant, let merchantName = merchant.name, !merchantName.isEmpty {
                            VStack(spacing: Dimens.Spacing.verySmall) {
                                Text(translator.t("default.destinatary.label"))
                                    .textCase(.uppercase)
                                    .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 12))
                                    .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                                    .tracking(1)
                                    .frame(maxWidth: .infinity)
                                
                                Text(merchantName)
                                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Servicio ofrecido por
                        VStack(spacing: Dimens.Spacing.verySmall) {
                            Text("SERVICIO OFRECIDO POR")
                                .textCase(.uppercase)
                                .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 12))
                                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                                .tracking(1)
                                .frame(maxWidth: .infinity)
                            
                            Text("Khipu")
                                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                                .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Código operación
                    VStack(spacing: Dimens.Spacing.medium) {
                        Text(translator.t("default.operation.code.label"))
                            .textCase(.uppercase)
                            .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 12))
                            .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                            .tracking(1)
                            .frame(maxWidth: .infinity)
                        
                        // Botón con fondo azul claro
                        Button(action: {
                            UIPasteboard.general.string = FieldUtils.formatOperationId(operationId: operationSuccess.operationID ?? "")
                        }) {
                            HStack(spacing: Dimens.Spacing.verySmall) {
                                Text(FieldUtils.formatOperationId(operationId: operationSuccess.operationID ?? ""))
                                    .textCase(.uppercase)
                                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                                    .foregroundColor(themeManager.selectedTheme.colors.infoDark)
                                    .tracking(0.4)
                                
                                Image(systemName: "doc.on.doc.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: Dimens.Image.veryMedium, height: Dimens.Image.veryMedium)
                                    .foregroundColor(themeManager.selectedTheme.colors.info)
                            }
                            .padding(.horizontal, Dimens.Padding.medium)
                            .padding(.vertical, Dimens.Padding.verySmall)
                            .background(themeManager.selectedTheme.colors.infoBackground)
                            .cornerRadius(Dimens.CornerRadius.extraSmall)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Dimens.Padding.large)
                
                // Botón y mensaje de redirección
                VStack(spacing: Dimens.Spacing.large) {
                    MainButton(
                        text: translator.t("default.back.to.origin.site"),
                        enabled: true,
                        onClick: returnToApp,
                        foregroundColor: themeManager.selectedTheme.colors.onPrimary,
                        backgroundColor: themeManager.selectedTheme.colors.primary
                    )
                    
                    Text(translator.t("default.redirect.n.seconds").replacing("{{time}}", with: String(secondsRemaining)))
                        .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 14))
                        .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                        .tracking(0.1)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Dimens.Padding.large)
            }
            .padding(.vertical, Dimens.Padding.quiteLarge)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(themeManager.selectedTheme.colors.background)
            .cornerRadius(Dimens.CornerRadius.contentContainer, corners: [.topLeft, .topRight])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(themeManager.selectedTheme.colors.scaffoldBackground)
        .onAppear {
            startCountdown()
        }
    }
    
    private func getCurrentFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy - HH:mm'hrs'"
        return formatter.string(from: Date())
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timer.invalidate()
                returnToApp()
            }
        }
    }
}

@available(iOS 16.0, *)
struct SuccessMessageViewCMR_Previews: PreviewProvider{
    static var previews: some View{
        return SuccessMessageView(operationSuccess: MockDataGenerator.createOperationSuccess(), translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo(amount:"$9.950", merchant: nil), returnToApp: {})
            .environmentObject(ThemeManager())
    }
}


@available(iOS 16.0, *)
struct SuccessMessageView_Previews: PreviewProvider{
    static var previews: some View{
        return SuccessMessageView(operationSuccess: MockDataGenerator.createOperationSuccess(), translator: MockDataGenerator.createTranslator(), operationInfo: MockDataGenerator.createOperationInfo(amount:"$9.950", merchantLogo: "logo",merchantName: "Demo Merchant"), returnToApp: {})
            .environmentObject(ThemeManager())
            .padding()
    }
    
}
