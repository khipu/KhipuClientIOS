//
//  BundleHelper.swift
//  KhipuClientIOS
//
//  Created by Emilio Davis on 01-06-24.
//

import Foundation

public class KhipuClientBundleHelper {
    
    private static let podFramework = Bundle(for: KhipuClientBundleHelper.self)
    
    private static let podBundlePath = KhipuClientBundleHelper.podFramework.path(
        forResource: "KhipuClientIOS",
        ofType: "bundle"
    )
    
    public static let podBundle: Bundle? = {
        guard let podBundlePath = podBundlePath else {
            return nil
        }
        return Bundle(path: podBundlePath)
    }()
}
