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
        input.placeholder = self.formItem!.label
        addSubview(input)
        addSubview(error)
        translatesAutoresizingMaskIntoConstraints = false
        input.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            //heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
            input.topAnchor.constraint(equalTo: self.topAnchor),
            input.widthAnchor.constraint(equalTo: self.widthAnchor),
            error.topAnchor.constraint(equalTo: input.bottomAnchor),
            error.bottomAnchor.constraint(equalTo: bottomAnchor),
            error.leadingAnchor.constraint(equalTo: leadingAnchor),
            error.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    override func validate() -> Bool {
        guard let text = input.text else { return false}

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error.text = "Campo obligatorio"
            return false
        } else {
            error.text = ""
            return true
        }
    }
}
