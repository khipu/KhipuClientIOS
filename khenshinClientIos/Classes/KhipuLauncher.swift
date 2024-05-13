//
//  KhenshinInterface.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 05-03-24.
//

import Foundation
import SwiftUI

public class KhipuLauncher {
    public init() {
    }
    
    public static func launch(navigationController: UINavigationController, operationId: String, options: KhenshinOptions, onComplete: ((KhenshinResult) -> Void)? = nil) -> Void {
        var view: UIViewController
        if #available(iOS 15.0.0, *) {
            view = UIHostingController(rootView: KhenshinView(
                operationId: operationId,
                options: options,
                onComplete: onComplete,
                dismiss: {
                    navigationController.popViewController(animated: true)
                }))
        } else {
            view = KhenshinWebView(operationId: operationId)
            
        }
        navigationController.show(view, sender: self)
    }
}
