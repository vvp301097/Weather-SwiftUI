//
//  LocationManager.swift
//  Weather_SwiftUI
//
//  Created by Phat on 23/04/2024.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locations: [CLLocation] = []
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }

   
    
    var statusString: String {
//        guard let status = locationStatus else {
//            return "unknown"
//        }
        
        switch locationStatus {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func getCurrentLocation() -> AnyPublisher<CLLocation, Never> {
        let location = $locationStatus
            .filter{$0 == .authorizedAlways || $0 == .authorizedWhenInUse}
            .flatMap { [self] _ in
                self.$locations.compactMap(\.first)
                    .first()
                    .handleEvents (receiveCompletion: { [weak locationManager] _ in
                        locationManager?.stopUpdatingLocation()
                    })
            }
            .eraseToAnyPublisher()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return location
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations = locations
    }
    
    
    
    
}
