//
//  PreferencesViewModel.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-16.
//

import Foundation

class PreferencesViewModel : ObservableObject {
    @Published var updateInterval: Double = Preferences.updateInterval
    @Published var isEditingUpdateInterval = false
    
    func apply() {
        updateInterval = updateInterval.rounded()
        Preferences.updateInterval = updateInterval
    }
}
