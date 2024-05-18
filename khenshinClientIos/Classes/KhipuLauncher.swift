import Foundation
import SwiftUI

public class KhipuLauncher {
    public init() {
    }
    
    public static func launch(navigationController: UINavigationController, operationId: String, options: KhenshinOptions, onComplete: ((KhipuResult) -> Void)? = nil) -> Void {
        var view: UIViewController
        if #available(iOS 15.0.0, *) {
            let khenshinView = KhenshinView(
                operationId: operationId,
                options: options,
                onComplete: onComplete,
                dismiss: {
                    navigationController.popViewController(animated: true)
                })
            view = UIHostingController(rootView: khenshinView)
            view.navigationItem.setHidesBackButton(true, animated: false)
            if(options.theme == .dark) {
                view.overrideUserInterfaceStyle = .dark
            } else if (options.theme == .light) {
                view.overrideUserInterfaceStyle = .light
            }
        } else {
            view = KhenshinWebView(operationId: operationId)
            
        }
        navigationController.show(view, sender: self)
    }
}
