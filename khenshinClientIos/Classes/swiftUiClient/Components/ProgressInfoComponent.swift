import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct ProgressInfoComponent: View {
    var message: String
    var modifier: EdgeInsets = EdgeInsets()
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .padding(.top, Dimens.huge)
                    .padding(.bottom, Dimens.large)
                Text(message)
                    .font(.system(size: Dimens.large))
                    .padding(.horizontal, Dimens.moderatelyLarge)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, Dimens.moderatelyLarge)
    }
}
