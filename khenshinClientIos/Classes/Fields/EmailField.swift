import UIKit
import KhenshinProtocol


class EmailField: UIView, KhipuField, UITextFieldDelegate {
    var formItem: FormItem?
    var validateField: ((String) -> Void)?
    var onChange: ((String) -> Void)?
    
    lazy private var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()

    lazy private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()

    init(formItem: FormItem) {
        super.init(frame: .zero)
        self.formItem = formItem
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(errorLabel)
        titleLabel.text = self.formItem!.title
        emailTextField.placeholder = self.formItem!.placeHolder

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: superview!.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: superview!.widthAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            emailTextField.widthAnchor.constraint(equalTo: superview!.widthAnchor),

            errorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
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
    
    public func getFormItem() -> FormItem {
        return self.formItem!
    }
    
    public func getValue () -> String {
        return self.emailTextField.text!
    }

}
