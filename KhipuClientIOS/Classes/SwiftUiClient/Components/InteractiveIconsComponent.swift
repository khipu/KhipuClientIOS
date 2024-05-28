//
//  InteractiveIconsComponent.swift
//  KhipuClientIOS
//
//  Created by Mauricio Castillo on 28-05-24.
//

import SwiftUI

@available(iOS 14.0, *)
struct InteractiveIconsComponent: View {
    @StateObject var khipuViewModel: KhipuViewModel
    
    var body: some View {
        let khipuUiState = khipuViewModel.uiState
        let completeMessage = "\(khipuUiState.translator.t("page.operationMustContinue.share.link.body")) \(khipuUiState.operationInfo?.urls?.info ?? "")"
        
        HStack {
            let actions = [
                IconAction(icon: UIImage(named: "whatsapp")!, uri: "https://wa.me/?text=\(completeMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")", descriptionId: "desc_whatsapp"),
                IconAction(icon: UIImage(named: "email")!, uri: "mailto:", descriptionId: "desc_email"/*, intent: {
                    let intent = UIActivityViewController(activityItems: [khipuUiState.translator.t("page.operationMustContinue.share.link.title"), completeMessage], applicationActivities: nil)
                    return intent
                }()*/),
                IconAction(icon: UIImage(named: "telegram")!, uri: "https://t.me/share/url?url=\(completeMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")", descriptionId: "desc_telegram")
            ]
            
            ForEach(actions, id: \.uri) { action in
                Link(destination: URL(string: action.uri)!) {
                    Image(uiImage: action.icon)
                        .font(.largeTitle)
                }
            }
        }
    }
}

struct IconAction {
    let icon: UIImage
    let uri: String
    let descriptionId: String
}
