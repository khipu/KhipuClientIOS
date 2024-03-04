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

        self.translatesAutoresizingMaskIntoConstraints = false
        formTitle.translatesAutoresizingMaskIntoConstraints = false
        formError.translatesAutoresizingMaskIntoConstraints = false
        formComponents.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            formTitle.topAnchor.constraint(equalTo: superview.topAnchor),
            formTitle.widthAnchor.constraint(equalTo: superview.widthAnchor),
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
                }
            default:
                break
            }

            if let componentType = component {
                if let component = componentType.init(formItem: item) as? BaseField & FormField {
                    formComponents.addArrangedSubview(component)
                    component.setupUI()
                }
            }
        }
        formComponents.addArrangedSubview(ComponentBuilder.buildSpacingView(spacingHeight: 70.0))
        formComponents.addArrangedSubview(continueButton)
    }

    public func createFormResponse() -> Optional<FormResponse> {
            let isValid = formComponents.subviews.allSatisfy { ($0 as? BaseField)?.validate() ?? true }

           guard isValid else { return nil }

            let answers = formComponents.subviews.map {
                FormItemAnswer(
                    id: ($0 as! BaseField).getFormItem().id,
                    type: ($0 as! BaseField).getFormItem().type,
                    value: ($0 as! BaseField).getValue()
                )
            }

            return FormResponse(answers: answers, id: self.formRequest!.id, type: MessageType.formResponse)
    }
}
