import SwiftUI

@available(iOS 13.0, *)
struct iOSCheckboxToggleStyle: ToggleStyle {
    @EnvironmentObject private var themeManager: ThemeManager
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
            .foregroundColor(themeManager.selectedTheme.colors.onSurface)
        })
    }
}
