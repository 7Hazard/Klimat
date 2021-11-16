//
//  PreferencesView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-16.
//

import SwiftUI

struct PreferencesView: View {
    @State private var updateInterval: Double = 10
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            List {
                VStack{
                    Text("Update Interval")
                    Slider(
                        value: $updateInterval,
                        in: 1...60, // Max 60 min
                        onEditingChanged: { editing in
                            isEditing = editing
                            if(!isEditing)
                            {
                                // Finished editing, apply
                                Task {
                                    updateInterval = updateInterval.rounded()
                                    Preferences.updateInterval = updateInterval
                                }
                            }
                        }
                    )
                    Text("Every \(updateInterval, specifier: "%.0f") minutes")
                        .foregroundColor(isEditing ? .yellow : .blue)
                }
            }
            .navigationTitle("Preferences")
            .task {
                updateInterval = Preferences.updateInterval
            }
        }
    }
}
