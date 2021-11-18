//
//  PlaceData.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-09.
//

import Foundation
import SwiftUI

class Place: Identifiable, Equatable, Codable, Hashable {
    var isFavourite = false
    let name: String
    let county: String?
    let lon: Float
    let lat: Float
    var cachedForecast: ForecastGroup?
    var lastAccessed = Date.now
    var fullName: String {
        get {
            if(county != nil) {
                return "\(name), \(county!)"
            } else {
                return name
            }
        }
    }
    
    init(place: String, county: String?, lon: Float = 0, lat: Float = 0) {
        self.name = place
        self.county = county
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
    
    // Cache
    private static var cache: Set<Place> = {
        do {
            if let data = UserDefaults.standard.value(forKey: "places") as? Data {
                return try JSONDecoder().decode(Set<Place>.self, from: data)
            }
        } catch {
            // Place structure probably changed, discard old cache
            print(error)
        }
        
        return Set()
    }()
    static func getCached() -> Set<Place> { return cache }
    static func cache(_ place: Place) { cache.insert(place) }
    static func uncache(_ place: Place) { cache.remove(place) }
    static func save() {
        UserDefaults.standard.set(try! JSONEncoder().encode(cache), forKey: "places")
    }
}
