import XCTest
@testable import KhipuClientIOS

final class CredentialsStorageUtilTest: XCTestCase {
    func testCredentialsStorage() throws {
        try CredentialsStorageUtil.storeCredentials(credentials: Credentials(username: "user", password: "pass"), server: "testServer")
        let credentials = try CredentialsStorageUtil.searchCredentials(server: "testServer")
        XCTAssertEqual(credentials?.username, "user")
        XCTAssertEqual(credentials?.password, "pass")
        try CredentialsStorageUtil.deleteCredentials(server: "testServer")
        XCTAssertNil(try CredentialsStorageUtil.searchCredentials(server: "testServer"))
    }
}
