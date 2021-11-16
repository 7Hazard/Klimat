//
//  PlaceData.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-09.
//

import Foundation
import SwiftUI

class Place: Identifiable, Equatable, Codable, Hashable {
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
    var lastAccessed = Date.now
    
    init(place: String, lon: Float = 0, lat: Float = 0) {
        self.name = place
        self.lon = lon
        self.lat = lat
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.lon == rhs.lon && lhs.lat == rhs.lat
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(lon)
        hasher.combine(lat)
    }
    
    func forecast() async -> ForecastGroup? {
        
        Place.cache.insert(self)
        lastAccessed = Date.now
        
        // If cached and more fresh than 10 min, serve it
        if(
            cachedForecast != nil &&
            Date.now.timeIntervalSince(cachedForecast!.timeFetched) > Preferences.updateInterval * 60
        ) {
            // Update
            print("TIME SINCE LAST UPDATE: \(Date.now.timeIntervalSince(cachedForecast!.timeFetched))")
        }
        else if(cachedForecast != nil) {
            // Serve cached
            print("TIME SINCE LAST UPDATE: \(Date.now.timeIntervalSince(cachedForecast!.timeFetched))")
            return cachedForecast
        }
        
        class Json: Decodable {
            class TimeSerie: Decodable {
                struct Parameter: Decodable {
                    let name: String
                    let values: [Float]
                }
                
                let validTime: String
                let parameters: [Parameter]
            }
            
            let approvedTime: String
            let timeSeries: [TimeSerie]
        }
        
        do {
            let url = URL(string: "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/\(lon)/lat/\(lat)/data.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let forecastData = try JSONDecoder().decode(Json.self, from: data)
            
            var forecasts: [Forecast] = []
            forecasts.reserveCapacity(forecastData.timeSeries.count)
            for ts in forecastData.timeSeries {
                let time = Place.parseDate(ts.validTime)
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
            
            let approvedTime = Place.parseDate(forecastData.approvedTime)
            cachedForecast = ForecastGroup(approvedTime, forecasts)
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
    
    func toggleFavourite() {
        if isFavourite {
            isFavourite = false
        } else {
            isFavourite = true
        }
        
        Place.save()
    }
    
    private static var cache: Set<Place> = {
        do {
            if let data = UserDefaults.standard.value(forKey: "places") as? Data {
                return try JSONDecoder().decode(Set<Place>.self, from: data)
            }
        } catch {
            // Place structure probably changed, discard old cache
            print(error)
        }
        
        return []
    }()
    static func getCached() -> Set<Place> { return cache }
    private static func save() {
        UserDefaults.standard.set(try! JSONEncoder().encode(cache), forKey: "places")
    }
    static func deleteCached(_ place: Place) {
        cache.remove(place)
        save()
    }
    
    static func parseDate(_ isoDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        return date;
    }
}
