import SwiftUI

@available(iOS 15.0, *)
struct InactivityModal: View {
    
    @Binding var isPresented: Bool
    var onDismiss: () -> Void
    
    @ObservedObject public var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if isPresented {
            ModalView(
                title: viewModel.uiState.translator.t("page.are.you.there.title"),
                message: "\(viewModel.uiState.translator.t("page.are.you.there.continue.operation")) \n\(viewModel.uiState.translator.t("page.are.you.there.session.about.to.end"))",
                primaryButtonLabel: viewModel.uiState.translator.t("page.are.you.there.continue.button"),
                primaryButtonAction: {
                    isPresented = false
                    onDismiss()
                },
                primaryButtonColor: ThemeManager().selectedTheme.colors.primary,
                icon: Image(systemName: "clock.fill"),
                iconColor: ThemeManager().selectedTheme.colors.tertiary,
                imageSrc: "https://khenshin-web.s3.amazonaws.com/img/ufo.svg",
                countDown: 60)
            .padding()
        
        }
    }
}

@available(iOS 15.0.0, *)
struct InactivityModal_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = KhipuViewModel()
        viewModel.uiState.translator = KhipuTranslator(translations: [
            "page.are.you.there.title": "¿Sigues ahí?",
            "page.are.you.there.continue.operation": "Continua con tu pago,",
            "page.are.you.there.session.about.to.end": "¡La sesión está a punto de cerrarse!",
            "page.are.you.there.continue.button": "Continuar pago",
        ])
        
        let getFunction: () -> Bool = { true }
        let setFunction: (Bool) -> Void = { param in }
        let onDismiss: () -> Void = {}
        return InactivityModal(
            isPresented: Binding(get: getFunction, set: setFunction), onDismiss: onDismiss,
            viewModel: viewModel
        )
        .environmentObject(ThemeManager())
        .previewLayout(.sizeThatFits)
    }
}
