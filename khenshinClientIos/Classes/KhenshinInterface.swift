//
//  KhenshinInterface.swift
//  khenshinClientIos
//
//  Created by Mauricio Castillo on 05-03-24.
//

import Foundation

public struct KhenshinBuilder {
    public init(backendUrl: String? = nil, allowCredentialsSaving: Bool? = nil, principalColor: UIColor? = nil, headerColor: UIColor? = nil) {
        self.backendUrl = backendUrl
        self.allowCredentialsSaving = allowCredentialsSaving
        self.principalColor = principalColor
        self.headerColor = headerColor
    }
    
    public let backendUrl: String?
    public let allowCredentialsSaving: Bool?
    public let principalColor: UIColor?
    public let headerColor: UIColor?
}

public class KhenshinInterface {
    private var backendUrl: String
    private var backendPublicKey: String
    private var allowCredentialsSaving: Bool
    private var principalColor: UIColor
    private var headerColor: UIColor
    
    public init() {
        self.backendUrl = "https://khenshin-ws-oci-scl.khipu.com"
        self.backendPublicKey = "mp4j+M037aSEnCuS/1vr3uruFoeEOm5O1ugB+LLoUyw="
        self.allowCredentialsSaving = true
        self.principalColor = UIColor.white
        self.headerColor = UIColor.white
    }
    
    public func initWithBuilderBlock(builder: KhenshinBuilder) {
        self.backendUrl = builder.backendUrl ?? self.backendUrl
        self.allowCredentialsSaving = builder.allowCredentialsSaving ?? self.allowCredentialsSaving
        self.principalColor = builder.principalColor ?? self.principalColor
        self.headerColor = builder.headerColor ?? self.headerColor
        
    }
    
    public func createView(operationId: String) -> UIViewController {
        let khenshinView = KhenshinView(operationId: operationId,
                                        backendUrl: self.backendUrl,
                                        backendPublicKey: self.backendPublicKey,
                                        allowCredentialsSaving: self.allowCredentialsSaving,
                                        principalColor: self.principalColor,
                                        headerColor: self.headerColor   
        )
        return khenshinView
    }
}
