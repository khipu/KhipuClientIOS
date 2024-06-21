
import Foundation
import SwiftUI

@available(iOS 15.0, *)
extension CustomKeyboard {
    static var rutKeyboard: CustomKeyboard {
        CustomKeyboardBuilder { textDocumentProxy, submit, playSystemFeedback in
            HStack {
                VStack {
                    LabeledButton(text: "1", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "4", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "7", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "K", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    LabeledButton(text: "2", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "5", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "8", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "0", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    LabeledButton(text: "3", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "6", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    LabeledButton(text: "9", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    ImageButton(imageName: "delete.left", textDocumentProxy: textDocumentProxy, playSystemFeedback: playSystemFeedback)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.all, 6)
            .padding(.bottom, 36)
        }
    }
}
