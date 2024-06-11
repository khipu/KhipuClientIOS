import SwiftUI

@available(iOS 15.0.0, *)
struct MerchantDialogComponent: View {
    var onDismissRequest: () -> Void
    var translator: KhipuTranslator
    var merchant: String
    var subject: String
    var description: String
    var amount: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    Text(translator.t("modal.merchant.info.title"))
                        .font(.subheadline)
                        .foregroundColor(.primary)

                    Text(translator.t("modal.merchant.info.destinatary.label"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(merchant)
                        .font(.footnote)

                    Text(translator.t("modal.merchant.info.subject.label"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                    Text(subject)
                        .font(.footnote)

                    if !description.isEmpty {
                        Text(translator.t("modal.merchant.info.description.label"))
                            .font(.caption)
                            .padding(.top, 4)
                            .foregroundColor(.secondary)
                        Text(description)
                            .font(.footnote)
                    }

                    Text(translator.t("modal.merchant.info.amount.label"))
                        .font(.caption)
                        .padding(.top, 4)
                        .foregroundColor(.secondary)
                    Text(amount)
                        .font(.footnote)
                }
                .padding()
                .frame(maxWidth: 300) 
            }
            .navigationTitle("Detalles del Pago")
            .navigationBarItems(trailing: Button("Cerrar", action: onDismissRequest))
        }
    }
}

@available(iOS 15.0.0, *)
struct MerchantDialogComponent_Previews: PreviewProvider {
    static var previews: some View {
        let onDismissRequest: () -> Void = {}
        return MerchantDialogComponent(
            onDismissRequest: onDismissRequest,
            translator: KhipuUiState().translator,
            merchant: "Merchant",
            subject: "Subject",
            description: "Description",
            amount: "$ 1.000"
        ).padding()
    }
}
