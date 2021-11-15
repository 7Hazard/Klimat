//
//  Forecast.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import Foundation

class Forecast: Identifiable, Codable {
    let time: Date
    let temp: Float
    let icon: Int
    
    init(time: Date, temp: Float, icon: Int)
    {
        self.time = time
        self.temp = temp
        self.icon = icon
    }
}

class ForecastGroup: Identifiable, Codable {
    let approvedTime: Date
    let forecasts: [Forecast]
    var outdated = false
    
    init(_ approvedTime: Date, _ forecasts: [Forecast]) {
        self.approvedTime = approvedTime
        self.forecasts = forecasts
    }
}
