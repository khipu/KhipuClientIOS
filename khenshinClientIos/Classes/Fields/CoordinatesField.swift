import UIKit
import KhenshinProtocol

class CoordinatesField: BaseField {
    
    lazy private var error = ComponentBuilder.buildLabel(textColor: .red, fontSize: 12, backgroundColor: .black)
    lazy private var label1 = ComponentBuilder.buildLabel(textColor: UIColor.black, fontSize: 10, backgroundColor: UIColor.lightGray)
    lazy private var label2 = ComponentBuilder.buildLabel(textColor: UIColor.black, fontSize: 10, backgroundColor: UIColor.lightGray)
    lazy private var label3 = ComponentBuilder.buildLabel(textColor: UIColor.black, fontSize: 10, backgroundColor: UIColor.lightGray)
    lazy private var input1 = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 14), borderStyle: .roundedRect)
    lazy private var input2 = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 14), borderStyle: .roundedRect)
    lazy private var input3 = ComponentBuilder.buildCustomTextField(font: UIFont.systemFont(ofSize: 14), borderStyle: .roundedRect)
    private var maxLength: Int = 2

    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    required init?(formItem: FormItem) {
        super.init(formItem: formItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        label1.text = (self.formItem!.labels?[0])
        label2.text = (self.formItem!.labels?[1])
        label3.text = (self.formItem!.labels?[2])
        
        addSubview(error)
        error.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStackView = UIStackView(arrangedSubviews: [label1, label2, label3])
        labelStackView.axis = .horizontal
        labelStackView.spacing = 10
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelStackView)
        
        let inputStackView = UIStackView(arrangedSubviews: [input1, input2, input3])
        inputStackView.axis = .horizontal
        inputStackView.spacing = 5
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputStackView)
        
        if self.formItem?.secure == true {
            [input1, input2, input3].forEach { $0.isSecureTextEntry = true }
        }
        
        NSLayoutConstraint.activate([
            error.bottomAnchor.constraint(equalTo: labelStackView.topAnchor, constant: -16),
            error.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            error.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            labelStackView.topAnchor.constraint(equalTo: error.bottomAnchor, constant: 16),
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            inputStackView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 5),
            inputStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            inputStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        [input1, input2, input3].forEach { input in
            input.addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }
    
    
    override func getValue() -> String {
        let values = [input1, input2, input3].compactMap { $0.text }
        return values.joined(separator: "|")
    }
    
    
    override func validate() -> Bool {
        let inputs = [input1, input2, input3]
        
        for input in inputs {
            if input.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                error.text = Messages.ALL_FIELDS_REQUIRED
                return false
            }
        }
        
        error.text = ""
        return true
    }
    
    @objc private func handleTap() {
        self.endEditing(true)
    }
    
    @objc private func limitLength(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if (text.count > maxLength) {
            let index = text.index(text.startIndex, offsetBy: min(text.count, Int(maxLength)))
            textField.text = String(text.prefix(upTo: index))
        }
    }
}
