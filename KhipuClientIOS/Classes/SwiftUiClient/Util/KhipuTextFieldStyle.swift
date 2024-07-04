import SwiftUI

@available(iOS 13.0, *)
struct KhipuTextFieldStyle: TextFieldStyle {
    @EnvironmentObject private var themeManager: ThemeManager
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical,Dimens.Padding.extraMedium)
            .padding(.horizontal,Dimens.Padding.veryMedium)
            .overlay(
                RoundedRectangle(cornerRadius:Dimens.CornerRadius.extraSmall)
                    .stroke(themeManager.selectedTheme.colors.onSurface, lineWidth: 0.2))
    }
}

@available(iOS 13.0, *)
struct ContentView: View {

    @State private var email = ""

    var body: some View {
        VStack() {
            TextField("Email", text: self.$email)
                .textFieldStyle(KhipuTextFieldStyle())
            TextField("Email", text: self.$email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

@available(iOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ThemeManager())
    }
}
