//
//  LocationViewModel.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 02/07/24.
//

import Foundation
import CoreLocation

class LocationViewModel: NSObject, ObservableObject {
    private var locationManager: CLLocationManager?
    @Published var altitude: Double = 0.0
    @Published var log: String = ""
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
            super.init()
            self.locationManager = locationManager
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            log = "Location authorization not determined"
        case .restricted:
            log = "Location authorization restricted"
        case .denied:
            log = "Location authorization denied"
        case .authorizedAlways:
            manager.requestLocation()
            log = "Location authorization always granted"
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            log = "Location authorization when in use granted"
        @unknown default:
            log = "Unknown authorization status"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { location in
            self.altitude = location.altitude
        }
    }
}
