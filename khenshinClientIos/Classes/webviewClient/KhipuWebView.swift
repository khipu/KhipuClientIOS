import UIKit
import WebKit


public class KhipuWebView: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var operationId: String
    
    public init(operationId: String) {
        self.operationId = operationId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }


    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://js.khipu.com/?paymentId="+operationId)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
