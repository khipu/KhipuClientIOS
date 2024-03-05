import UIKit
import KhenshinProtocol

class EmailField: BaseField,UITextFieldDelegate {
    lazy private var error = ComponentBuilder.buildLabel(textColor: .red, fontSize: 12, backgroundColor: .black)
    lazy private var input = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 14), borderStyle: .roundedRect)
    
    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        input.placeholder = self.formItem!.placeHolder
        addSubview(input)
        addSubview(error)
        input.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            input.topAnchor.constraint(equalTo: self.topAnchor),
            input.widthAnchor.constraint(equalTo: self.widthAnchor),
            error.topAnchor.constraint(equalTo: input.bottomAnchor),
            error.leadingAnchor.constraint(equalTo: leadingAnchor),
            error.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
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
}
