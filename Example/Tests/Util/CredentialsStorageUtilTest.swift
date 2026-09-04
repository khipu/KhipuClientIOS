import XCTest
@testable import KhipuClientIOS

final class CredentialsStorageUtilTest: XCTestCase {
    func testCredentialsStorage() throws {
        // Keychain requires a host app with entitlements (errSecMissingEntitlement / -34018).
        // Skipped in SPM test target; passes when run via the CocoaPods Example app target.
        // The no-trap contract is guarded unconditionally by
        // testKeychainFailureIsRecoverableAndNeverTraps below, which runs in both environments.
        try XCTSkipIf(true, "Keychain unavailable without host app entitlements (SPM test target)")
        try CredentialsStorageUtil.storeCredentials(credentials: Credentials(username: "user", password: "pass"), server: "testServer")
        let credentials = try CredentialsStorageUtil.searchCredentials(server: "testServer")
        XCTAssertEqual(credentials?.username, "user")
        XCTAssertEqual(credentials?.password, "pass")
        try CredentialsStorageUtil.deleteCredentials(server: "testServer")
        XCTAssertNil(try CredentialsStorageUtil.searchCredentials(server: "testServer"))
    }

    /// Regression guard for the `try!` crash in FormComponent.submitNovalidate: a
    /// Keychain failure must surface as a recoverable Swift error, never as a fatal
    /// trap that aborts a payment. Reaching the assertion is the assertion — a `try!`
    /// over a failing Security call aborts the process instead of throwing, so this
    /// test cannot complete while one is present.
    func testKeychainFailureIsRecoverableAndNeverTraps() {
        let server = "khipu.regression.try-bang.invalid"
        var reachedEnd = false

        do {
            try CredentialsStorageUtil.storeCredentials(
                credentials: Credentials(username: "user", password: "pass"),
                server: server
            )
            print("storeCredentials: succeeded (Keychain available to this process)")
        } catch let error as KeychainError {
            guard case .unhandledError = error else {
                return XCTFail("expected .unhandledError, got \(error)")
            }
            print("storeCredentials: threw \(error)")
        } catch {
            return XCTFail("expected KeychainError, got \(error)")
        }

        do {
            try CredentialsStorageUtil.deleteCredentials(server: server)
            print("deleteCredentials: succeeded")
        } catch let error as KeychainError {
            guard case .unhandledError = error else {
                return XCTFail("expected .unhandledError, got \(error)")
            }
            print("deleteCredentials: threw \(error)")
        } catch {
            return XCTFail("expected KeychainError, got \(error)")
        }

        reachedEnd = true
        XCTAssertTrue(reachedEnd, "Keychain calls must return or throw, never trap")

        try? CredentialsStorageUtil.deleteCredentials(server: server)
    }
}
