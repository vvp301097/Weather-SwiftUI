//
//  HourlyWeather.swift
//  Weather_SwiftUI
//
//  Created by Phat on 24/04/2024.
//

import Foundation

struct HourlyWeather: Decodable {
    let time: Int
    let icon: String
    let text: String
    let temperature: UnitType
    let realFeelTemperature: UnitType
    let humidity: Int
    let rainProbability: Int
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case time = "EpochDateTime"
        case icon = "WeatherIcon"
        case text = "IconPhrase"
        case temperature = "Temperature"
        case realFeelTemperature = "RealFeelTemperature"
        case wind = "Wind"
        case humidity = "RelativeHumidity"
        case rainProbability = "RainProbability"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        time = try values.decode(Int.self, forKey: .time)
        let iconInt = try values.decode(Int.self, forKey: .icon)
        icon = iconToIconString(icon: iconInt)
        text = try values.decode(String.self, forKey: .text)
        temperature = try values.decode(UnitType.self, forKey: .temperature)
        realFeelTemperature = try values.decode(UnitType.self, forKey: .realFeelTemperature)
        wind = try values.decode(Wind.self, forKey: .wind)
        humidity = try values.decode(Int.self, forKey: .humidity)
        rainProbability = try values.decode(Int.self, forKey: .rainProbability)
    }
}
