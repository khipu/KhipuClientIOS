import UIKit
import KhenshinProtocol

class TextField: BaseField, UITextFieldDelegate {
    lazy private var errorLabel = ComponentBuilder.buildLabel(textColor: .red, fontSize: 12, backgroundColor: .black)

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        return textField
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("shouldChangeCharactersIn: \(string)")
        return true
    }

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
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            //topAnchor.constraint(equalTo: superview!.topAnchor),
            //bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            //textField.topAnchor.constraint(equalTo: topAnchor, constant: 0),

            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
        ])

    }

    override func validate() -> Bool {
        guard let text = textField.text else { return false}

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorLabel.text = "Campo obligatorio"
            return false
        } else {
            errorLabel.text = ""
            return true
        }
    }
}
