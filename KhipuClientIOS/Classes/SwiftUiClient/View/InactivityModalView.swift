import SwiftUI

@available(iOS 15.0, *)
struct InactivityModalView: View {
    
    @Binding var isPresented: Bool
    var onDismiss: () -> Void
    var translator: KhipuTranslator
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        if isPresented {
            ModalView(
                title: translator.t("page.are.you.there.title"),
                message: "\(translator.t("page.are.you.there.continue.operation")) \n\(translator.t("page.are.you.there.session.about.to.end"))",
                primaryButtonLabel: translator.t("page.are.you.there.continue.button"),
                primaryButtonAction: {
                    isPresented = false
                    onDismiss()
                },
                primaryButtonColor: ThemeManager().selectedTheme.colors.primary,
                icon: Image(systemName: "clock.fill"),
                iconColor: themeManager.selectedTheme.colors.tertiary,
                imageSrc: "https://khenshin-web.s3.amazonaws.com/img/ufo.svg",
                countDown: 60)
            .padding()
        
        }
    }
}


@available(iOS 15.0.0, *)
struct InactivityModalView_Previews: PreviewProvider {
    static var previews: some View {
       
        let getFunction: () -> Bool = { true }
        let setFunction: (Bool) -> Void = { param in }
        let onDismiss: () -> Void = {}
        
        return InactivityModalView( isPresented: Binding(get: getFunction, set: setFunction), onDismiss: onDismiss, translator: MockDataGenerator.createTranslator())
            .environmentObject(ThemeManager())

        .environmentObject(ThemeManager())
        .previewLayout(.sizeThatFits)
    }
}

