import SwiftUI
import KhenshinProtocol

@available(iOS 13.0, *)
struct SeparatorField: View {
    var formItem: FormItem
    
    var body: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 1))
            .foregroundColor(Color(hexString: formItem.color ?? "#000"))
            .frame(height: 1)
    }
}

@available(iOS 15.0, *)
struct KhipuSeparatorField_Previews: PreviewProvider {
    static var previews: some View {
        return VStack {
            Text("Separator with color:")
            SeparatorField(formItem: MockDataGenerator.createSeparatorFormItem(id: "item1", color: "#df00b9")).environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
                .padding()
            Text("Separator with no color specified:")
            SeparatorField(formItem: MockDataGenerator.createSeparatorFormItem(id: "item1"))                .environmentObject(ThemeManager())
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
