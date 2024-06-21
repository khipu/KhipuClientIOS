import WebKit
import UIKit

enum SVGImageRendererError: Error {
    case onlyOneImageAllowed
}

class SVGImageRenderer: UIViewController, WKNavigationDelegate {
    var url: String?
    var svg: String?
    var width: CGFloat
    var height: CGFloat
    var percentage: CGFloat

    init(url: String?, svg: String?, width: CGFloat, height: CGFloat, percentage: CGFloat) throws {
        guard (url == nil) != (svg == nil) else {
            throw SVGImageRendererError.onlyOneImageAllowed
        }
        self.url = url
        self.svg = svg
        self.width = width
        self.height = height
        self.percentage = percentage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)

        NSLayoutConstraint.activate([
           webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           webView.widthAnchor.constraint(equalToConstant: width),
           webView.heightAnchor.constraint(equalToConstant: height)
        ])

        if svg != nil {
            let htmlString = 
                """
                    <html>
                    <body style="margin: 0; display: flex; justify-content: center; align-items: center; height: 100vh;">
                    \(svg!)
                    </body>
                    </html>
                """
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
        else if url != nil {
            let request = URLRequest(url: URL(string: url!)!)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let resizeScript = """
        var svg = document.querySelector('svg');
        if (svg) {
            svg.style.width = '\(percentage)%';
            svg.style.height = '\(percentage)%';
            svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');
        }
        """
        webView.evaluateJavaScript(resizeScript, completionHandler: nil)
    }
}
