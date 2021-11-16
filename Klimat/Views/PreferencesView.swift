//
//  PreferencesView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-16.
//

import SwiftUI

struct PreferencesView: View {
    @StateObject var vm: PreferencesViewModel
    
    var body: some View {
        NavigationView {
            List {
                VStack{
                    Text("Update Interval")
                    Slider(
                        value: $vm.updateInterval,
                        in: 1...60, // Max 60 min
                        onEditingChanged: { editing in
                            vm.isEditingUpdateInterval = editing
                            if(!editing) { vm.apply() }
                        }
                    )
                    Text("Every \(vm.updateInterval, specifier: "%.0f") minutes")
                        .foregroundColor(vm.isEditingUpdateInterval ? .yellow : .blue)
                }
            }
            .navigationTitle("Preferences")
        }
    }
}
