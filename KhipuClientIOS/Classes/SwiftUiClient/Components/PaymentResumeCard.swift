import SwiftUI

@available(iOS 15.0, *)
struct PaymentResumeCard: View {
    var merchantLogo: String?
    var merchantName: String
    var paymentDescription: String
    var amount: String
    var onDetailTap: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            if let logoUrl = merchantLogo, let url = URL(string: logoUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white, lineWidth: 1)
                        )
                } placeholder: {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 75, height: 75)
                }
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 75, height: 75)
            }

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(merchantName)
                            .font(.custom("Public Sans", size: 14).weight(.semibold))
                            .foregroundColor(Color(hexString: "#4C4E64")?.opacity(0.68) ?? .gray)
                            .lineLimit(1)

                        Text(paymentDescription)
                            .font(.custom("Public Sans", size: 14).weight(.semibold))
                            .foregroundColor(Color(hexString: "#4C4E64") ?? .gray)
                            .lineLimit(1)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 0) {
                        Text(amount)
                            .font(.custom("Public Sans", size: 18).weight(.bold))
                            .foregroundColor(.black)

                        Button(action: onDetailTap) {
                            Text("VER DETALLE")
                                .font(.custom("Public Sans", size: 13).weight(.medium))
                                .foregroundColor(Color(hexString: "#8347AD") ?? .purple)
                                .tracking(0.46)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 15.0, *)
struct PaymentResumeCard_Previews: PreviewProvider {
    static var previews: some View {
        PaymentResumeCard(
            merchantLogo: nil,
            merchantName: "CMR Falabella",
            paymentDescription: "Pago tarjeta crédito",
            amount: "$741.780",
            onDetailTap: {}
        )
        .environmentObject(ThemeManager())
        .background(Color(hexString: "#F5F5F5"))
    }
}
