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

    public func drawComponent(messageType: String, message: String) {
        var component: UIView!
        switch messageType {
        case MessageType.progressInfo.rawValue:
            do {
                let progressInfo = try ProgressInfo(message)
                component = drawProgressInfoComponent(message: progressInfo)
            } catch {
                print("Error processing ProgressInfo message, \(message)")
            }
            break
        default:
            print("Tipo de mensaje no reconocido: \(messageType)")
            return
        }
        self.component.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.component.addArrangedSubview(component)
    }

    private func drawProgressInfoComponent(message: ProgressInfo) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return ProgressInfoField(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), progressInfo: message)
    }
}
