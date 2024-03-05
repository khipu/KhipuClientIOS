import UIKit
import KhenshinProtocol

class FormComponent: UIView, UITextFieldDelegate {
    private let formRequest: FormRequest?

    lazy private var title = ComponentBuilder.buildLabel(textColor: .black, fontSize: 16, backgroundColor: .white)
    lazy private var error = ComponentBuilder.buildLabel(textColor: .black, fontSize: 12, backgroundColor: .red)
    lazy public var button = ComponentBuilder.buildButton(withTitle: "Continuar", backgroundColorHex: "8347ad", titleColor: .white)

    lazy private var formComponents: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    init(frame: CGRect, formRequest: FormRequest) {
        self.formRequest = formRequest
        super.init(frame: frame)
        setupForm()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        if superview == nil {
            return
        }
        backgroundColor = UIColor.white
        addSubview(title)
        addSubview(error)
        addSubview(formComponents)
        addSubview(button)
        setupFormConstraints()
    }

    private func setupFormConstraints() {
        guard let superview = superview else {
            print("Error: superview es nil")
            return
        }
        title.translatesAutoresizingMaskIntoConstraints = false
        error.translatesAutoresizingMaskIntoConstraints = false
        formComponents.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        


        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.widthAnchor.constraint(equalTo: widthAnchor),
            error.topAnchor.constraint(equalTo: title.bottomAnchor),
            error.widthAnchor.constraint(equalTo: superview.widthAnchor),
            formComponents.topAnchor.constraint(equalTo: error.bottomAnchor, constant: 8),
            formComponents.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            formComponents.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            formComponents.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            button.topAnchor.constraint(equalTo: formComponents.bottomAnchor, constant: 8),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }

    private func setupForm() {
        title.text = formRequest?.title
        error.text = formRequest?.errorMessage
        let continueLabel = formRequest?.continueLabel != nil && formRequest?.continueLabel != "" ? formRequest?.continueLabel : "Continuar"
        button.setTitle(continueLabel, for: .normal)
        var previousComponent: UIView? = nil
        
        formRequest?.items.forEach { item in
            var component: FormField.Type?

            switch item.type {
            case FormItemTypes.text:
                if (item.email!) {
                    component = EmailField.self
                } else {
                    component = TextField.self
                }
                break
            case FormItemTypes.rut:
                component = RutField.self
            case FormItemTypes.list:
                component = RadioGroupField.self
                break
            case FormItemTypes.groupedList:
                component = BankSelectField.self
                break
            case FormItemTypes.coordinates:
                component = CoordinatesField.self
                break
            default:
                break
            }

            if let componentType = component {
                if let component = componentType.init(formItem: item) as? BaseField & FormField {
                    formComponents.addArrangedSubview(component)
                    component.setupUI()
                    //formComponents.addArrangedSubview(ComponentBuilder.buildSpacingView(spacingHeight: 55.0))
                }
            }
        }
        
        if let firstTextField = formComponents.subviews.compactMap({ $0 as? UITextField }).first {
            firstTextField.becomeFirstResponder()
        }
    }


    public func createFormResponse() -> Optional<FormResponse> {
        let isValid = formComponents.subviews.allSatisfy { ($0 as? FormField)?.validate() ?? true }

        guard isValid else { return nil }

        let answers = formComponents.subviews.compactMap { subview -> FormItemAnswer? in
            guard let formField = subview as? FormField else { return nil }
            return FormItemAnswer(
                id: formField.getFormItem().id,
                type: formField.getFormItem().type,
                value: formField.getValue()
            )
        }

        return FormResponse(answers: answers, id: self.formRequest!.id, type: MessageType.formResponse)
    }
}
