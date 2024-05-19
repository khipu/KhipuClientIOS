import Foundation
import SwiftUI

public class KhipuLauncher {
    public init() {
    }
    
    public static func launch(navigationController: UINavigationController, operationId: String, options: KhipuOptions, onComplete: ((KhipuResult) -> Void)? = nil) -> Void {
        var view: UIViewController
        
        
        
        if #available(iOS 15.0.0, *) {
            let prevAppearance = navigationController.navigationBar.standardAppearance
            let prevScrollEdgeAppearance = navigationController.navigationBar.scrollEdgeAppearance
            let khenshinView = KhenshinView(
                operationId: operationId,
                options: options,
                onComplete: onComplete,
                dismiss: {
                    navigationController.popViewController(animated: true)
                    navigationController.navigationBar.standardAppearance = prevAppearance
                    navigationController.navigationBar.scrollEdgeAppearance = prevScrollEdgeAppearance
                })
            view = UIHostingController(rootView: khenshinView)
            view.navigationItem.setHidesBackButton(true, animated: false)
            
            if(options.theme == .dark) {
                view.overrideUserInterfaceStyle = .dark
            } else if (options.theme == .light) {
                view.overrideUserInterfaceStyle = .light
            }

            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            //We can not use the automatic color choosing of swiftui at this point, so we have to use the darkTopBarContainer and lightTopBarContainer colors
            if (view.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark) {
                if(options.colors?.darkTopBarContainer != nil) {
                    appearance.backgroundColor = UIColor(hexString: options.colors!.darkTopBarContainer!)
                } else {
                    appearance.backgroundColor = UIColor(Color("darkTopBarContainer", bundle: Bundle(identifier: "org.cocoapods.khenshinClientIos")))
                }
            } else {
                if(options.colors?.lightTopBarContainer != nil) {
                    appearance.backgroundColor = UIColor(hexString: options.colors!.lightTopBarContainer!)
                } else {
                    appearance.backgroundColor = UIColor(Color("lightTopBarContainer", bundle: Bundle(identifier: "org.cocoapods.khenshinClientIos")))
                }
            }

            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance

        } else {
            view = KhenshinWebView(operationId: operationId)
            
        }
        navigationController.show(view, sender: self)
    }
}
