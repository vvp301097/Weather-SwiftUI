//
//  HomeViewModel.swift
//  Weather_SwiftUI
//
//  Created by Phat on 19/04/2024.
//

import Foundation
import CoreLocation
import Combine
import UIKit

class HomeViewModel: ObservableObject {
    
    
    let apiService = ApiService()
    let locationManager = LocationManager()
    var subcription = Set<AnyCancellable>()
    @Published var isAuthorizedPermission: Bool = false
    @Published var weatherInfo: LocationWeather?
    
    
    init() {
        locationManager.$locationStatus
            .map { status in
                [CLAuthorizationStatus.authorizedAlways, CLAuthorizationStatus.authorizedWhenInUse].contains(status)
                
            }
            .assign(to: &$isAuthorizedPermission)
    }
    
    func getCurrentLocationInfo() {
        locationManager.getCurrentLocation()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .flatMap { location in
                self.apiService.getLocationKey(at: location.coordinate)
            }
            .flatMap { location in
                Publishers.Zip(Just(location).setFailureType(to: Error.self), self.apiService.currentWeather(for: location.key))
                
            }
            .map { (location, weather) in
                LocationWeather(weather: weather, location: location)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
//                print(error)
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { locationWeather in
                self.weatherInfo = locationWeather
                print(locationWeather)
            }
            .store(in: &subcription)


    }
}
