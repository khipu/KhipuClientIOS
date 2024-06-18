import XCTest
import SwiftUI
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FormComponentTest: XCTestCase {
    func testFormComponent() throws {
        let formItem1 = try! FormItem(
         """
             {
               "id": "username",
               "label": "Username",
               "type": "\(FormItemTypes.text.rawValue)",
               "hint": "Enter your username",
               "placeHolder": "Ej: Username"
             }
         """
        )
        let formItem2 = try! FormItem(
         """
             {
               "id": "password",
               "label": "Password",
               "secure": true,
               "type": "\(FormItemTypes.text.rawValue)",
               "hint": "Enter your password"
             }
         """
        )
        let request = FormRequest(
            alternativeAction: nil,
            continueLabel: "Continue",
            errorMessage: "error message",
            id: "id",
            info: "This is an info alert",
            items: [formItem1, formItem2],
            pageTitle: "Page Title",
            progress: Progress(current: 1, total: 2),
            rememberValues: true,
            termsURL: "",
            timeout: 300,
            title: "Login",
            type: MessageType.formRequest
        )
        let viewModel = KhipuViewModel()
        viewModel.uiState = KhipuUiState(currentForm: request)
        
        let view = FormComponent(formRequest: request, viewModel: viewModel).environmentObject(ThemeManager())
        
        let inspectView = try view.inspect()
        let titles = inspectView.findAll(FormTitle.self)
        let texts = inspectView.findAll(KhipuTextField.self)
        
        XCTAssertEqual(titles.count, 1)
        XCTAssertEqual(texts.count, 2)
        XCTAssertThrowsError(try inspectView.find(KhipuDataTableField.self))
    }
    
    func testDrawComponentReturnsExpectedComponent() throws {
        let formItem = try! FormItem(
         """
           {
            "id": "item1",
            "label": "item1",
            "type": "\(FormItemTypes.dataTable.rawValue)",
            "dataTable": {"rows":[{"cells":[{"text":"Cell 1"}]}], "rowSeparator":{}}
           }
         """
        )
        let formItem1 = try! FormItem(
         """
             {
               "id": "item1",
               "label": "Type your DIGIPASS with numbers",
               "length": 4,
               "type": "\(FormItemTypes.otp.rawValue)",
               "hint": "Give me the answer",
               "number": false,
             }
         """
        )
        let submitFunction: () -> Void = {}
        let getFunction: () -> [String: String] = { ["key":"value"]}
        let setFunction: ([String: String]) -> Void = { param in }
        
        let view = DrawComponent(
            item: formItem,
            hasNextField: false,
            formValues: Binding(get: getFunction, set: setFunction),
            submitFunction: submitFunction,
            viewModel: KhipuViewModel())
        .environmentObject(ThemeManager())
        
        
        let view2 = DrawComponent(
            item: formItem1,
            hasNextField: false,
            formValues: Binding(get: getFunction, set: setFunction),
            submitFunction: submitFunction,
            viewModel: KhipuViewModel())
        .environmentObject(ThemeManager())
        

        let inspectView = try view.inspect()
        let inspectView2 = try view2.inspect()
        
        XCTAssertNoThrow(try inspectView.find(KhipuDataTableField.self))
        XCTAssertThrowsError(try inspectView.find(KhipuOtpField.self))
        
        XCTAssertNoThrow(try inspectView2.find(KhipuOtpField.self))
        XCTAssertThrowsError(try inspectView2.find(KhipuDataTableField.self))
    }
}
