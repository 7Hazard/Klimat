//
//  ForecastViewModel.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-16.
//

import Foundation

class ForecastViewModel : ObservableObject {
    @Published var place: Place
    
    init(_ place: Place) {
        self.place = place
    }
    
    func update() async {
        place.lastAccessed = Date.now
        Place.addToCache(place)
        
        // If cached and more fresh than 10 min, serve it
        if(
            place.cachedForecast != nil &&
            Date.now.timeIntervalSince(place.cachedForecast!.timeFetched) > Preferences.updateInterval * 60
        ) {
            // Update
            print("TIME SINCE LAST UPDATE: \(Date.now.timeIntervalSince(place.cachedForecast!.timeFetched))")
            // ... continue
        }
        else if(place.cachedForecast != nil) {
            // Serve cached
            print("TIME SINCE LAST UPDATE: \(Date.now.timeIntervalSince(place.cachedForecast!.timeFetched))")
            return
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
            let url = URL(string: "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/\(place.lon)/lat/\(place.lat)/data.json")!
            URLCache.shared.removeAllCachedResponses();
            let (data, _) = try await URLSession.shared.data(from: url)
            let forecastData = try JSONDecoder().decode(Json.self, from: data)
            
            var forecasts: [Forecast] = []
            forecasts.reserveCapacity(forecastData.timeSeries.count)
            for ts in forecastData.timeSeries {
                let time = parseDate(ts.validTime)
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
            
            let approvedTime = parseDate(forecastData.approvedTime)
            place.cachedForecast = ForecastGroup(approvedTime, forecasts)
            print("FRESH FORECAST")
        } catch {
            print(error)
            // Try to serve the last cached
            if place.cachedForecast != nil {
                place.cachedForecast?.outdated = true
            }
        }
        
        Place.save()
        place = place // triggers a view state change
    }
    
    func toggleFavourite() {
        place.isFavourite = !place.isFavourite
        Place.save()
        place = place // triggers a view state change
    }
}
