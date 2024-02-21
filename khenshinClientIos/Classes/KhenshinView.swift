import UIKit
import KhenshinProtocol

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
        switch item.id {
        case "email":
            return EmailField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), title: item.title ?? "")
        case "bank":
            return BankSelectField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), item: item, continueLabel: "Continue")

        default:
            return nil
        }
    }
}
