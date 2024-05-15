import SwiftUI

@available(iOS 15.0, *)
struct FormWarning: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
                .frame(width: Dimens.medium)
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: Dimens.large, height: Dimens.large)
                .foregroundColor(Color(red: 237/255, green: 108/255, blue: 2/255))
            Text(text)
                .padding(.all, Dimens.medium)
                .foregroundColor(Color.black)
                .font(.system(size: 16, weight: .regular))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .border(Color(red: 237/255, green: 108/255, blue: 2/255), width: 1)
        .cornerRadius(8)
    }
}
