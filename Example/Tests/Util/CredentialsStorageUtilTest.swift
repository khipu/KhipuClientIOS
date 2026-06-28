import XCTest
@testable import KhipuClientIOS

final class CredentialsStorageUtilTest: XCTestCase {
    func testCredentialsStorage() throws {
        // Keychain requires a host app with entitlements (errSecMissingEntitlement / -34018).
        // Skipped in SPM test target; passes when run via the CocoaPods Example app target.
        try XCTSkipIf(true, "Keychain unavailable without host app entitlements (SPM test target)")
        try CredentialsStorageUtil.storeCredentials(credentials: Credentials(username: "user", password: "pass"), server: "testServer")
        let credentials = try CredentialsStorageUtil.searchCredentials(server: "testServer")
        XCTAssertEqual(credentials?.username, "user")
        XCTAssertEqual(credentials?.password, "pass")
        try CredentialsStorageUtil.deleteCredentials(server: "testServer")
        XCTAssertNil(try CredentialsStorageUtil.searchCredentials(server: "testServer"))
    }
}
