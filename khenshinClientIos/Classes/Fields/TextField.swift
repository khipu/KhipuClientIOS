import UIKit
import KhenshinProtocol

class TextField: BaseField, UITextFieldDelegate {
    lazy private var error = ComponentBuilder.buildLabel(textColor: .red, fontSize: 12, backgroundColor: .black)
    lazy private var input = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 14), borderStyle: .roundedRect)

    override func getValue() -> String {
        return input.text!
    }

    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        input.placeholder = self.formItem!.label
        self.formItem?.id == "password" ? (input.isSecureTextEntry = true) : ()
        addSubview(input)
        addSubview(error)
        translatesAutoresizingMaskIntoConstraints = false
        input.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false
        
        configureLengthConstraints()
        
        NSLayoutConstraint.activate([
            input.topAnchor.constraint(equalTo: self.topAnchor),
            input.widthAnchor.constraint(equalTo: self.widthAnchor),
            error.topAnchor.constraint(equalTo: input.bottomAnchor),
            error.bottomAnchor.constraint(equalTo: bottomAnchor),
            error.leadingAnchor.constraint(equalTo: leadingAnchor),
            error.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    override func validate() -> Bool {
        guard let text = input.text else { return false }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error.text = "Campo obligatorio"
            return false
        } else {
            error.text = ""
            return true
        }
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


    func textField(_ input: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = input.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)

        return (self.formItem?.maxLength.map { prospectiveText.count <= Int($0) } ?? true)
    }
}
