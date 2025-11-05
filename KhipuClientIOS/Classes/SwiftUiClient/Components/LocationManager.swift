import Foundation
import CoreLocation

@available(iOS 13.0, *)
class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var viewModel: KhipuViewModel
    
    init(viewModel: KhipuViewModel) {
        self.viewModel = viewModel
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getCurrentAuthStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        viewModel.handleLocationUpdate(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        viewModel.handleLocationError(error)
    }
    
    @MainActor
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        viewModel.handleAuthStatusChange(getCurrentAuthStatus())
    }
    
    // For iOS 13 support
    @MainActor
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        viewModel.handleAuthStatusChange(status)
    }
}
