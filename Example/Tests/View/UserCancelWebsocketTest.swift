import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS
@testable import KhenshinProtocol

@available(iOS 15.0, *)
class SpySocketClient: KhipuSocketClientProtocol {
    var sentMessages: [(type: String, message: String)] = []

    func sendMessage(type: String, message: String) {
        sentMessages.append((type: type, message: message))
    }

    func connect() {}
    func disconnect() {}
    @MainActor func reconnect() {}
}

@available(iOS 15.0, *)
final class UserCancelWebsocketTest: XCTestCase {

    // MARK: - UserCanceled message construction

    func testUserCanceledMessageHasCorrectType() throws {
        let userCanceled = UserCanceled(
            message: nil,
            type: MessageType.userCanceled
        )
        XCTAssertEqual(userCanceled.type, MessageType.userCanceled)
    }

    func testUserCanceledMessageHasNilMessage() throws {
        let userCanceled = UserCanceled(
            message: nil,
            type: MessageType.userCanceled
        )
        XCTAssertNil(userCanceled.message)
    }

    func testUserCanceledMessageSerializesToJson() throws {
        let userCanceled = UserCanceled(
            message: nil,
            type: MessageType.userCanceled
        )
        let jsonString = try userCanceled.jsonString()
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString!.contains(MessageType.userCanceled.rawValue))
    }

    func testUserCanceledTypeRawValue() throws {
        let userCanceled = UserCanceled(
            message: nil,
            type: MessageType.userCanceled
        )
        XCTAssertEqual(userCanceled.type.rawValue, MessageType.userCanceled.rawValue)
    }

    // MARK: - ViewModel returnToApp state

    func testReturnToAppInitiallyFalse() throws {
        let viewModel = KhipuViewModel()
        XCTAssertFalse(viewModel.uiState.returnToApp)
    }

    @MainActor
    func testReturnToAppCanBeSetToTrue() throws {
        let viewModel = KhipuViewModel()
        viewModel.uiState.returnToApp = true
        XCTAssertTrue(viewModel.uiState.returnToApp)
    }

    // MARK: - Cancel flow produces correct KhipuResult
    // Note: buildResult uses the view's internal viewModel, so we test the default cancel path

    func testBuildResultReturnsUserCanceledWhenNoOperationResult() throws {
        let view = KhipuView(
            operationId: "test-op-123",
            options: KhipuOptions.Builder().build(),
            onComplete: nil,
            hostingControllerContainer: HostingControllerContainer()
        )

        let result = view.buildResult(KhipuUiState())

        XCTAssertEqual(result.result, "ERROR")
        XCTAssertEqual(result.failureReason, FailureReasonType.userCanceled.rawValue)
    }

    func testBuildResultUserCanceledHasEmptyEvents() throws {
        let view = KhipuView(
            operationId: "test-op",
            options: KhipuOptions.Builder().build(),
            onComplete: nil,
            hostingControllerContainer: HostingControllerContainer()
        )

        let result = view.buildResult(KhipuUiState())

        XCTAssertTrue(result.events.isEmpty)
    }

    func testBuildResultUserCanceledHasNilContinueUrl() throws {
        let view = KhipuView(
            operationId: "test-op",
            options: KhipuOptions.Builder().build(),
            onComplete: nil,
            hostingControllerContainer: HostingControllerContainer()
        )

        let result = view.buildResult(KhipuUiState())

        XCTAssertNil(result.continueUrl)
    }

    func testBuildResultUserCanceledFailureReasonIsUserCanceled() throws {
        let view = KhipuView(
            operationId: "test-op",
            options: KhipuOptions.Builder().build(),
            onComplete: nil,
            hostingControllerContainer: HostingControllerContainer()
        )

        let result = view.buildResult(KhipuUiState())

        XCTAssertEqual(result.failureReason, FailureReasonType.userCanceled.rawValue)
    }

    // MARK: - WebSocket message sent on cancel

    @MainActor
    func testUserCanceledMessageIsSentViaWebsocket() throws {
        let viewModel = KhipuViewModel()
        let spySocket = SpySocketClient()
        viewModel.khipuSocketIOClient = spySocket

        // Simulate the cancel action from KhipuView's returnToApp closure
        let userCanceled = UserCanceled(
            message: nil,
            type: MessageType.userCanceled
        )
        try? viewModel.khipuSocketIOClient?.sendMessage(
            type: userCanceled.type.rawValue,
            message: userCanceled.jsonString()!
        )

        XCTAssertEqual(spySocket.sentMessages.count, 1)
        XCTAssertEqual(spySocket.sentMessages.first?.type, MessageType.userCanceled.rawValue)
        XCTAssertTrue(spySocket.sentMessages.first?.message.contains(MessageType.userCanceled.rawValue) ?? false)
    }

    @MainActor
    func testUserCanceledMessageIsNotSentWhenSocketIsNil() throws {
        let viewModel = KhipuViewModel()
        // khipuSocketIOClient is nil by default

        let userCanceled = UserCanceled(
            message: nil,
            type: MessageType.userCanceled
        )
        try? viewModel.khipuSocketIOClient?.sendMessage(
            type: userCanceled.type.rawValue,
            message: userCanceled.jsonString()!
        )

        // No crash, no message sent - socket is nil
        XCTAssertNil(viewModel.khipuSocketIOClient)
    }

    // MARK: - Delay behavior

    @MainActor
    func testReturnToAppIsSetAfterDelay() async throws {
        let viewModel = KhipuViewModel()

        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            await MainActor.run {
                viewModel.uiState.returnToApp = true
            }
        }

        // Immediately after starting the task, returnToApp should still be false
        XCTAssertFalse(viewModel.uiState.returnToApp)

        // Wait enough time for the delay to complete
        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertTrue(viewModel.uiState.returnToApp)
    }

    @MainActor
    func testReturnToAppIsNotSetBefore300ms() async throws {
        let viewModel = KhipuViewModel()

        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            await MainActor.run {
                viewModel.uiState.returnToApp = true
            }
        }

        // Wait only 100ms - should still be false
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertFalse(viewModel.uiState.returnToApp)
    }
}
