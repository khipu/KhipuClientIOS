import SwiftUI
import KhenshinProtocol

@available(iOS 13.0, *)
struct SeparatorField: View {
    var formItem: FormItem
    var hasNextField: Bool
    var isValid: (Bool) -> Void
    var returnValue: (String) -> Void
    @State var passwordVisible: Bool = false
    @State var textFieldValue: String = ""
    
    var body: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 1))
            .foregroundColor(Color(hexString: formItem.color ?? "#000"))
            .frame(height: 1)
    }
}

@available(iOS 13.0, *)
struct KhipuSeparatorField_Previews: PreviewProvider {
    static var previews: some View {
        let isValid: (Bool) -> Void = { param in }
        let returnValue: (String) -> Void = { param in }
        let formItem1 = try! FormItem(
         """
           {
            "id": "item1",
            "label": "item1",
            "type": "\(FormItemTypes.separator.rawValue)",
            "color": "#df00b9"
           }
         """
        )
        let formItem2 = try! FormItem(
         """
           {
            "id": "item1",
            "label": "item1",
            "type": "\(FormItemTypes.separator.rawValue)"
           }
         """
        )
        return VStack {
            Text("Separator with color:")
            SeparatorField(formItem: formItem1, hasNextField: false, isValid: isValid, returnValue: returnValue)
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
                .padding()
            Text("Separator with no color specified:")
            SeparatorField(formItem: formItem2, hasNextField: false, isValid: isValid, returnValue: returnValue)
                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
