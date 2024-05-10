//
//  DailyWeather.swift
//  Weather_SwiftUI
//
//  Created by Phat on 24/04/2024.
//

import Foundation

struct DailyWeather {
    let time: Int
    let sunRise: Int
    let sunSet: Int
    let minTemperature: UnitType
    let maxTemperature: UnitType
    let icon: String
    let huminity: String
    let text: String
    let rainProbability: Int
    let wind: Wind
}
