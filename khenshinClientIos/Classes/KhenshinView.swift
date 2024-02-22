import UIKit
import RxSwift
import KhenshinProtocol

/*
public class KhenshinView {

    private let containerView: UIView


    public init(containerView: UIView) {
        self.containerView = containerView
    }


    public func drawProgressInfoComponent(progressInfo: ProgressInfo) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let progressInfoField = ProgressInfoField(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), progressInfo: progressInfo)
        progressInfoField.center = containerView.center
        containerView.addSubview(progressInfoField)
    }


    public func drawOperationRequestComponent(formRequest: FormRequest) {
        for item in formRequest.items {
            if let itemView = createFormItemView(item: item) {
                itemView.center = containerView.center
                containerView.addSubview(itemView)
            }
        }
    }

    private func createFormItemView(item: FormItem) -> UIView? {
        switch item.type {
        case FormItemTypes.text:
            if (item.email!) {
                    return EmailField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
                }
                return TextField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
           case FormItemTypes.rut:
               return RutField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
           case FormItemTypes.list:
               return nil//questionAsRadioGroup(formItem)
           case FormItemTypes.groupedList:
               return BankSelectField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), item: item, continueLabel: "Continue")
           case FormItemTypes.coordinates:
               return nil//questionAsCoordinates(formItem, props.errorMessage)
           case FormItemTypes.imageChallenge:
               return nil//questionAsImageChallenge(formItem)
           default:
               return nil
        }
    }*/
public class KhenshinView: UIViewController {
    var operationId: String?
    var khenshinClient: KhenshinClient?
    let disposeBag = DisposeBag()
    
    
    public init(operationId: String) {
        super.init(nibName: nil, bundle: nil)
        self.operationId = operationId
        self.khenshinClient = KhenshinClient(
            serverUrl: "http://localhost:8000",
            publicKey: "w5tIW3Ic0JMlnYz2Ztu1giUIyhv+T4CZJuKKMrbSEF8=",
            operationId: self.operationId!
        )
        
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.backgroundColor = UIColor.white

        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(component)
        stackView.addArrangedSubview(footer)

        self.view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        
        khenshinClient!.setupSocketEvents()
            .subscribe(
                onNext: { value in
                    print("EVENTO REACTIVO \(value)")
                }, onError: { error in
                    print("ERROR REACTIVO: \(error)")
                }, onCompleted: {
                    print("REACTIVO COMPLETADO")
                }, onDisposed: {
                    print("REACTIVO DISPOSED")
                }).disposed(by: disposeBag)
        khenshinClient!.connect()
        
    }
    
    lazy private var component: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()
    
    lazy private var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Header!"
        label.textColor = UIColor.black
        return label
    }()
    
    lazy private var footer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Footer!"
        label.textColor = UIColor.black
        return label
    }()

    public func drawComponent(messageType: String, message: Encodable) {
        switch messageType {
        case MessageType.operationInfo.rawValue:
            drawOperationInfoComponent(message: message as! ProgressInfo)
        //case MessageType.operationRequest.rawValue:
          //  drawOperationRequestComponent()
        default:
            print("Tipo de mensaje no reconocido: \(messageType)")
        }
    }

    private func drawOperationInfoComponent(message: ProgressInfo) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let progressInfo = ProgressInfoView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), message: message)
        component.addArrangedSubview(progressInfo)
        //progressInfo.center = overlayView.center
        //overlayView.addSubview(progressInfo)
    }

    /*private func drawOperationRequestComponent() {
    let operationRequestMessage = """
        {
            "type": "FORM_REQUEST",
            "id": "e0287b9a-901b-4df8-831c-6ccf36635856",
            "title": "Enter your e-mail",
            "progress": {},
            "items": [
                {
                    "type": "TEXT",
                    "id": "email",
                    "label": "E-mail",
                    "hint": "Here you will receive your payment receipt",
                    "defaultValue": "",
                    "secure": false,
                    "email": true,
                    "placeHolder": "Ex: name@mail.com"
                }
            ],
            "timeout": 300,
            "rememberValues": false
        }
        """
        do {
         let jsonData = operationRequestMessage.data(using: .utf8)!
         let formRequest = try JSONDecoder().decode(FormRequest.self, from: jsonData)
         let emailField = EmailField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), title: formRequest.title ?? "")
         emailField.center = overlayView.center
         overlayView.addSubview(emailField)
         } catch {
             print("Error decoding JSON: \(error)")
         }
       }*/
}
