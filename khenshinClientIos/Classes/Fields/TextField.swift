import UIKit
import KhenshinProtocol

class TextField: BaseField, UITextFieldDelegate {
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
            input.topAnchor.constraint(equalTo: self.topAnchor),
            input.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            hint.topAnchor.constraint(equalTo: input.bottomAnchor),
            hint.trailingAnchor.constraint(equalTo: input.trailingAnchor),
             
            error.topAnchor.constraint(equalTo: hint.bottomAnchor),
            error.trailingAnchor.constraint(equalTo: input.trailingAnchor),
            error.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])
    }
    
    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }

    private func configureInputField() {
        input.placeholder = self.formItem!.label
        self.formItem?.id == "password" ? (input.isSecureTextEntry = true) : ()
        hint.text = self.formItem?.hint
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
    
    override func getValue() -> String {
        return input.text!
    }
}
