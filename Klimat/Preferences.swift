//
//  Preferences.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-16.
//

import Foundation

class Preferences {
    private static let updateIntervalKey = "preferences.updateInterval"
    static var updateInterval: Double {
        get {
            return UserDefaults.standard.double(forKey: updateIntervalKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: updateIntervalKey)
        }
    }
}
