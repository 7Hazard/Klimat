//
//  ForecastGroup.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-15.
//

import Foundation

class ForecastGroup: Identifiable, Codable {
    let timeFetched: Date
    let approvedTime: Date
    let forecasts: [Forecast]
    var outdated = false
    
    init(_ approvedTime: Date, _ forecasts: [Forecast]) {
        self.timeFetched = Date.now
        self.approvedTime = approvedTime
        self.forecasts = forecasts
    }
}
