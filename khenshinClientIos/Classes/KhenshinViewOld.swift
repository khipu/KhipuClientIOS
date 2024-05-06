import UIKit
import RxSwift
import RxCocoa
import KhenshinProtocol

public class KhenshinViewOld: UIViewController {
    var operationId: String?
    var khenshinClient: KhenshinClient?
    let disposeBag = DisposeBag()
    var operationInfo: OperationInfo?
    let allowCredentialsSaving: Bool
    let principalColor: UIColor
    let headerColor: UIColor
    let operationSuccessCallback: () -> Any?
    let operationWarningCallback: () -> Any?
    let operationFailureCallback: () -> Any?

    public init(operationId: String,
                backendUrl: String,
                backendPublicKey: String,
                allowCredentialsSaving: Bool,
                principalColor: UIColor,
                headerColor: UIColor,
                using operationSuccessCallback: @escaping () -> Any?,
                using operationWarningCallback: @escaping () -> Any?,
                using operationFailureCallback: @escaping () -> Any?
    ) {
        self.allowCredentialsSaving = allowCredentialsSaving
        self.principalColor = principalColor
        self.headerColor = headerColor
        self.operationSuccessCallback = operationSuccessCallback
        self.operationWarningCallback = operationWarningCallback
        self.operationFailureCallback = operationFailureCallback
        super.init(nibName: nil, bundle: nil)
        self.operationId = operationId
        self.khenshinClient = KhenshinClient(
            serverUrl: backendUrl,
            publicKey: backendPublicKey,
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
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        container.backgroundColor = self.principalColor
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
    }

    lazy private var header: HeaderView =  {
        let header = HeaderView(headerColor: self.headerColor)
        return header
    }()

    lazy private var container: UIView = {
        let container = UIView()
        return container
    }()

    lazy private var component: UIView = {
        let component = UIView()
        return component
    }()


    lazy private var footer: FooterView =  {
        let footer = FooterView()
        return footer
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
        case MessageType.operationInfo.rawValue:
            do {
                operationInfo = try OperationInfo(message)
                refreshHeaderView()
                return
            } catch {
                print("Error processing OperationInfo message, \(message)")
            }
            break
        case MessageType.operationFailure.rawValue:
            do {
                OperationState.instance.setFinalState(state: MessageType.operationFailure)
                if(OperationState.instance.getSkipResultPage()){
                    self.failureAndDismiss()
                    return
                }
                let operationFailure = try OperationFailure(message)
                component = drawFailureMessageComponent(operationFailure:operationFailure)
                Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.failureAndDismiss), userInfo: nil, repeats: false)
            } catch {
                print("Error processing OperationFailure message, \(message)")
            }
            break
        case MessageType.operationWarning.rawValue:
            do {
                OperationState.instance.setFinalState(state: MessageType.operationWarning)
                if(OperationState.instance.getSkipResultPage()){
                    self.warningAndDismiss()
                    return
                }
                let operationWarning = try OperationWarning(message)
                component = drawWarningMessageComponent(operationWarning:operationWarning)
                Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.warningAndDismiss), userInfo: nil, repeats: false)
            } catch {
                print("Error processing OperationWarning message, \(message)")
            }
            break
        case MessageType.operationSuccess.rawValue:
            do {
                OperationState.instance.setFinalState(state: MessageType.operationSuccess)
                if(OperationState.instance.getSkipResultPage()){
                    self.successAndDismiss()
                    return
                }
                let operationSuccess = try OperationSuccess(message)
                component = drawSuccessMessageComponent(operationSuccess:operationSuccess)
                Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.successAndDismiss), userInfo: nil, repeats: false)
            } catch {
                print("Error processing OperationSuccess message, \(message)")
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
        component!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            component!.widthAnchor.constraint(equalTo: self.component.widthAnchor),
            component!.topAnchor.constraint(equalTo: self.component.topAnchor),
            component!.bottomAnchor.constraint(equalTo: self.component.bottomAnchor),
        ])
    }

    private func drawProgressInfoComponent(message: ProgressInfo) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return ProgressInfoComponent(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), progressInfo: message)
    }

    private func drawFormRequestComponent(message: FormRequest) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let formComponent = FormComponent(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), formRequest: message, color: self.principalColor)
        formComponent.button.rx.tap
            .bind {
                if let formResponse = formComponent.createFormResponse() {
                    self.khenshinClient?.sendMessage(type: formResponse.type.rawValue, message: formResponse)
                }
            }
            .disposed(by: self.disposeBag)
        return formComponent
    }

    private func drawFailureMessageComponent(operationFailure: OperationFailure) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return FailureMessage(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), operationFailure: operationFailure, operationInfo:operationInfo!)
    }

    private func drawWarningMessageComponent(operationWarning: OperationWarning) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return WarningMessage(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), operationWarning: operationWarning, operationInfo:operationInfo!)
    }


    private func drawSuccessMessageComponent(operationSuccess: OperationSuccess) -> UIView {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return SuccessMessage(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), operationSuccess: operationSuccess, operationInfo:operationInfo)
    }

    public func refreshHeaderView() {
        header.updateHeaderValue(with: operationInfo!)
     }
    
    @objc private func successAndDismiss() {
        dismiss(animated: true)
        self.operationSuccessCallback()
    }
    
    @objc private func warningAndDismiss() {
        dismiss(animated: true)
        self.operationWarningCallback()
    }
    
    @objc private func failureAndDismiss() {
        dismiss(animated: true)
        self.operationFailureCallback()
    }
}
