//
//  EndToEndEncryption.swift
//  KhipuClientIOS
//
//  Created by Mauricio Castillo on 29-05-24.
//

import SwiftUI

@available(iOS 13.0, *)
struct EndToEndEncryption: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject public var viewModel: KhipuViewModel
    
    var body: some View {
        VStack {
            CircularProgressView()
                .frame(width: themeManager.selectedTheme.dimens.extraLarge,
                       height: themeManager.selectedTheme.dimens.extraLarge,
                       alignment: .center)
                .padding([.top], themeManager.selectedTheme.dimens.massive)
            Text(viewModel.uiState.translator.t("default.end.to.end.encryption", default: ""))
                .frame(alignment: .center)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


@available(iOS 13.0, *)
struct EndToEndEncryption_Previews: PreviewProvider {
    static var previews: some View {
        EndToEndEncryption(viewModel: KhipuViewModel())
            .environmentObject(ThemeManager())
            .padding()
    }
}
