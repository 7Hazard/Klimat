//
//  SearchView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import SwiftUI

struct SearchView: View {
    @State private var places: [Place] = []
    @State private var searchText: String = ""
    @State private var searchTask: Task<(), Error>?
    
    var body: some View {
        NavigationView {
            List(places) { place in
                NavigationLink(getName(place), destination: ForecastView(place: place))
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Places")
        }
        .onChange(of: searchText) { newInput in
            if searchText.isEmpty { return }
            searchTask?.cancel()
            searchTask = Task {
                try await Task.sleep(nanoseconds: 500_000_000)
                places = await Place.search(input: searchText)
            }
        }
    }
    
    func getName(_ place: Place) -> String {
        let countWithSameName = places.filter{ $0.name == place.name }.count
        return countWithSameName > 1
        ? "\(place.name) (\(place.lon), \(place.lat))"
        : place.name
    }
}
