import XCTest
@testable import KhipuClientIOS

/// Regression guards for IKW-1234.
///
/// Every socket handler used to read its frame with `data.first as! String` and
/// `data[1] as! String`, then force-unwrap the result of a decryption declared
/// `-> String?`. A failed force-unwrap in Swift is a trap, not an `Error`, so the
/// `do/catch` around the deserialization never covered any of it: a malformed or
/// undecryptable frame killed the merchant's app.
///
/// Reaching the assertions is the point — a force-cast or force-unwrap aborts the
/// process, so these tests cannot complete while one is present.
@available(iOS 13.0, *)
final class SocketPayloadDecodingTest: XCTestCase {

    // MARK: - Frame shape

    func testWellFormedFrameYieldsBothFields() {
        let fields = KhipuSocketIOClient.payloadFields(["cipher", "mid-1"])
        XCTAssertEqual(fields?.cipherText, "cipher")
        XCTAssertEqual(fields?.mid, "mid-1")
    }

    func testEmptyFrameIsRejectedInsteadOfTrapping() {
        XCTAssertNil(KhipuSocketIOClient.payloadFields([]))
    }

    func testNonStringPayloadIsRejectedInsteadOfTrapping() {
        XCTAssertNil(KhipuSocketIOClient.payloadFields([42]))
        XCTAssertNil(KhipuSocketIOClient.payloadFields([["unexpected": "shape"]]))
    }

    /// `data[1]` was indexed without checking the count. That is a different failure
    /// from a failed cast — it happens before any error handling and cannot be caught.
    func testSingleElementFrameDoesNotIndexOutOfRange() {
        let fields = KhipuSocketIOClient.payloadFields(["cipher"])
        XCTAssertEqual(fields?.cipherText, "cipher")
        XCTAssertEqual(fields?.mid, "", "a missing mid must degrade to empty, not crash")
    }

    func testNonStringMidDegradesToEmpty() {
        let fields = KhipuSocketIOClient.payloadFields(["cipher", 7])
        XCTAssertEqual(fields?.cipherText, "cipher")
        XCTAssertEqual(fields?.mid, "")
    }

    // MARK: - Decryption preconditions

    /// `SecureMessage._decrypt` splits on "." and reads `dataParts[1]` without checking the
    /// count, so a ciphertext with no "." traps with "Index out of range" *inside the
    /// dependency* — a `guard let` on its result cannot help, because it never returns.
    ///
    /// Confirmed empirically while writing these tests: calling
    /// `decrypt(cipherText: "not-a-valid-ciphertext", senderPublicKey: "not-a-valid-key")`
    /// aborts the process. That is why this suite checks the shape guard instead of calling
    /// `decrypt` with garbage — the call itself would kill the test run.
    func testShapelessCiphertextIsRefusedBeforeReachingDecrypt() {
        XCTAssertFalse(KhipuSocketIOClient.hasDecryptableShape("not-a-valid-ciphertext"))
        XCTAssertFalse(KhipuSocketIOClient.hasDecryptableShape(""))
        XCTAssertFalse(KhipuSocketIOClient.hasDecryptableShape("onlyonepart"))
    }

    func testWellShapedCiphertextIsAllowedThrough() {
        XCTAssertTrue(KhipuSocketIOClient.hasDecryptableShape("payload.symmetrickey"))
        XCTAssertTrue(KhipuSocketIOClient.hasDecryptableShape("a.b.c"))
    }
}
