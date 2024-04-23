//
//  Location.swift
//  Weather_SwiftUI
//
//  Created by Phat on 19/04/2024.
//

import Foundation
import CoreLocation
struct Location: Decodable {
    let key: String
    let name: String
    let country: String
    let region: String
    let coordinate: CLLocationCoordinate2D
    
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case name = "EnglishName"
        case country = "Country"
        case region = "Region"
        case geoPosition = "GeoPosition"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decode(String.self, forKey: .key)
        name = try values.decode(String.self, forKey: .name)
        region = try values.decode(Region.self, forKey: .region).name
        country = try values.decode(Country.self, forKey: .country).name
        
        let coordinate = try values.decode(GeoPosition.self, forKey: .geoPosition)
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)

    }
    
    struct Country: Decodable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name = "EnglishName"
        }
    }
    
    struct Region: Decodable {
        let name: String
        enum CodingKeys: String, CodingKey {
            case name = "EnglishName"
        }
    }
    
    struct GeoPosition: Decodable {
        let latitude:Double
        let longitude: Double
        enum CodingKeys: String, CodingKey {
            case latitude = "Latitude"
            case longitude = "Longitude"
        }
    }
}
