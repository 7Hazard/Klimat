//
//  SearchView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm: SearchViewModel
    
    var body: some View {
        NavigationView {
            List(vm.places) { place in
                NavigationLink(place.fullName, destination: ForecastView(vm: ForecastViewModel(place)))
            }
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .disableAutocorrection(true)
            .navigationTitle("Places")
        }
        .onChange(of: vm.searchText) { newInput in
            vm.search(newInput)
        }
    }
}
