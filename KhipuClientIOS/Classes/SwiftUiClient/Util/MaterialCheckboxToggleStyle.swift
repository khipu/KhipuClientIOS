import SwiftUI

@available(iOS 15.0, *)
public struct MaterialCheckboxToggleStyle: ToggleStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(
                            configuration.isOn ?
                            Color(hexString: "#7E57C2") ?? Color.purple :
                                Color.black.opacity(0.56),
                            lineWidth: 2
                        )
                        .frame(width: 18, height: 18)

                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color(hexString: "#7E57C2") ?? Color.purple)
                    }
                }
                .frame(width: 24, height: 24)
                .padding(9)

                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
