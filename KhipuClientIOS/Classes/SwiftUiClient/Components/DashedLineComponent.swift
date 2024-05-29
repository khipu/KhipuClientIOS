//
//  DashedLineComponent.swift
//  KhipuClientIOS
//
//  Created by Mauricio Castillo on 28-05-24.
//

import SwiftUI

@available(iOS 13.0, *)
struct DashedLine: View {
     var body: some View {
         Line()
           .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
           .frame(height: 1)
    }
}

@available(iOS 13.0, *)
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
