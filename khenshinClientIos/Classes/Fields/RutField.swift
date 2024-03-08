import UIKit
import KhenshinProtocol

class RutField: BaseField, UITextFieldDelegate {
    
    lazy private var error = ComponentBuilder.buildLabel(textColor: Styles.Error.TEXT_COLOR, fontSize: Styles.Error.FONT_SIZE, backgroundColor: Styles.Error.BACKGROUND_COLOR)
    lazy private var label = ComponentBuilder.buildLabel(textColor: Styles.Titles.TEXT_COLOR, fontSize: Styles.Titles.FONT_SIZE, backgroundColor: Styles.Titles.BACKGROUND_COLOR, isBold: true)
    lazy private var input = ComponentBuilder.buildCustomTextField(font: Styles.Input.FONT, borderStyle: Styles.Input.BORDER_STYLE)
    
    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }
    override func getValue() -> String {
        return input.text!
    }
    
    override func setValue(value: String) -> Void {
        input.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        configureGestures()
        configureInputField()
        
        addSubview(label)
        addSubview(input)
        addSubview(error)
        label.translatesAutoresizingMaskIntoConstraints = false
        input.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        configureLengthConstraints()
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            input.topAnchor.constraint(equalTo: label.bottomAnchor),
            input.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            error.topAnchor.constraint(equalTo: input.bottomAnchor),
            error.trailingAnchor.constraint(equalTo: input.trailingAnchor),
            error.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    private func configureInputField() {
        label.text = self.formItem!.label
        input.placeholder = self.formItem!.placeHolder
    }
    
    override func validate() -> Bool {
        guard let text = input.text else { return false }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error.text = Messages.FIELD_REQUIRED
            return false
        }else if !Validation.validateRut(text) {
            error.text = Messages.INVALID_RUT
            return false
        } else {
            error.text = ""
            return true
        }
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
    
    @objc private func handleTap() {
        self.endEditing(true)
    }
}
