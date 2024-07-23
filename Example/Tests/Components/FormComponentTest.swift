import XCTest
import SwiftUI
import KhenshinProtocol
@testable import KhipuClientIOS

@available(iOS 15.0, *)
final class FormComponentTest: XCTestCase {
    func testFormComponent() throws {

        let viewModel = KhipuViewModel()
        viewModel.uiState = KhipuUiState(currentForm: MockDataGenerator.createFormRequest())
        
        let view = FormComponent(formRequest: MockDataGenerator.createFormRequest(), viewModel: viewModel).environmentObject(ThemeManager())
        
        let inspectView = try view.inspect()
        let titles = inspectView.findAll(FormTitle.self)
        let texts = inspectView.findAll(SimpleTextField.self)
        
        XCTAssertEqual(titles.count, 1)
        XCTAssertEqual(texts.count, 2)
        XCTAssertThrowsError(try inspectView.find(DataTableField.self))
    }
    
    
    
    func testDrawComponentReturnsExpectedComponent() throws {

        let submitFunction: () -> Void = {}
        let getFunction: () -> [String: String] = { ["key":"value"]}
        let setFunction: ([String: String]) -> Void = { param in }
        
        let view = DrawComponent(
            item:MockDataGenerator.createDataTableFormItem(
                id: "item1",
                label: "item1",
                dataTable: DataTable(
                    rows: [
                        DataTableRow(cells: [
                            DataTableCell(backgroundColor: nil, fontSize: nil, fontWeight: nil, foregroundColor: nil, text: "Cell 1", url: nil)
                        ])
                    ],
                    rowSeparator: nil
                )
            ),
            hasNextField: false,
            formValues: Binding(get: getFunction, set: setFunction),
            submitFunction: submitFunction,
            viewModel: KhipuViewModel())
        .environmentObject(ThemeManager())
        
        
        let view2 = DrawComponent(
            item: MockDataGenerator.createOtpFormItem(id: "item1", label: "Type your DIGIPASS with numbers", length: 4,hint: "Give me the answer", number: true),
            hasNextField: false,
            formValues: Binding(get: getFunction, set: setFunction),
            submitFunction: submitFunction,
            viewModel: KhipuViewModel())
        .environmentObject(ThemeManager())
        
        let inspectView = try view.inspect()
        let inspectView2 = try view2.inspect()
        
        XCTAssertNoThrow(try inspectView.find(DataTableField.self))
        XCTAssertThrowsError(try inspectView.find(OtpField.self))
        
        XCTAssertNoThrow(try inspectView2.find(OtpField.self))
        XCTAssertThrowsError(try inspectView2.find(DataTableField.self))
    }
}
