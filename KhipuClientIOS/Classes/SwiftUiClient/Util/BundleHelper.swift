import Foundation

import UIKit

public class KhipuClientBundleHelper {

    private static let podFramework = Bundle(for: KhipuClientBundleHelper.self)

    private static let podBundlePath = podFramework.path(
        forResource: "KhipuClientIOS",
        ofType: "bundle"
    )

    public static let podBundle: Bundle? = {
        guard let podBundlePath = podBundlePath else {
            return nil
        }
        return Bundle(path: podBundlePath)
    }()

    public static func image(named imageName: String) -> UIImage? {
        guard let bundle = podBundle else {
            return nil
        }
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }
}
