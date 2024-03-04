import UIKit
import KhenshinProtocol

class EmailField: BaseField,UITextFieldDelegate {
    lazy private var errorLabel = ComponentBuilder.buildLabel(textColor: .red, fontSize: 12, backgroundColor: .black)
    lazy private var emailTextField = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 18), borderStyle: .roundedRect)
    
    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        emailTextField.placeholder = self.formItem!.placeHolder

        addSubview(emailTextField)
        addSubview(errorLabel)

        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: self.topAnchor),
            emailTextField.widthAnchor.constraint(equalTo: self.widthAnchor),

            errorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }


    override func getValue() -> String {
        return self.emailTextField.text!
    }

    override func validate() -> Bool {
        guard let text = emailTextField.text else { return false }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorLabel.text = "Campo obligatorio"
            return false
        } else if !validateEmail(text) {
            errorLabel.text = "La dirección de correo electrónico no es válida."
            return false
        } else {
            errorLabel.text = ""
            return true
        }
    }

    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = try! NSRegularExpression(pattern: "^(?!(^[.-].*|[^@]*[.-]@|.*\\.{2,}.*)|^.{254}.)([a-zA-Z0-9!#$%&'*+\\/=?^_`{|}~.-]+@)(?!-.*|.*-\\.)([a-zA-Z0-9-]{1,63}\\.)+[a-zA-Z]{2,15}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: email.utf16.count)
        let matches = emailRegex.numberOfMatches(in: email, options: [], range: range)

        return matches > 0
    }
}
