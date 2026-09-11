import XCTest
import SwiftUI
import ViewInspector
@testable import KhipuClientIOS

/// Regression guard for IKW-1242.
///
/// Declining the location permission used to end the payment: the three decline routes
/// in `LocationAccessRequestComponent` (lines 24, 40 and 66) all did
/// `uiState.returnToApp = true`, which hands control back to the merchant app.
///
/// Android treats it as optional — its call site passes `geolocationMandatory = false`
/// and the decline path answers with a `GeolocationResponse` carrying null coordinates
/// and no `errorCode`, letting the operation continue. iOS now matches that.
@available(iOS 15.0, *)
@MainActor
final class GeolocationDeclineTest: XCTestCase {

    /// The whole point of the ticket: declining must not end the operation.
    func testDecliningDoesNotAbortThePayment() {
        let viewModel = KhipuViewModel()
        viewModel.uiState.returnToApp = false

        viewModel.declineGeolocation()

        XCTAssertFalse(viewModel.uiState.returnToApp,
                       "declining location must not return to the merchant app")
    }

    /// After answering the server the geolocation step is over, so the UI shows progress
    /// rather than falling back to the permission prompts.
    func testDecliningResolvesTheGeolocationStep() {
        let viewModel = KhipuViewModel()
        viewModel.uiState.geolocationRequested = true
        viewModel.uiState.geolocationAcquired = false

        viewModel.declineGeolocation()

        XCTAssertFalse(viewModel.uiState.geolocationRequested)
        XCTAssertTrue(viewModel.uiState.geolocationAcquired)
    }

    /// Exercises the real decline button instead of the view model method, so that putting
    /// `returnToApp = true` back at the call site fails this test. The unit tests above
    /// would only stop compiling, which is not the same thing.
    func testTappingTheDeclineButtonDoesNotAbortThePayment() throws {
        let translator = MockDataGenerator.createTranslator()
        let viewModel = KhipuViewModel()
        viewModel.uiState.translator = translator
        viewModel.uiState.locationAuthStatus = .denied
        viewModel.uiState.geolocationAcquired = false
        viewModel.uiState.returnToApp = false

        let view = LocationAccessRequestComponent(viewModel: viewModel)
            .environmentObject(ThemeManager())
        let inspected = try view.inspect().view(LocationAccessRequestComponent.self)

        try inspected.find(button: translator.t("geolocation.blocked.button.decline")).tap()

        XCTAssertFalse(viewModel.uiState.returnToApp,
                       "the decline button must not return to the merchant app")
        XCTAssertTrue(viewModel.uiState.geolocationAcquired,
                      "the decline button must resolve the geolocation step")
    }

    /// No coordinates are kept or invented on the decline path. The server is told there
    /// is no location; it is not told a stale one.
    func testDecliningKeepsNoLocation() {
        let viewModel = KhipuViewModel()

        viewModel.declineGeolocation()

        XCTAssertNil(viewModel.uiState.currentLocation,
                     "declining must not leave or send a location behind")
    }
}
