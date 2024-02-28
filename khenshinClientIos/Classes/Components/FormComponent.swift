import UIKit
import KhenshinProtocol

class FormComponent: UIView {
    private let formRequest: FormRequest?

    lazy private var formTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        return label
    }()

    lazy private var formError: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.red
        return label
    }()

    lazy private var formComponents: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    lazy public var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        return button

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
        if(superview == nil) {
            return
        }
        backgroundColor = UIColor.white
        addSubview(formTitle)
        addSubview(formError)
        addSubview(formComponents)
        addSubview(continueButton)
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
            continueButton.topAnchor.constraint(equalTo: formComponents.bottomAnchor),
            continueButton.widthAnchor.constraint(equalTo: superview.widthAnchor),
            continueButton.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }

    private func setupForm() {
        formTitle.text = formRequest?.title
        formError.text = formRequest?.errorMessage
        let continueLabel = formRequest?.continueLabel != nil && formRequest?.continueLabel != "" ? formRequest?.continueLabel : "Continuar"
        continueButton.setTitle(continueLabel, for: .normal)

        formRequest?.items.forEach { item in
            var component: UIView?

            switch item.type {
            case FormItemTypes.text:
                if (item.email!) {
                    component = EmailField(formItem: item)
                } else {
                    component = TextField(formItem: item)
                }
                break
            case FormItemTypes.rut:
                component = RutField(formItem: item)
                break
            case FormItemTypes.list:
                component = RadioGroupField(formItem: item)
                break
            case FormItemTypes.groupedList:
                component = BankSelectField(formItem: item)
                break
            case FormItemTypes.coordinates:
                component = CoordinatesField(formItem: item)
                break
            default:
                break
            }
            
            if let component = component {
                formComponents.addArrangedSubview(component)
            }

        }
    }

    public func createFormResponse() -> FormResponse {
        let answers = formComponents.subviews.map{
            FormItemAnswer(
                id: ($0 as! any KhipuField).getFormItem().id,
                type: ($0 as! any KhipuField).getFormItem().type,
                value: ($0 as! any KhipuField).getValue())}
        return FormResponse(answers: answers, id: self.formRequest!.id, type: MessageType.formResponse)
    }
}
