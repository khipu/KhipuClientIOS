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
        /*stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 5*/
        container.backgroundColor = UIColor.white

        container.addSubview(header)
        container.addSubview(component)
        container.addSubview(footer)

        self.view.addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false
        component.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            footer.widthAnchor.constraint(equalTo: view.widthAnchor),
            component.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.topAnchor.constraint(equalTo: container.topAnchor),
            component.topAnchor.constraint(equalTo: header.bottomAnchor),
            component.bottomAnchor.constraint(equalTo: footer.topAnchor),
            footer.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        /*header.setContentHuggingPriority(.required, for: .vertical)
        footer.setContentHuggingPriority(.required, for: .vertical)
        component.setContentCompressionResistancePriority(.required, for: .vertical)*/
    }
    
    lazy private var container: UIView = {
        let container = UIView()
        //stackView.axis = .vertical
        /*stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.backgroundColor = UIColor.yellow*/
        return container
    }()
    
    lazy private var component: UIView = {
        let component = UIView()
        component.backgroundColor = UIColor.cyan
        //stackView.axis = .vertical
        /*stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.backgroundColor = UIColor.yellow*/
        return component
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
        /*if(component is FormComponent) {
            (component as! FormComponent).configureView()
        }*/
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

    private func drawProgressInfoComponent(message: ProgressInfo) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return ProgressInfoComponent(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), progressInfo: message)
    }

    private func drawFormRequestComponent(message: FormRequest) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return FormComponent(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), formRequest: message)
    }
}
