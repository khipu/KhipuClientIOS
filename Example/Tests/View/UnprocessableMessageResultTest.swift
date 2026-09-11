import XCTest
import SwiftUI
@testable import KhipuClientIOS
@testable import KhenshinProtocol

/// Regression guards for IKW-1245.
///
/// IKW-1234 made `finishOperationWithoutDetail` end the operation when a terminal message
/// cannot be read. That was right, but it left every `operation*` object nil — which is also
/// what a genuine cancellation looks like — so `buildResult` fell into the cancellation
/// branch and told the merchant `failureReason: "userCanceled"`.
///
/// A decryption or deserialization failure is not a payer abandoning the payment. A merchant
/// branching on `userCanceled` would count one as the other.
@available(iOS 15.0, *)
final class UnprocessableMessageResultTest: XCTestCase {

    private func makeView() -> KhipuView {
        KhipuView(
            operationId: "test-op-123",
            options: KhipuOptions.Builder().build(),
            onComplete: nil,
            hostingControllerContainer: HostingControllerContainer()
        )
    }

    /// The defect itself.
    func testUnreadableTerminalMessageIsNotReportedAsUserCanceled() {
        var state = KhipuUiState()
        state.unprocessableMessageType = MessageType.operationFailure.rawValue

        let result = makeView().buildResult(state)

        XCTAssertNotEqual(result.failureReason, FailureReasonType.userCanceled.rawValue,
                          "an unreadable message must not be attributed to the payer")
        XCTAssertNil(result.failureReason,
                     "nil is the only true answer: we do not know why it failed")
        XCTAssertEqual(result.result, "ERROR")
    }

    /// No invented copy for an internal failure.
    func testUnreadableTerminalMessageCarriesNoExitCopy() {
        var state = KhipuUiState()
        state.unprocessableMessageType = MessageType.operationSuccess.rawValue

        let result = makeView().buildResult(state)

        XCTAssertEqual(result.exitTitle, "")
        XCTAssertEqual(result.exitMessage, "")
    }

    /// Ordering guard: the new branch must sit after the four that carry detail, so a message
    /// that did deserialize still wins. Putting it first would discard real results.
    func testADeserializedMessageWinsOverTheUnprocessableMark() {
        var state = KhipuUiState()
        state.unprocessableMessageType = MessageType.operationFailure.rawValue
        state.operationFailure = OperationFailure(
            type: .operationFailure, body: "body", events: nil, exitURL: nil,
            operationID: "op-1", resultMessage: nil, title: "title",
            reason: FailureReasonType.formTimeout
        )

        let result = makeView().buildResult(state)

        XCTAssertEqual(result.failureReason, FailureReasonType.formTimeout.rawValue,
                       "a message that deserialized must keep its own reason")
        XCTAssertEqual(result.exitTitle, "title")
    }

    /// A genuine cancellation must still report `userCanceled`: the close button and the
    /// user-cancel socket path both reach the same fallback and are unaffected by this fix.
    func testGenuineCancellationStillReportsUserCanceled() {
        let result = makeView().buildResult(KhipuUiState())

        XCTAssertEqual(result.failureReason, FailureReasonType.userCanceled.rawValue,
                       "cancellation must keep its own cause")
    }
}
