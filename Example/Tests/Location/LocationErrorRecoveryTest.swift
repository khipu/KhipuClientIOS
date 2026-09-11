import XCTest
import CoreLocation
@testable import KhipuClientIOS

/// Regression guard for IKW-1241.
///
/// `handleLocationError` used to have an empty body. `requestLocation()` sets
/// `geolocationRequested = true` to show the spinner, and nothing ever turned it back
/// off when CoreLocation failed: `handleAuthStatusChange` does nothing for
/// `.notDetermined`, and every place that clears the flag is a `.denied` or
/// `.restricted` route. The payment stayed on the progress screen with no way out.
@available(iOS 15.0, *)
@MainActor
final class LocationErrorRecoveryTest: XCTestCase {

    private func locationFailure() -> Error {
        NSError(domain: kCLErrorDomain, code: CLError.Code.locationUnknown.rawValue)
    }

    /// The spinner is driven by `geolocationRequested`. If a failure leaves it on, the
    /// operation hangs — which is exactly what this ticket was about.
    func testLocationFailureClearsTheSpinnerFlag() {
        let viewModel = KhipuViewModel()
        viewModel.uiState.geolocationRequested = true

        viewModel.handleLocationError(locationFailure())

        XCTAssertFalse(viewModel.uiState.geolocationRequested,
                       "a CoreLocation failure must not leave the progress spinner armed")
    }

    /// `LocationAccessRequestComponent` checks `geolocationAcquired` first and renders the
    /// progress view, meaning "the geolocation step is resolved, waiting on the server".
    /// Without this the UI falls through to the permission branches again.
    func testLocationFailureMarksTheGeolocationStepResolved() {
        let viewModel = KhipuViewModel()
        viewModel.uiState.geolocationAcquired = false

        viewModel.handleLocationError(locationFailure())

        XCTAssertTrue(viewModel.uiState.geolocationAcquired,
                      "after answering the server the geolocation step must not be pending")
    }

    /// Reaching the assertion is the assertion: with no socket client wired up, the
    /// response send path must degrade quietly rather than trap. It used to do
    /// `try response.jsonString()!`, where the `try` covers the throw but not the unwrap.
    func testLocationFailureDoesNotTrapWithoutASocketClient() {
        let viewModel = KhipuViewModel()
        viewModel.handleLocationError(locationFailure())
        XCTAssertTrue(true, "handleLocationError must return, never trap")
    }
}
