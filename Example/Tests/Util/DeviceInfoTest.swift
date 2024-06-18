import XCTest
@testable import KhipuClientIOS

final class DeviceInfoTest: XCTestCase {
    func testDarwinVersion() throws {
        let version = DarwinVersion()
        XCTAssertTrue(version.starts(with: "Darwin/"), "The Darwin version string should start with 'Darwin/' Version: \(version)")
        XCTAssertFalse(version.isEmpty, "The Darwin version string should not be empty")
    }

    func testCFNetworkVersion() throws {
        let version = CFNetworkVersion()
        XCTAssertTrue(version.starts(with: "CFNetwork/"), "The CFNetwork version string should start with 'CFNetwork/' Version: \(version)")
        XCTAssertFalse(version.isEmpty, "The CFNetwork version string should not be empty")
    }
    
    func testDeviceVersion() throws {
        let version = deviceVersion()
        XCTAssertFalse(version.isEmpty, "The device version string should not be empty")
        XCTAssertTrue(version.contains("/"), "The device version string should contain a '/' character. Version: \(version)")
    }
    func testDeviceName() throws {
        XCTAssertFalse(deviceName().isEmpty, "The device name should not be empty")
    }

    func testAppName() throws {
        XCTAssertFalse(appName().isEmpty, "The app name should not be empty")
    }

    func testAppVersion() throws {
        XCTAssertFalse(appVersion().isEmpty, "The app version should not be empty")
    }
    
    func testUAString() {
        let uaString = UAString()
        XCTAssertFalse(uaString.isEmpty, "The user agent string should not be empty")
        XCTAssertTrue(uaString.contains(appName()), "The user agent string should contain the app name")
        XCTAssertTrue(uaString.contains(appVersion()), "The user agent string should contain the app version")
        XCTAssertTrue(uaString.contains(deviceName()), "The user agent string should contain the device name")
        XCTAssertTrue(uaString.contains(deviceVersion()), "The user agent string should contain the device version")
        XCTAssertTrue(uaString.contains(CFNetworkVersion()), "The user agent string should contain the CFNetwork version")
        XCTAssertTrue(uaString.contains(DarwinVersion()), "The user agent string should contain the Darwin version")
    }
}
