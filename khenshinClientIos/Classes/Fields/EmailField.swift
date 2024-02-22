import UIKit
import KhenshinProtocol


class EmailField: UIView, UITextFieldDelegate {
    var formItem: FormItem
    var validateField: ((String) -> Void)?
    var onChange: ((String) -> Void)?
    
    
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ingresa tu email"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
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
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(errorLabel)
        titleLabel.text = self.formItem.title

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            errorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
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
        guard let text = emailTextField.text else { return }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorLabel.text = "Campo obligatorio"
        }else if !validateEmail(text) {
            errorLabel.text = "La dirección de correo electrónico no es válida."
        } else {
            errorLabel.text = ""
        }
        validateField?(text)

        onChange?(text)
    }
    
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = try! NSRegularExpression(pattern: "^(?!(^[.-].*|[^@]*[.-]@|.*\\.{2,}.*)|^.{254}.)([a-zA-Z0-9!#$%&'*+\\/=?^_`{|}~.-]+@)(?!-.*|.*-\\.)([a-zA-Z0-9-]{1,63}\\.)+[a-zA-Z]{2,15}$", options: .caseInsensitive)
        
        let range = NSRange(location: 0, length: email.utf16.count)
        let matches = emailRegex.numberOfMatches(in: email, options: [], range: range)
        
        return matches > 0
    }

}
