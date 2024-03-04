import UIKit
import KhenshinProtocol

class RutField: BaseField, UITextFieldDelegate {
    
    lazy private var errorLabel = ComponentBuilder.buildLabel(textColor: .red, fontSize: 12, backgroundColor: .black)
    lazy private var textField = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 18), borderStyle: .roundedRect)
    
    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        textField.placeholder = self.formItem!.label
        addSubview(textField)
        addSubview(errorLabel)
        //translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: topAnchor),

            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
        ])
    }

    override func validate() -> Bool {
        guard let text = textField.text else { return false }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorLabel.text = "Campo obligatorio"
            return false
        }else if !validateRut(text) {
            errorLabel.text = "Ingresa un RUT válido"
            return false
        } else {
            errorLabel.text = ""
            return true
        }
    }

    private func validateRut(_ rut: String) -> Bool {
        let dv = String(rut.last ?? Character(""))
        let rutBody = rut.dropLast().replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "")
        let generatedDv = getDv(Int(rutBody) ?? 0)

        return rutBody.count < 10 &&
               rutBody.count > 6 &&
               generatedDv.lowercased() == dv.lowercased()
    }


    private func getDv(_ T: Int) -> String {
        var M = 0
        var S = 1

        var T = T
        while T != 0 {
            S = (S + (T % 10) * (9 - (M % 6))) % 11
            T = T / 10
            M += 1
        }

        return S != 0 ? "\(S - 1)" : "k"
    }
}
