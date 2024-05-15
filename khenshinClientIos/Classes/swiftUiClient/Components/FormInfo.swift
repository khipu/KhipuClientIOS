import SwiftUI

@available(iOS 15.0, *)
struct FormInfo: View {
    var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(Color.blue)
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(Color.blue)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

