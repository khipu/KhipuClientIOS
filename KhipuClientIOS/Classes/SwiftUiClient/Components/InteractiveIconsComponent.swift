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
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        let khipuUiState = khipuViewModel.uiState
        let completeMessage = "\(khipuUiState.translator.t("page.operationMustContinue.share.link.body")) \(khipuUiState.operationInfo?.urls?.info ?? "")"
        let bundle = Bundle(identifier: KhipuConstants.KHIPU_BUNDLE_IDENTIFIER)
        
        HStack {
            let actions = [
                IconAction(icon: "whatsapp", uri: "https://wa.me/?text=\(completeMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")", descriptionId: "desc_whatsapp"),
                IconAction(icon: "email", uri: "mailto:", descriptionId: "desc_email"/*, intent: {
                    let intent = UIActivityViewController(activityItems: [khipuUiState.translator.t("page.operationMustContinue.share.link.title"), completeMessage], applicationActivities: nil)
                    return intent
                }()*/),
                IconAction(icon: "telegram", uri: "https://t.me/share/url?url=\(completeMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")", descriptionId: "desc_telegram")
            ]
            
            ForEach(actions, id: \.uri) { action in
                Link(destination: URL(string: action.uri)!) {
                    Image(action.icon, bundle: bundle)
                        .resizable()
                        .frame(width: themeManager.selectedTheme.dimens.large, height: themeManager.selectedTheme.dimens.large)
                        .padding(themeManager.selectedTheme.dimens.verySmall)
                }
            }
        }
        
    }
}

struct IconAction {
    let icon: String
    let uri: String
    let descriptionId: String
}
