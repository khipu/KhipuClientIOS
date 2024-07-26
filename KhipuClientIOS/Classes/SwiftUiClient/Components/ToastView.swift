import SwiftUI

struct ToastView: View {
    let message: String

    @available(iOS 13.0, *)
    var body: some View {
        Text(message)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 40)
    }
}


@available(iOS 13.0, *)
struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: "Error de conexion")
            .environmentObject(ThemeManager())
    }
}
