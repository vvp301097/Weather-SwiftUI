//
//  ApiService.swift
//  Weather_SwiftUI
//
//  Created by Phat on 19/04/2024.
//

import Foundation
import Combine
import CoreLocation


protocol ApiServiceInterface {
    
}


class ApiService: ApiServiceInterface {
    private let apiKey = "6zufTebWxBpJMGjxyPos4U7xJsQiktG6"
    let baseURL = URL(string: "http://dataservice.accuweather.com")!
    
    func currentWeather(for locationKey: String) -> AnyPublisher<Weather, Error> {
        buildRequest(pathComponent: "currentconditions/v1/\(locationKey)", params: [("details", "true")])
            .tryMap { data in
                let array = try JSONDecoder().decode([Weather].self, from: data)
                if let weather = array.first {
                    return weather
                } else {
                    throw ApiError.cityNotFound
                }
            }
            .eraseToAnyPublisher()
    }
    
    

//    func currentWeather(at coordinate: CLLocationCoordinate2D) -> AnyPublisher<LocationWeather, Error> {
//        getLocationKey(at: coordinate)
//            .flatMap { location in
//                Publishers.Zip(Just(location).setFailureType(to: Error.self), self.currentWeather(for: location.key))
//            }
//            .map { location, weather in
//                LocationWeather(weather: weather, location: location)
//            }
//            .eraseToAnyPublisher()
//
//
//    }
    
    func getLocationKey(at coordinate: CLLocationCoordinate2D) -> AnyPublisher<Location, Error> {
        buildRequest(pathComponent: "locations/v1/cities/geoposition/search",
                     params: [("q","\(coordinate.latitude),\(coordinate.longitude)")])
            .tryMap { data in
                try JSONDecoder().decode(Location.self, from: data)
            }
            .print()
            .eraseToAnyPublisher()
    }
    
    func getLocationKey(by text: String) -> AnyPublisher<Location, Error> {
        buildRequest(pathComponent: "locations/v1/cities/search",
                     params: [("q",text)])
            .tryMap { data in
                try JSONDecoder().decode(Location.self, from: data)
            }
            .eraseToAnyPublisher()
    }
        
    
    private func buildRequest(method: String = "GET", pathComponent: String, params: [(String, String)]) -> AnyPublisher<Data, Error> {
        let url = baseURL.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        let keyQueryItem = URLQueryItem(name: "apikey", value: apiKey)
        //      let unitsQueryItem = URLQueryItem(name: "units", value: "metric")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        if method == "GET" {
            var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
            queryItems.append(keyQueryItem)
            urlComponents.queryItems = queryItems
        } else {
            urlComponents.queryItems = [keyQueryItem]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        
        request.url = urlComponents.url!
        request.httpMethod = method
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
//        session.dataTaskPublisher(for: request).
        return session.dataTaskPublisher(for: request)
            .print()
            .tryMap{ data, response in
                switch (response as! HTTPURLResponse).statusCode {
                case 200 ..< 300:
                    return data
                case 400 ..< 500:
                    throw ApiError.cityNotFound
                 default:
                    throw ApiError.serverFailure
                 
                }
            }
            .eraseToAnyPublisher()
        

            
//      return session.rx.response(request: request)
//            .map { response, data in
//                switch response.statusCode {
//                case 200 ..< 300:
//                    return data
//                case 400 ..< 500:
//                throw ApiError.cityNotFound
//                 default:
//                   throw ApiError.serverFailure
//
//                }
//            }
        
    }
}
enum ApiError: Error {
  case cityNotFound
  case serverFailure
}
