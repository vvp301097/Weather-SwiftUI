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
    
    
    private let apiService = ApiService()
    private let locationManager = LocationManager()
    private var subcription = Set<AnyCancellable>()
//    @Published var isAuthorizedPermission: Bool = false
//    @Published var weatherInfo: LocationWeather?
    @Published var weather: Weather?
    @Published var location: Location?
    private var currentLocationSubject = PassthroughSubject<Void, Never>()
//    init() {
//        locationManager.$locationStatus
//            .map { status in
//                [CLAuthorizationStatus.authorizedAlways, CLAuthorizationStatus.authorizedWhenInUse].contains(status)
//
//            }
//            .assign(to: &$isAuthorizedPermission)
//    }
    
    func getCurrentWeather() {
        currentLocationSubject.send()
    }
    
    private lazy var geoInput: AnyPublisher<CLLocation, Never> =  {
        currentLocationSubject.flatMap { _ in
            self.locationManager.getCurrentLocation()
        }
        .eraseToAnyPublisher()
    } ()
    
    private lazy var geoSearch: AnyPublisher<Location, Error> = {
        geoInput
            .subscribe(on: DispatchQueue.global())
            .flatMap { location in
                self.apiService.getLocationKey(at: location.coordinate)
            }
            .share()
            .eraseToAnyPublisher()
    } ()
    
    
    
    init() {
        
        geoSearch
        
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { location in
                self.location = location
            }

            .store(in: &subcription)
        
        
         geoSearch
            .flatMap { location in
                self.getWeather(at: location.key)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { weather in
                self.weather = weather
            }
            .store(in: &subcription)
            
            
    }
    
//    func getLocationInfo() async {
//
//            locationManager.getCurrentLocation()
//                .flatMap { location in
//                    self.apiService.getLocationKey(at: location.coordinate)
//                }
//                .receive(on: DispatchQueue.main)
//                .sink { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        print(error)
//                    }
//                } receiveValue: { location in
//                    self.location = location
//                }
//                .store(in: &subcription)
//
//
//    }

    func getWeather(at locationKey: String) -> AnyPublisher<Weather, Error> {
        Publishers.Zip(apiService.currentWeather(for: locationKey), apiService.getHourlyWeather(for: locationKey))
            .subscribe(on: DispatchQueue.global())
            .map { (weather, hourly) -> Weather in
                var result = weather
                result.hourlyWeather = hourly
                return result
            }
            .eraseToAnyPublisher()
        
    }
    
    func getHourFromEpochTime(epochTime: Double) -> String {
        let date = Date(timeIntervalSince1970: epochTime)
        // Create DateFormatter
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current  // Adjust to the desired time zone
        formatter.dateFormat = "hh a"  // "HH" for 24-hour format, "hh" for 12-hour format with AM/PM use "hh a"
        let hourText = formatter.string(from: date)
        return hourText
    }
    
    func getDataForHourly(hourlys: [HourlyWeather], weather: Weather) -> [TileWeather] {
        let currentTime = Date().timeIntervalSince1970
        var result = [TileWeather]()
        let firstTimeItem = hourlys.first?.time
        if firstTimeItem != nil, firstTimeItem! > Int(currentTime)  {
            let nowItem =  TileWeather(topText: "Now", icon: weather.icon , posibleRain: "", temperature: "\(Int(weather.temperature.value))", isActive: true)
            result.append(nowItem)
        }
        for (index, hourly) in hourlys.enumerated() {
            if firstTimeItem == nil && index == 0 {
                let item = TileWeather(topText: "Now", icon: hourly.icon , posibleRain: "\(hourly.rainProbability)", temperature: "\(Int(hourly.temperature.value))", isActive: true)
                result.append(item)
            } else {
                let item = TileWeather(topText: getHourFromEpochTime(epochTime: Double(hourly.time)), icon: hourly.icon , posibleRain: "\(hourly.rainProbability)", temperature: "\(Int(hourly.temperature.value))")
                result.append(item)
            }
        }
        
        return result
    }
    
}
