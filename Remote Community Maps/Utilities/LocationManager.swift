//
//  LocationManager.swift
//  Remote Community Maps
//
//  Created by Benjamin Fox on 13/7/2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Location {
    func distance(from location: CLLocation?) -> CLLocationDistance? {
        guard let location = location else { return nil }
        let targetLocation = CLLocation(latitude: latitude, longitude: longitude)
        return location.distance(from: targetLocation)
    }
}
