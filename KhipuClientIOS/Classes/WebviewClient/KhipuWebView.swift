import UIKit
import WebKit
import KhenshinProtocol


public class KhipuWebView: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    
    var webView: WKWebView!
    let operationId: String
    let options: KhipuOptions
    let completitionHandler: ((KhipuResult) -> Void)?
    var result: KhipuResult?
    var closed: Bool = false
    
    public init(operationId: String,
                options: KhipuOptions,
                onComplete: ((KhipuResult) -> Void)?) {
        self.operationId = operationId
        self.options = options
        self.completitionHandler = onComplete
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog; window.console.error = captureLog; window.console.debug = captureLog; window.console.info = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(script)
        webView.configuration.userContentController.add(self, name: "logHandler")
        webView.configuration.userContentController.add(self, name: "resultHandler")
        webView.configuration.userContentController.add(self, name: "closeHandler")
        
        
        view = webView
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(showAbortDialog))
        if(options.colors?.lightOnTopBarContainer != nil) {
            closeButton.tintColor = UIColor(hexString: options.colors!.lightOnTopBarContainer!)!
        } else {
            closeButton.tintColor = UIColor(hexString: "#2D004F")
        }
        self.navigationItem.rightBarButtonItem = closeButton
        
        
        if(options.topBarImageResourceName != nil) {
            let imageView = UIImageView(image: UIImage(named: options.topBarImageResourceName!))
            imageView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imageView
        } else {
            self.navigationItem.title = options.topBarTitle ?? appName()
        }
    }
    
    @objc func showAbortDialog() {
        let actionSheetController = UIAlertController(title: "¿Quieres salir del pago?", message: nil, preferredStyle: .actionSheet)

        let abort = UIAlertAction(title: "Sí, salir del pago", style: .destructive) { _ in
            self.completitionHandler!(KhipuResult(
                operationId: self.operationId,
                exitTitle: "Pago no realizado",
                exitMessage: "Has decidido cancelar el pago",
                result: "ERROR",
                events: [KhipuEvent](),
                exitUrl: "",
                failureReason: FailureReasonType.userCanceled.rawValue,
                continueUrl: nil
            ))
            self.dismiss(animated: true)
        }

        let cancelAction = UIAlertAction(title: "No, continuar pagando", style: .cancel) { _ in
            actionSheetController.dismiss(animated: true)
        }

        actionSheetController.addAction(abort)
        actionSheetController.addAction(cancelAction)

        present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        completitionHandler!(KhipuResult(
            operationId: self.operationId,
            exitTitle: "Pago no realizado",
            exitMessage: "Has decidido cancelar el pago",
            result: "ERROR",
            events: [KhipuEvent](),
            exitUrl: "",
            failureReason: FailureReasonType.userCanceled.rawValue,
            continueUrl: nil
        ))
        dismiss(animated: true)
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        do {
            guard let filePath = KhipuClientBundleHelper.podBundle!.path(forResource: "khipuClient", ofType: "html")
            else {
                print ("File reading error")
                return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }

    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            print("WebviewLog: \(message.body)")
        } else if (message.name == "resultHandler") {
            let jsonString = message.body as! String
            let decoder = JSONDecoder()
            do {
                let data = Data(jsonString.utf8)
                result = try decoder.decode(KhipuResult.self, from: data) as KhipuResult
            } catch {
                print(error)
            }
        } else if (message.name == "closeHandler") {
            if (!closed) {
                closed = true
                if(result != nil && completitionHandler != nil) {
                    completitionHandler!(result!)
                }
                dismiss(animated: true)
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        startOperation()

    }
    
    func startOperation() {
        webView.evaluateJavaScript("typeof Khipu != \"undefined\"") { (result, error) in
            if(error == nil && result != nil) {
                let resultString = "\(result!)"
                if (resultString == "1") {
                    let command = String(format: "startOperation('%@', '%@', %@, '%@')",
                                         self.operationId,
                                         self.options.locale ?? "es_CL",
                                         self.options.skipExitPage ? "true" : "false",
                                         self.options.colors?.lightPrimary ?? "undefined"
                                        )
                    print(command)
                    self.webView.evaluateJavaScript(command)
                }
            }
        }
    }
    
}
