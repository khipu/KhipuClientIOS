import Foundation
import SwiftUI


class HostingControllerContainer {
    weak var hostingController: UIViewController?
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
}
