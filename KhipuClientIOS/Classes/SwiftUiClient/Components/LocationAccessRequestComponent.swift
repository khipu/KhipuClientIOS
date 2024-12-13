import SwiftUI

@available(iOS 15.0.0, *)
struct LocationAccessRequestComponent: View {
    @ObservedObject var viewModel: KhipuViewModel

    var body: some View {
        if viewModel.uiState.geolocationAcquired {
            ProgressComponent(currentProgress: viewModel.uiState.currentProgress)
            ProgressInfoView(message: viewModel.uiState.translator.t("geolocation.request.description"))
        } else {
            switch viewModel.uiState.locationAuthStatus {
            case .denied, .restricted:
                LocationAccessErrorView(
                    translator: viewModel.uiState.translator,
                    operationId: viewModel.uiState.operationId,
                    bank: viewModel.uiState.bank,
                    continueButton: {
                        viewModel.uiState.geolocationRequested = false
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    },
                    declineButton: { viewModel.uiState.returnToApp = true }
                )
            case .notDetermined:
                if viewModel.uiState.geolocationRequested {
                    ProgressComponent(currentProgress: viewModel.uiState.currentProgress)
                    ProgressInfoView(message: viewModel.uiState.translator.t("geolocation.request.description"))
                } else {
                    if viewModel.uiState.geolocationAccessDeclinedAtWarningView {
                        LocationAccessErrorView(
                            translator: viewModel.uiState.translator,
                            operationId: viewModel.uiState.operationId,
                            bank: viewModel.uiState.bank,
                            continueButton: {
                                viewModel.requestLocation()
                                viewModel.uiState.geolocationAccessDeclinedAtWarningView = false
                            },
                            declineButton: { viewModel.uiState.returnToApp = true }
                        )
                    } else {
                        LocationRequestWarningView(
                            translator: viewModel.uiState.translator,
                            operationId: viewModel.uiState.operationId,
                            bank: viewModel.uiState.bank,
                            continueButton: { viewModel.requestLocation() },
                            declineButton: { viewModel.uiState.geolocationAccessDeclinedAtWarningView = true }
                        )
                    }
                }
            case .authorizedWhenInUse, .authorizedAlways:
                ProgressComponent(currentProgress: viewModel.uiState.currentProgress)
                ProgressInfoView(message: viewModel.uiState.translator.t("geolocation.request.description"))
            @unknown default:
                LocationAccessErrorView(
                    translator: viewModel.uiState.translator,
                    operationId: viewModel.uiState.operationId,
                    bank: viewModel.uiState.bank,
                    continueButton: {
                        viewModel.uiState.geolocationRequested = false
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    },
                    declineButton: { viewModel.uiState.returnToApp = true }
                )
            }
        }
    }
}

@available(iOS 15.0, *)
struct LocationAccessRequestComponent_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = KhipuViewModel()

        mockViewModel.uiState.geolocationAcquired = false
        mockViewModel.uiState.locationAuthStatus = .notDetermined
        mockViewModel.uiState.translator = MockDataGenerator.createTranslator()
        mockViewModel.uiState.currentProgress = 0.5

        return LocationAccessRequestComponent(
            viewModel: mockViewModel
        )
        .environmentObject(ThemeManager())
    }
}

@available(iOS 15.0.0, *)
struct LocationAccessErrorView: View {
    let translator: KhipuTranslator
    let operationId: String
    let bank: String
    let continueButton: () -> Void
    let declineButton: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "gearshape.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Dimens.Image.huge, height: Dimens.Image.huge)
                .foregroundColor(Color(hexString: "#ED6C02"))
                .padding(.bottom, 24)
            
            Text(translator.t("geolocation.blocked.title"))
                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                .multilineTextAlignment(.center)
            
            Text(translator.t("geolocation.blocked.description").replacingOccurrences(of: "{{bank}}", with: bank))
                .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                .padding(.horizontal, 16)
            
            Button(action: continueButton) {
                Text(translator.t("geolocation.blocked.button.continue"))
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 16))
                    .foregroundColor(themeManager.selectedTheme.colors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.selectedTheme.colors.primary)
                    .cornerRadius(8)
            }
            .padding(.top, 24)
            
            Button(action: declineButton) {
                Text(translator.t("geolocation.blocked.button.decline"))
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 16))
                    .foregroundColor(themeManager.selectedTheme.colors.error)
                    .padding()
            }
        }
        .padding(24)
        .background(themeManager.selectedTheme.colors.surface)
    }
}

@available(iOS 15.0, *)
struct LocationAccessErrorView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAccessErrorView(
            translator: MockDataGenerator.createTranslator(),
            operationId: "test-operation",
            bank: "test-bank",
            continueButton: {},
            declineButton: {}
        )
        .environmentObject(ThemeManager())
    }
}

@available(iOS 15.0.0, *)
struct LocationRequestWarningView: View {
    let translator: KhipuTranslator
    let operationId: String
    let bank: String
    let continueButton: () -> Void
    let declineButton: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "mappin.and.ellipse.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Dimens.Image.huge, height: Dimens.Image.huge)
                .foregroundColor(Color(hexString: "#3CB4E5"))
                .padding(.bottom, 24)
            
            Text(translator.t("geolocation.warning.title").replacingOccurrences(of: "{{bank}}", with: bank))
                .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 24))
                .multilineTextAlignment(.center)
            
            Text(translator.t("geolocation.warning.description"))
                .font(themeManager.selectedTheme.fonts.font(style: .regular, size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.selectedTheme.colors.onSurfaceVariant)
                .padding(.horizontal, 16)
            
            Button(action: continueButton) {
                Text(translator.t("geolocation.warning.button.continue"))
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 16))
                    .foregroundColor(themeManager.selectedTheme.colors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.selectedTheme.colors.primary)
                    .cornerRadius(8)
            }
            .padding(.top, 24)
            
            Button(action: declineButton) {
                Text(translator.t("geolocation.warning.button.decline"))
                    .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 16))
                    .foregroundColor(themeManager.selectedTheme.colors.error)
                    .padding()
            }
        }
        .padding(24)
        .background(themeManager.selectedTheme.colors.surface)
    }
}

@available(iOS 15.0, *)
struct LocationRequestWarningView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestWarningView(
            translator: MockDataGenerator.createTranslator(),
            operationId: "test-operation",
            bank: "test-bank",
            continueButton: {},
            declineButton: {}
        )
        .environmentObject(ThemeManager())
    }
}