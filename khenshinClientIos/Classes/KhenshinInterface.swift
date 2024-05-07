//
//  KhenshinInterface.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 05-03-24.
//

import Foundation
import APNGKit
import SwiftUI

public class KhenshinInterface {
    public init() {
    }
    
    public func getKhenshinViewController(context: UINavigationController,operationId: String, options: KhenshinOptions, onComplete: ((KhenshinResult) -> Void)? = nil) -> UIViewController {
        if #available(iOS 15.0.0, *) {
            
            return UIHostingController(rootView: KhenshinView(
                operationId: operationId,
                options: options,
                onComplete: onComplete,
                dismiss: {
                    context.presentedViewController?.dismiss(animated: true)
                }))
        }
        else {
            return KhenshinWebView(operationId: operationId)
        }
        
    }
    
}
