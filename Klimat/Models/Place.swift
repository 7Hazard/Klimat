//
//  PlaceData.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-09.
//

import Foundation
import SwiftUI

class Place: Identifiable, Equatable, Codable {
    static func search(input: String) async -> [Place] {
        struct Json: Decodable {
            let place: String
            let lon: Float
            let lat: Float
        }
        
        do {
            let escapedInput = input.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let url = URL(string: "https://www.smhi.se/wpt-a/backend_solr/autocomplete/search/\(escapedInput)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let allJson = try JSONDecoder().decode([Json].self, from: data)
            
            var places: [Place] = []
            places.reserveCapacity(allJson.count)
            for j in allJson {
                places.append(Place(place: j.place, lon: j.lon, lat: j.lat))
            }
            return places
        } catch {
            print(error)
            return cache.filter{ $0.name.uppercased().contains(input.uppercased()) }
        }
    }
    
    var isFavourite = false
    let name: String
    let lon: Float
    let lat: Float
    private var cachedForecast: ForecastGroup?
    
    init(place: String, lon: Float = 0, lat: Float = 0) {
        self.name = place
        self.lon = lon
        self.lat = lat
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.lon == rhs.lon && lhs.lat == rhs.lat
    }
    
    func forecast() async -> ForecastGroup? {
        
        // When first forecast is initiated, cache the place if not already cached
        if let index = Place.cache.firstIndex(of: self) {
            Place.cache.remove(at: index)
        }
        Place.cache.insert(self, at: 0) // Reorder last accessed to top
        
        class Json: Decodable {
            let approvedTime: String
            
            class TimeSerie: Decodable {
                let validTime: String
                
                struct Parameter: Decodable {
                    let name: String
                    let values: [Float]
                }
                let parameters: [Parameter]
            }
            let timeSeries: [TimeSerie]
        }
        
        do {
            let url = URL(string: "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/\(lon)/lat/\(lat)/data.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let forecastData = try JSONDecoder().decode(Json.self, from: data)
            
            var forecasts: [Forecast] = []
            forecasts.reserveCapacity(forecastData.timeSeries.count)
            for ts in forecastData.timeSeries {
                let time = ts.validTime
                var temp: Float = 0
                var icon = 0
                for param in ts.parameters {
                    if(param.name == "t"){
                        temp = param.values[0]
                    }
                    else if(param.name == "Wsymb2"){
                        icon = Int(param.values[0])
                    }
                }
                
                forecasts.append(Forecast(time: time, temp: temp, icon: icon))
            }
            
            cachedForecast = ForecastGroup(forecastData.approvedTime, forecasts)
            print("Fresh forecast")
        } catch {
            print(error)
            // Try to serve the last cached
            if cachedForecast != nil {
                cachedForecast?.outdated = true
            }
        }
        
        Place.save()
        return cachedForecast ?? nil
    }
    
    static func getFavourites() -> [Place] { cache.filter{ $0.isFavourite } }
    func toggleFavourite() -> Bool {
        if isFavourite {
            isFavourite = false
        } else {
            isFavourite = true
        }
        
        Place.save()
        
        return isFavourite
    }
    
    // TODO store by object identifier, not by hash
    private static var cache: [Place] = {
        do {
            if let data = UserDefaults.standard.value(forKey: "places") as? Data {
                return try JSONDecoder().decode([Place].self, from: data)
            }
        } catch {
            // Place structure probably changed, discard old cache
            print(error)
        }
        
        return []
    }()
    static func getCached() -> [Place] { return cache }
    private static func save() {
        UserDefaults.standard.set(try! JSONEncoder().encode(cache), forKey: "places")
    }
}
