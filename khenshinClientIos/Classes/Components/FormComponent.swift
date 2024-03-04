import UIKit
import KhenshinProtocol

class FormComponent: UIView, UITextFieldDelegate {
    private let formRequest: FormRequest?

    lazy private var formTitle = ComponentBuilder.buildLabel(textColor: .black, fontSize: 20, backgroundColor: .white)
    lazy private var formError = ComponentBuilder.buildLabel(textColor: .black, fontSize: 10, backgroundColor: .red)
    lazy public var continueButton = ComponentBuilder.buildButton(withTitle: "Continuar", backgroundColorHex: "8347ad", titleColor: .white)

    lazy private var formComponents: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    init(frame: CGRect, formRequest: FormRequest) {
        self.formRequest = formRequest
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        if superview == nil {
            return
        }
        backgroundColor = UIColor.orange
        configureView()
        addSubview(formTitle)
        addSubview(formError)
        addSubview(formComponents)
        setupFormConstraints()
    }

    private func setupFormConstraints() {
        guard let superview = superview else {
            print("Error: superview es nil")
            return
        }
        formTitle.translatesAutoresizingMaskIntoConstraints = false
        formError.translatesAutoresizingMaskIntoConstraints = false
        formComponents.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            //self.topAnchor.constraint(equalTo: superview!.topAnchor),
            //self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
            //widthAnchor.constraint(equalTo: superview!.widthAnchor),
            formTitle.topAnchor.constraint(equalTo: topAnchor),
            formTitle.widthAnchor.constraint(equalTo: widthAnchor),
            formError.topAnchor.constraint(equalTo: formTitle.bottomAnchor),
            formError.widthAnchor.constraint(equalTo: superview.widthAnchor),
            formComponents.topAnchor.constraint(equalTo: formError.bottomAnchor, constant: 8),
            formComponents.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            formComponents.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }

    private func setupForm() {
        formTitle.text = formRequest?.title
        formError.text = formRequest?.errorMessage
        continueButton.setTitle(formRequest?.continueLabel != nil && formRequest?.continueLabel != "" ? formRequest?.continueLabel : "Continuar", for: .normal)

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
                    formComponents.addArrangedSubview(ComponentBuilder.buildSpacingView(spacingHeight: 20.0))
                }
            }
        }
        formComponents.addArrangedSubview(ComponentBuilder.buildSpacingView(spacingHeight: 70.0))
        formComponents.addArrangedSubview(continueButton)
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
