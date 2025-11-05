import SwiftUI

@available(iOS 15.0, *)
struct FooterComponent: View {
    var translator: KhipuTranslator
    var showFooter: Bool
    var operationCode: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text("V \(KhipuVersion.version)")
                .font(.custom("Roboto", size: 10).weight(.medium))
                .foregroundColor(Color(hexString: "#9797A5") ?? .gray)
                .lineSpacing(4)
            
            if let code = operationCode {
                Text("|")
                    .font(.custom("Roboto", size: 10).weight(.medium))
                    .foregroundColor(Color(hexString: "#9797A5") ?? .gray)
                    .lineSpacing(4)
                
                Text(formatOperationCode(code))
                    .font(.custom("Roboto", size: 10).weight(.medium))
                    .foregroundColor(Color(hexString: "#9797A5") ?? .gray)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 45)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hexString: "#E0E0E0") ?? Color.gray.opacity(0.3)),
            alignment: .top
        )
    }
    
    private func formatOperationCode(_ code: String) -> String {
        let cleanCode = code.uppercased().replacingOccurrences(of: "-", with: "")
        var formatted = ""
        for (index, character) in cleanCode.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += "-"
            }
            formatted.append(character)
        }
        
        return formatted
    }
}


@available(iOS 15.0, *)
struct FooterComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            FooterComponent(
                translator: MockDataGenerator.createTranslator(),
                showFooter: true,
                operationCode: "HUSK-P7ZZ-XGYG"
            )
            .environmentObject(ThemeManager())
            
            FooterComponent(
                translator: MockDataGenerator.createTranslator(),
                showFooter: true,
                operationCode: nil
            )
            .environmentObject(ThemeManager())
        }
    }
}

