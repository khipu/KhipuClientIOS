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
            Text(viewModel.uiState.translator.t("endToEndEncryption", default: ""))
                .frame(alignment: .center)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 13.0, *)
struct CircularProgressView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var drawingStroke = false
    
    let animation = Animation
        .easeOut(duration: 3)
        .repeatForever(autoreverses: false)
        .delay(0.5)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    themeManager.selectedTheme.colors.surface,
                    lineWidth: themeManager.selectedTheme.dimens.small
                )
            Circle()
                .trim(from: 0, to: drawingStroke ? 1 : 0)
                .stroke(
                    themeManager.selectedTheme.colors.primary,
                    style: StrokeStyle(
                        lineWidth: themeManager.selectedTheme.dimens.small,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(animation, value: drawingStroke)
            
        }
        .onAppear {
            drawingStroke.toggle()
        }
    }
}
