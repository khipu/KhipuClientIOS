
import SwiftUI

@available(iOS 15.0, *)
struct TermsAndConditionsComponent: View {
    var termsURL: String
    @State private var showingWebView = false
    @ObservedObject var viewModel: KhipuViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        
        let text = viewModel.uiState.translator.t("default.terms.continue.description")
        let components = text.components(separatedBy: "||")
        
        let link = LocalizedStringKey(stringLiteral: "\(components[0])[ \(components[1])](\(termsURL))")
        
        return VStack {
                Text(link)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .font(themeManager.selectedTheme.fonts.medium12)
                .foregroundColor(Color(red: 0.51, green: 0.52, blue: 0.56))
                    .environment(\.openURL, OpenURLAction(handler: handleURL))
                    .sheet(isPresented: $showingWebView) {
                        VStack{
                            HStack {
                                Spacer()
                                Button {
                                    showingWebView = false
                                } label: {
                                    Image(systemName: "xmark").tint(themeManager.selectedTheme.colors.onTopBarContainer)
                                }
                                .padding()
                            }
                            WebView(url: URL(string: termsURL)!)
                        }
                    }
            }
    }
    
    func handleURL(_ url: URL) -> OpenURLAction.Result {
            showingWebView = true
            return .handled
        }
}


@available(iOS 15.0, *)
struct TermsAndConditionsComponent_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = KhipuViewModel()
        viewModel.uiState.translator = KhipuTranslator(translations: ["default.terms.continue.description": "Al continuar tu pago estás aceptando las||condiciones de uso del servicio Khipu"])
        
        return TermsAndConditionsComponent(termsURL: "https://google.com", viewModel: viewModel)
            .environmentObject(ThemeManager())
    }
}
