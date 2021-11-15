//
//  RecentView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-12.
//

import SwiftUI

struct RecentView: View {
    @State private var places: [Place] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(places) { place in
                    NavigationLink(place.name, destination: ForecastView(place: place))
                }
            }
            .navigationTitle("Recent")
            .task {
                places = Place.getCached()
            }
        }
    }
}
