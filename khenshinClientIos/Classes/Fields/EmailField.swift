import UIKit
import KhenshinProtocol

class EmailField: BaseField, UITextFieldDelegate {
    lazy private var error = ComponentBuilder.buildLabel(textColor: .red, fontSize: 9, backgroundColor: .black)
    lazy private var input = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 14), borderStyle: .roundedRect)
    lazy private var hint  = ComponentBuilder.buildLabel(textColor: .lightGray, fontSize: 9, backgroundColor: UIColor.white)

    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        configureGestures()
        configureInputField()

        addSubview(input)
        addSubview(hint)
        addSubview(error)
        input.translatesAutoresizingMaskIntoConstraints = false
        hint.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false

        configureLengthConstraints()

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            input.topAnchor.constraint(equalTo: self.topAnchor),
            input.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            hint.topAnchor.constraint(equalTo: input.bottomAnchor),
            hint.trailingAnchor.constraint(equalTo: input.trailingAnchor),
             
            error.topAnchor.constraint(equalTo: hint.bottomAnchor),
            error.trailingAnchor.constraint(equalTo: input.trailingAnchor),
            
        ])
    }

    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }

    private func configureInputField() {
        input.placeholder = self.formItem!.placeHolder
        input.keyboardType = .emailAddress
        hint.text = self.formItem?.hint
    }

    override func getValue() -> String {
        return self.input.text!
    }

    override func validate() -> Bool {
        guard let text = input.text else { return false }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error.text = "Campo obligatorio"
            return false
        } else if !validateEmail(text) {
            error.text = "La dirección de correo electrónico no es válida."
            return false
        } else {
            error.text = ""
            return true
        }
    }

    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = try! NSRegularExpression(pattern: "^(?!(^[.-].*|[^@]*[.-]@|.*\\.{2,}.*)|^.{254}.)([a-zA-Z0-9!#$%&'*+\\/=?^_`{|}~.-]+@)(?!-.*|.*-\\.)([a-zA-Z0-9-]{1,63}\\.)+[a-zA-Z]{2,15}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: email.utf16.count)
        let matches = emailRegex.numberOfMatches(in: email, options: [], range: range)

        return matches > 0
    }

    @objc private func handleTap() {
        self.endEditing(true)
    }

    private func configureLengthConstraints() {
        if let maxLength = self.formItem?.maxLength, maxLength > 0 {
            input.addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }

    @objc private func limitLength() {
        guard let text = input.text else { return }

        if let maxLength = self.formItem?.maxLength, text.count > Int(maxLength) {
            let index = text.index(text.startIndex, offsetBy: min(text.count, Int(maxLength)))
            input.text = String(text.prefix(upTo: index))
        }
    }
}
