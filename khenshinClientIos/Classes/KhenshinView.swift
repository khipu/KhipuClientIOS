import UIKit
import RxSwift
import KhenshinProtocol

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
        khenshinClient!.setupSocketEvents()
            .subscribe(
                onNext: { value in
                    let messageType = value[0]
                    let message = value[1]
                    print("DIBUJANDO COMPONENTE TIPO \(messageType)")
                    self.drawComponent(messageType: messageType, message: message)
                }, onError: { error in
                    print("ERROR REACTIVO: \(error)")
                }, onCompleted: {
                    print("REACTIVO COMPLETADO")
                }, onDisposed: {
                    print("REACTIVO DISPOSED")
                }).disposed(by: disposeBag)
        khenshinClient!.connect()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        let stackView = UIView()
        /*stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 5*/
        stackView.backgroundColor = UIColor.white

        stackView.addSubview(header)
        stackView.addSubview(component)
        stackView.addSubview(footer)

        self.view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false
        component.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            header.topAnchor.constraint(equalTo: view.topAnchor),
            component.topAnchor.constraint(equalTo: header.bottomAnchor),
            component.bottomAnchor.constraint(equalTo: footer.topAnchor),
            footer.topAnchor.constraint(equalTo: component.bottomAnchor),
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        /*header.setContentHuggingPriority(.required, for: .vertical)
        footer.setContentHuggingPriority(.required, for: .vertical)
        component.setContentCompressionResistancePriority(.required, for: .vertical)*/
    }
    
    lazy private var component: UIView = {
        let stackView = UIView()
        //stackView.axis = .vertical
        /*stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.backgroundColor = UIColor.yellow*/
        return stackView
    }()
    
    lazy private var header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Header!"
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.yellow
        return label
    }()
    
    lazy private var footer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Footer!"
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.green
        return label
    }()

<<<<<<< HEAD
    public func drawComponent(messageType: String, message: String) {
        var component: UIView?
        switch messageType {
        case MessageType.progressInfo.rawValue:
            do {
                let progressInfo = try ProgressInfo(message)
                component = drawProgressInfoComponent(message: progressInfo)
            } catch {
                print("Error processing ProgressInfo message, \(message)")
            }
            break
        case MessageType.formRequest.rawValue:
            do {
                let formRequest = try FormRequest(message)
                component = drawFormRequestComponent(message: formRequest)
            } catch {
                print("Error processing FormRequest message, \(message)")
=======
    public func drawOperationWarningComponent(operationWarning: OperationWarning) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let warningMessage = WarningMessage(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), operationWarning: operationWarning, amount: "$1.000",merchantName: "Nombre comercio DEMO")
        warningMessage.center = containerView.center
        containerView.addSubview(warningMessage)
    }

    public func drawOperationFailureComponent(operationFailure: OperationFailure) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let failureMessage = FailureMessage(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), operationFailure: operationFailure, amount: "$1.000",merchantName: "Nombre comercio DEMO")
        failureMessage.center = containerView.center
        containerView.addSubview(failureMessage)
    }
    
    
    public func drawOperationSuccessComponent(operationSuccess: OperationSuccess) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let successMessage = SuccessMessage(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), operationSuccess: operationSuccess, amount: "$1.000",merchantName: "Nombre comercio DEMO")
        successMessage.center = containerView.center
        containerView.addSubview(successMessage)
    }


    public func drawOperationRequestComponent(formRequest: FormRequest) {
        for item in formRequest.items {
            if let itemView = createFormItemView(item: item) {
                itemView.center = containerView.center
                containerView.addSubview(itemView)
>>>>>>> ea8c9f4 (add files from test)
            }
            break
        default:
            print("Tipo de mensaje no reconocido: \(messageType)")
            return
        }
        
        self.component.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.component.addSubview(component!)
        /*
        component!.translatesAutoresizingMaskIntoConstraints = false
        component!.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            component!.leadingAnchor.constraint(equalTo: self.component.leadingAnchor),
            component!.trailingAnchor.constraint(equalTo: self.component.trailingAnchor),
            component!.topAnchor.constraint(equalTo: self.component.topAnchor),
            component!.bottomAnchor.constraint(equalTo: self.component.bottomAnchor),
        ])*/
        
    }

<<<<<<< HEAD
    private func drawProgressInfoComponent(message: ProgressInfo) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return ProgressInfoComponent(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), progressInfo: message)
    }
    
    private func drawFormRequestComponent(message: FormRequest) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return FormComponent(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), formRequest: message)
=======
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
               return RadioGroupField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
           case FormItemTypes.groupedList:
               return nil//BankSelectField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), formItem: item)
           case FormItemTypes.coordinates:
               return CoordinatesField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
           case FormItemTypes.imageChallenge:
               return nil//questionAsImageChallenge(formItem)
           default:
               return nil
        }
>>>>>>> ea8c9f4 (add files from test)
    }
}
