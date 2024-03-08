//
//  KhenshinInterface.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 05-03-24.
//

import Foundation

public struct KhenshinBuilder {
    public init(backendUrl: String? = nil,
                allowCredentialsSaving: Bool? = nil,
                principalColor: UIColor? = nil,
                headerColor: UIColor? = nil,
                fullscreen: Bool? = true) {
        self.backendUrl = backendUrl
        self.allowCredentialsSaving = allowCredentialsSaving
        self.principalColor = principalColor
        self.headerColor = headerColor
        self.fullscreen = fullscreen
    }
    
    public let backendUrl: String?
    public let allowCredentialsSaving: Bool?
    public let principalColor: UIColor?
    public let headerColor: UIColor?
    public let fullscreen: Bool?
}

public class KhenshinInterface {
    private var backendUrl: String
    private var backendPublicKey: String
    private var allowCredentialsSaving: Bool
    private var principalColor: UIColor
    private var headerColor: UIColor
    private var mainController: UIViewController?
    private var fullscreen: Bool
    
    public init() {
        self.backendUrl = "https://khenshin-ws.khipu.com"
        self.backendPublicKey = "mp4j+M037aSEnCuS/1vr3uruFoeEOm5O1ugB+LLoUyw="
        self.allowCredentialsSaving = true
        self.principalColor = UIColor.white
        self.headerColor = UIColor.white
        self.fullscreen = true
    }
    
    public func initWithBuilderBlock(builder: KhenshinBuilder) {
        self.backendUrl = builder.backendUrl ?? self.backendUrl
        self.allowCredentialsSaving = builder.allowCredentialsSaving ?? self.allowCredentialsSaving
        self.principalColor = builder.principalColor ?? self.principalColor
        self.headerColor = builder.headerColor ?? self.headerColor
        self.fullscreen = builder.fullscreen ?? self.fullscreen
        
    }
    
    public func createView(operationId: String) -> Void {
        self.mainController = KhenshinView(operationId: operationId,
                                        backendUrl: self.backendUrl,
                                        backendPublicKey: self.backendPublicKey,
                                        allowCredentialsSaving: self.allowCredentialsSaving,
                                        principalColor: self.principalColor,
                                        headerColor: self.headerColor   
        )
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            if(self.fullscreen){
                self.mainController?.modalPresentationStyle = .overFullScreen
            }
            visibleViewController.present(self.mainController!, animated: true, completion: nil)
            
        }
    }
}
