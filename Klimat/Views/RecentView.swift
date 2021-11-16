//
//  FavouritesView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import SwiftUI

struct RecentView: View {
    @StateObject var vm: RecentViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.places) { place in
                    NavigationLink(destination: ForecastView(vm: ForecastViewModel(place))) {
                        Label(place.name, systemImage: place.isFavourite ? "star.fill" : "clock.arrow.circlepath")
                    }
                }
                .onDelete { indexes in
                    for index in indexes {
                        vm.delete(index)
                    }
                }
            }
            .navigationTitle("Recent")
            .task {
                vm.fetch()
            }
        }
    }
}
