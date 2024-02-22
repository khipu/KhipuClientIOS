import UIKit
import KhenshinProtocol

class RutField: UIView, UITextFieldDelegate {
    var formItem: FormItem
    var validateField: ((String) -> Void)?
    var onChange: ((String) -> Void)?

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = formItem.label
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(frame: CGRect, formItem: FormItem) {
        self.formItem = formItem
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(textField)
        addSubview(errorLabel)


        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
        ])
    }
    
    func configure(validateField: @escaping (String) -> Void, onChange: @escaping (String) -> Void) {
        self.validateField = validateField
        self.onChange = onChange
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
    }

    private func validate() {
        guard let text = textField.text else { return }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorLabel.text = "Campo obligatorio"
        }else if !validateRut(text) {
            errorLabel.text = "Ingresa un RUT válido"
        } else {
            errorLabel.text = ""
        }
        validateField?(text)

        onChange?(text)
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
        
        var T = T // Declaramos una variable mutable para mantener el valor original de T
        while T != 0 {
            S = (S + (T % 10) * (9 - (M % 6))) % 11
            T = T / 10
            M += 1
        }
        
        return S != 0 ? "\(S - 1)" : "k"
    }
}
