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
    
    lazy private var formComponents: UIView = {
        let formComponentsStack = UIView()
        formComponentsStack.backgroundColor = UIColor.cyan
        return formComponentsStack
    }()
    
    //lazy private var formComponents: UIStackView = {
    //    let formComponentsStack = UIStackView()
    //    formComponentsStack.axis = .vertical
    //    //formComponentsStack.alignment = .center
    //    formComponentsStack.distribution = .fill
    //    formComponentsStack.spacing = 5
    //    formComponentsStack.backgroundColor = UIColor.cyan
    //    return formComponentsStack
    //}()
    
    lazy public var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
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
        
    }
    
    override func didMoveToSuperview() {
        if(superview == nil) {
            return
        }
        configureView()
        backgroundColor = UIColor.orange
        addSubview(formTitle)
        addSubview(formError)
        addSubview(formComponents)
        
        addSubview(continueButton)
                        
        /*axis = .vertical
        alignment = .center
        distribution = .equalSpacing
        spacing = 16*/
        
        self.translatesAutoresizingMaskIntoConstraints = false
        formTitle.translatesAutoresizingMaskIntoConstraints = false
        formError.translatesAutoresizingMaskIntoConstraints = false
        formComponents.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview!.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
            widthAnchor.constraint(equalTo: superview!.widthAnchor),
            formTitle.topAnchor.constraint(equalTo: topAnchor),
            formTitle.widthAnchor.constraint(equalTo: widthAnchor),
            formError.topAnchor.constraint(equalTo: formTitle.bottomAnchor),
            formError.widthAnchor.constraint(equalTo: widthAnchor),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            continueButton.widthAnchor.constraint(equalTo: widthAnchor),
            formComponents.topAnchor.constraint(equalTo: formError.bottomAnchor),
            formComponents.bottomAnchor.constraint(equalTo: continueButton.topAnchor),
            formComponents.widthAnchor.constraint(equalTo: widthAnchor),
            
        ])
        
        print("formComponents.bottomAnchor: ",formComponents.bottomAnchor )
        //setupForm(with: self.formRequest!)
                
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
    
    public func configureView() {
        self.setupForm(with: self.formRequest!)
    }
    
    private func setupForm(with formRequest: FormRequest) {
        formTitle.text = formRequest.title
        formError.text = formRequest.errorMessage
        let continueLabel = formRequest.continueLabel != nil && formRequest.continueLabel != "" ? formRequest.continueLabel : "Continuar"
        continueButton.setTitle(continueLabel, for: .normal)
        formRequest.items.forEach { item in
            //var component: UIView?
            switch item.type {
                case FormItemTypes.text:
                    if (item.email!) {
                        formComponents.addSubview(EmailField(frame: CGRect(x: 0, y: 0, width: 300, height: 800),formItem:item))
                    } else {
                        formComponents.addSubview(TextField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item))
                    }                    
                    break
                case FormItemTypes.rut:
                    formComponents.addSubview(RutField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item))
                    break
                case FormItemTypes.list:
                    formComponents.addSubview(RadioGroupField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item))
                    break
                case FormItemTypes.groupedList:
                    formComponents.addSubview(BankSelectField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), formItem: item))
                    break
                case FormItemTypes.coordinates:
                    formComponents.addSubview(CoordinatesField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item))
                    break
                case FormItemTypes.imageChallenge:
                    break//questionAsImageChallenge(formItem)
                default:
                    break
                }
            //formComponents.addArrangedSubview(component!)
            
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
