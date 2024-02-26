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
            }
        }
    }

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
    }
}
