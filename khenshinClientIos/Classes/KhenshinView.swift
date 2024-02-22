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
        switch item.type {
        case FormItemTypes.text:
            if (item.email!) {
                    return nil//EmailField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), title: item.title ?? "")
                }
                return nil//TextField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item) //questionAsText(formItem, props.bank))
           case FormItemTypes.rut:
               return RutField(frame: CGRect(x: 0, y: 0, width: 300, height: 400),formItem:item)
           case FormItemTypes.list:
               return nil//questionAsRadioGroup(formItem)
           case FormItemTypes.groupedList:
               return nil//BankSelectField(frame: CGRect(x: 0, y: 0, width: 300, height: 400), item: item, continueLabel: "Continue")
           case FormItemTypes.coordinates:
               return nil//questionAsCoordinates(formItem, props.errorMessage)
           case FormItemTypes.imageChallenge:
               return nil//questionAsImageChallenge(formItem)
           default:
               return nil
        }
    }
}
