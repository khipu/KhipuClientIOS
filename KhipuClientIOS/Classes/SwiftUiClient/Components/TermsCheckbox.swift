import SwiftUI

@available(iOS 15.0, *)
struct TermsCheckbox: View {
    @Binding var isAccepted: Bool
    var termsURL: String
    var translator: KhipuTranslator
    @State private var showingWebView = false
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Toggle(isOn: $isAccepted) {
                EmptyView()
            }
            .toggleStyle(MaterialCheckboxToggleStyle())
            .frame(width: 42, height: 42)

            Button(action: {
                showingWebView = true
            }) {
                HStack(alignment: .center, spacing: 0) {
                    Text(buildTermsText())
                        .font(.custom("Roboto", size: 16).weight(.regular))
                        .tracking(0.15)
                        .lineSpacing(8)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingWebView) {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            showingWebView = false
                        } label: {
                            Image(systemName: "xmark")
                                .tint(themeManager.selectedTheme.colors.onSurfaceVariant)
                        }
                        .padding()
                    }
                    WebView(url: URL(string: termsURL)!)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func buildTermsText() -> AttributedString {
        var attributedString = AttributedString(translator.t("default.terms.accept.label"))
        attributedString.foregroundColor = Color.black.opacity(0.6)

        var linkString = AttributedString(translator.t("default.terms.accept.link.label"))
        linkString.foregroundColor = Color(hexString: "#0288D1") ?? .blue
        linkString.underlineStyle = .single
        attributedString.append(linkString)

        return attributedString
    }
}

@available(iOS 15.0, *)
struct TermsCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            TermsCheckbox(
                isAccepted: .constant(false),
                termsURL: "https://www.khipu.com/terms",
                translator: MockDataGenerator.createTranslator()
            )
            .environmentObject(ThemeManager())

            TermsCheckbox(
                isAccepted: .constant(true),
                termsURL: "https://www.khipu.com/terms",
                translator: MockDataGenerator.createTranslator()
            )
            .environmentObject(ThemeManager())
        }
        .padding()
        .background(Color.white)
    }
}
