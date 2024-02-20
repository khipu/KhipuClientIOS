import UIKit
import KhenshinProtocol

public class KhenshinView {

    private let containerView: UIView
    private let overlayView: UIView


    public init(containerView: UIView) {
        self.containerView = containerView
        overlayView = UIView(frame: containerView.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(overlayView)
    }


    public func drawProgressInfoComponent(progressInfo: ProgressInfo) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let progressInfoField = ProgressInfoField(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), progressInfo: progressInfo)
        progressInfoField.center = overlayView.center
        overlayView.addSubview(progressInfoField)
    }

    private func drawOperationRequestComponent() {
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
       }
}
