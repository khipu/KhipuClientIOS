import Foundation
import UIKit


func DarwinVersion() -> String {
    var sysinfo = utsname()
    uname(&sysinfo)
    let dv = String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    return "Darwin/\(dv)"
}

func CFNetworkVersion() -> String {
    let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary!
    let version = dictionary?["CFBundleShortVersionString"] as! String
    return "CFNetwork/\(version)"
}


func deviceVersion() -> String {
    let currentDevice = UIDevice.current
    return "\(currentDevice.systemName)/\(currentDevice.systemVersion)"
}

func deviceName() -> String {
    var sysinfo = utsname()
    uname(&sysinfo)
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

func appName() -> String {
    guard let dictionary = Bundle.main.infoDictionary else {
        return ""
    }
    return dictionary["CFBundleDisplayName"] as? String ?? dictionary["CFBundleName"] as? String ?? "NoAppName"
}

func appVersion() -> String {
    guard let dictionary = Bundle.main.infoDictionary else {
        return ""
    }
    return dictionary["CFBundleShortVersionString"] as? String ?? dictionary["CFBundleVersion"] as? String ?? "NoAppName"
}



func UAString() -> String {
    return "\(appName())/\(appVersion()) \(deviceName()) \(deviceVersion()) \(CFNetworkVersion()) \(DarwinVersion())"
}
