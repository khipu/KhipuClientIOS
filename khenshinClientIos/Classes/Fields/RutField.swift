import UIKit
import KhenshinProtocol

class RutField: BaseField, UITextFieldDelegate {
    
    lazy private var error = ComponentBuilder.buildLabel(textColor: .red, fontSize: 12, backgroundColor: .black)
    lazy private var input = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 14), borderStyle: .roundedRect)

    
    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }
    
    override func getValue() -> String {
        return input.text!
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        input.placeholder = self.formItem!.label
        addSubview(input)
        addSubview(error)
        translatesAutoresizingMaskIntoConstraints = false
        input.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false

        input.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            input.topAnchor.constraint(equalTo: self.topAnchor),
            input.widthAnchor.constraint(equalTo: self.widthAnchor),
            error.topAnchor.constraint(equalTo: input.bottomAnchor),
            error.leadingAnchor.constraint(equalTo: leadingAnchor),
            error.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    override func validate() -> Bool {
        guard let text = input.text else { return false }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error.text = "Campo obligatorio"
            return false
        }else if !validateRut(text) {
            error.text = "Ingresa un RUT válido"
            return false
        } else {
            error.text = ""
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
