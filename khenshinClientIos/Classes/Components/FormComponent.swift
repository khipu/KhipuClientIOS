//
//  Form.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 23-02-24.
//

import KhenshinProtocol

class FormComponent: UIView {
    private let formRequest: FormRequest?
    
    lazy private var formTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.black
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
        let formComponentsStack = UIStackView()
        formComponentsStack.axis = .vertical
        formComponentsStack.alignment = .center
        formComponentsStack.distribution = .equalSpacing
        formComponentsStack.spacing = 5
        return formComponentsStack
    }()
    
    lazy private var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(sendForm), for: .touchUpInside)
        return button

    }()
    
    init(frame: CGRect, formRequest: FormRequest) {
        self.formRequest = formRequest
        super.init(frame: frame)
        //setupViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        setupForm(with: self.formRequest!)
        backgroundColor = UIColor.yellow
        addSubview(formTitle)
        addSubview(formError)
        addSubview(formComponents)
        addSubview(continueButton)
        
        /*axis = .vertical
        alignment = .center
        distribution = .equalSpacing
        spacing = 16*/
        
        /*translatesAutoresizingMaskIntoConstraints = false
        formTitle.translatesAutoresizingMaskIntoConstraints = false
        formError.translatesAutoresizingMaskIntoConstraints = false
        formComponents.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: newSuperview!.topAnchor),
            bottomAnchor.constraint(equalTo: newSuperview!.bottomAnchor),
            widthAnchor.constraint(equalTo: newSuperview!.widthAnchor),
            centerXAnchor.constraint(equalTo: newSuperview!.centerXAnchor),
            centerYAnchor.constraint(equalTo: newSuperview!.centerYAnchor),
            formTitle.topAnchor.constraint(equalTo: newSuperview!.topAnchor),
            formError.topAnchor.constraint(equalTo: formTitle.bottomAnchor, constant: 15),
            formComponents.topAnchor.constraint(equalTo: formError.bottomAnchor, constant: 15),
            continueButton.bottomAnchor.constraint(equalTo: newSuperview!.bottomAnchor, constant: 15),
        ])*/
        
        //formComponents.setContentCompressionResistancePriority(.required, for: .vertical)
        
        /*formComponents.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formComponents.leadingAnchor.constraint(equalTo: leadingAnchor),
            formComponents.trailingAnchor.constraint(equalTo: trailingAnchor),
            //formComponents.topAnchor.constraint(equalTo: formError.topAnchor),
            //continueButton.topAnchor.constraint(equalTo: formComponents.bottomAnchor),
        ])*/
    }
    
    /*public func setupViews() {
        backgroundColor = UIColor.white
        addArrangedSubview(formTitle)
        addArrangedSubview(formError)
        addArrangedSubview(formComponents)
        addArrangedSubview(continueButton)
        
        axis = .vertical
        alignment = .center
        distribution = .equalSpacing
        spacing = 16
        
        formComponents.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formComponents.leadingAnchor.constraint(equalTo: leadingAnchor),
            formComponents.trailingAnchor.constraint(equalTo: trailingAnchor),
            //formComponents.topAnchor.constraint(equalTo: formError.topAnchor),
            //continueButton.topAnchor.constraint(equalTo: formComponents.bottomAnchor),
        ])
    }*/
    
    private func setupForm(with formRequest: FormRequest) {
        formTitle.text = formRequest.title
        formError.text = formRequest.errorMessage
        let continueLabel = formRequest.continueLabel != nil && formRequest.continueLabel != "" ? formRequest.continueLabel : "Continuar"
        continueButton.setTitle(continueLabel, for: .normal)
        formRequest.items.forEach { item in
            var component: UIView?
            switch item.type {
                case FormItemTypes.text:
                    if (item.email!) {
                        component = EmailField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
                    }
                    component = TextField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
                    break
                case FormItemTypes.rut:
                    component =  RutField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
                    break
                case FormItemTypes.list:
                    component =  RadioGroupField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
                    break
                case FormItemTypes.groupedList:
                    component = BankSelectField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), formItem: item)
                    break
                case FormItemTypes.coordinates:
                    component =  CoordinatesField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
                    break
                case FormItemTypes.imageChallenge:
                    break//questionAsImageChallenge(formItem)
                default:
                    break
                }
            if component != nil {
                formComponents.addArrangedSubview(component!)
            }
            
        }
        
        
        
    }
    
    @objc private func sendForm() {
        print("SENDING FORM")
    }
}
