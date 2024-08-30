import Foundation
import SwiftUI


class HostingControllerContainer {
    weak var hostingController: UIViewController?    // << wraps reference
}

public class KhipuLauncher {
    public init() {
    }
    
    
    public static func launch(presenter: UIViewController, operationId: String, options: KhipuOptions, onComplete: ((KhipuResult) -> Void)? = nil) -> Void {
        var view: UIViewController
        
        if #available(iOS 15.0.0, *) {
            let hostingControllerContainer = HostingControllerContainer()
            
            let khipuView = KhipuView(
                operationId: operationId,
                options: options,
                onComplete: onComplete,
                hostingControllerContainer: hostingControllerContainer
            )
            view = UIHostingController(rootView: khipuView)
            hostingControllerContainer.hostingController = view
            
            if(options.theme == .dark) {
                view.overrideUserInterfaceStyle = .dark
            } else if (options.theme == .light) {
                view.overrideUserInterfaceStyle = .light
            }
            
        } else {
            view = KhipuWebView(
                operationId: operationId,
                options: options,
                onComplete: onComplete)
        }
        view.modalPresentationStyle = .overFullScreen
        presenter.present(view, animated: true)
    }
    
    public static func launch(operationId: String, options: KhipuOptions, onComplete: ((KhipuResult) -> Void)? = nil) -> Void {
        guard let presenter = getVisibleViewController() else {
            if(onComplete != nil) {
                onComplete!(KhipuResult(operationId: operationId, exitTitle: "Unable to get the visible view controller", exitMessage: "Unable to get the visible view controller", result: "ERROR", events: [], exitUrl: nil, failureReason: nil, continueUrl: nil))
            }
            return
        }
        launch(presenter: presenter, operationId: operationId, options: options, onComplete: onComplete)
    }
    
    
    private static func getVisibleViewController(_ rootViewController: UIViewController? = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController) -> UIViewController? {
        if let navigationController = rootViewController as? UINavigationController {
            return getVisibleViewController(navigationController.visibleViewController)
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return getVisibleViewController(selected)
            }
        }
        
        if let presentedViewController = rootViewController?.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        return rootViewController
    }
    
}
