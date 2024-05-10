//
//  Weather.swift
//  Weather_SwiftUI
//
//  Created by Phat on 19/04/2024.
//

import Foundation
import CoreLocation
import UIKit
struct Weather: Decodable {
    let icon: String
    let weatherText: String
    let uvIndex: Int
    let isDateTime: Bool
    let visibility: UnitType
    let pressure: UnitType
    let wind: Wind
    let minTemperature: UnitType
    let maxTemperature: UnitType
    let temperature: UnitType
    let realFeelTemperature: UnitType
    let humidity: Int
    var hourlyWeather: [HourlyWeather] = []
    enum CodingKeys: String, CodingKey {
        case weatherText = "WeatherText"
        case icon = "WeatherIcon"
        case isDateTime = "IsDayTime"
        case temperature = "Temperature"
        case realFeelTemperature = "RealFeelTemperature"
        case pressure = "Pressure"
        case visibility = "Visibility"
        case uvIndex = "UVIndex"
        case wind = "Wind"
        case humidity = "RelativeHumidity"
        case temperatureSummary = "TemperatureSummary"
        case imperial = "Imperial"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let iconInt = try values.decode(Int.self,forKey: .icon)
        icon = iconToIconString(icon: iconInt)
        weatherText = try values.decode(String.self, forKey: .weatherText)
        uvIndex = try values.decode(Int.self,forKey: .uvIndex)
        isDateTime = try values.decode(Bool.self,forKey: .isDateTime)
        
        let temperature = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .temperature)
        self.temperature = try temperature.decode(UnitType.self, forKey: .imperial)
        let visibility = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .visibility)
        self.visibility = try visibility.decode(UnitType.self,forKey: .imperial)
        
        let pressure = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .pressure)
        self.pressure = try pressure.decode(UnitType.self,forKey: .imperial)
        
        let realFeelTemperature = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .realFeelTemperature)
        self.realFeelTemperature = try realFeelTemperature.decode(UnitType.self,forKey: .imperial)
        humidity = try values.decode(Int.self,forKey: .humidity)
        wind = try values.decode(Wind.self,forKey: .wind)
        let temperatureSummary = try values.decode(TemperatureSummary.self, forKey: .temperatureSummary)
        minTemperature = temperatureSummary.past24HourRange.minimum
        maxTemperature = temperatureSummary.past24HourRange.maximum
    }
    
}


func iconToIconString(icon: Int) -> String {
    switch icon {
    case 1:
        return "ic_sunny"
    case 2:
        return "ic_mostly_cloudy"
    case 3:
        return "ic_partly_sunny"
    case 4:
        return "ic_intermittent_clouds"
    case 5:
        return "ic_hazy_sunshine"
    case 6:
        return "ic_mostly_cloudy"
    case 7:
        return "ic_cloudy"
    case 8:
        return "ic_dreary_overcast"

    case 11:
        return "ic_fog"
    case 12:
        return "ic_showers"
    case 13:
        return "ic_mostly_cloudy_showers"
    case 14:
        return "ic_partly_sunny_showers"
    case 15:
        return "ic_tstorms"
    case 16:
        return "ic_mostly_cloudy_tstorms"
    case 17:
        return "ic_partly_sunny_tstorms"
    case 18:
        return "ic_rain"
    case 19:
        return "ic_flurries"
    case 20:
        return "ic_mostly_cloudy_flurries"
    case 21:
        return "ic_partly_sunny_flurries"
    case 22:
        return "ic_snow"
    case 23:
        return "ic_mostly_cloudy_snow"
    case 24:
        return "ic_ice"
    case 25:
        return "ic_sleet"
    case 26:
        return "ic_freezing_rain"
    case 29:
        return "ic_rain_and_snow"
    case 30:
        return "ic_hot"
    case 31:
        return "ic_cold"
    case 32:
        return "ic_windy"
    case 33:
        return "ic_clear"
    case 34:
        return "ic_mostly_clear"
    case 35:
        return "ic_partly_cloudy"
    case 36:
        return "ic_intermittent_clouds_night"
    case 37:
        return "ic_hazy_moonlight"
    case 38:
        return "ic_mostly_cloudy_night"
    case 39:
        return "ic_partly_cloudy_showers"
    case 40:
        return "ic_mostly_cloudy_showers_night"
    case 41:
        return "ic_partly_cloudy_tstorms"
    case 42:
        return "ic_mostly_cloudy_tstorms_night"
    case 43:
        return "ic_mostly_cloudy_flurries_night"
    case 44:
        return "ic_mostly_cloudy_snow_night"
    
    
    default:
        return ""
    }
}


//// MARK: - WeatherParam
//enum WeatherParam: Codable {
//    typealias RawValue = UnitType
//
//    case metric, imperial
//
//
//    enum CodingKeys: String, CodingKey {
//        case metric = "Metric"
//        case imperial = "Imperial"
//    }
//
////    func currentValue(isMetric: Bool = false) -> UnitType {
////        isMetric ? metric : imperial
////    }
//}

// MARK: - UnitType
struct UnitType: Decodable {
    let value: Double
    let unit: String
    let unitType: Int

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}

// MARK: - Wind
struct Wind: Decodable {
    let direction: Direction
    let speed: UnitType

    enum CodingKeys: String, CodingKey {
        case direction = "Direction"
        case speed = "Speed"
        case imperial = "Imperial"

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        direction = try values.decode(Direction.self, forKey: .direction)
        if let speed = try? values.decode(UnitType.self, forKey: .speed) {
            self.speed = speed
        } else {
            let speed = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .speed)
            self.speed = try speed.decode(UnitType.self, forKey: .imperial)
            
        }
    }
}

// MARK: - Direction
struct Direction: Decodable {
    let degrees: Int
    let localized, english: String

    enum CodingKeys: String, CodingKey {
        case degrees = "Degrees"
        case localized = "Localized"
        case english = "English"
    }
}

// MARK: - TemperatureSummary
struct TemperatureSummary: Decodable {
    let past24HourRange: PastHourRange

    enum CodingKeys: String, CodingKey {
        case past24HourRange = "Past24HourRange"
    }
}


// MARK: - PastHourRange
struct PastHourRange: Decodable {
    let minimum, maximum: UnitType

    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
        case imperial = "Imperial"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let minimum = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .minimum)
        self.minimum = try minimum.decode(UnitType.self, forKey: .imperial)
        
        let maximum = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .maximum)
        self.maximum = try maximum.decode(UnitType.self, forKey: .imperial)

    }
}
