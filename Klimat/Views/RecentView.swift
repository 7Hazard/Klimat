//
//  FavouritesView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import SwiftUI

struct RecentView: View {
    @State private var places: [Place] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(places) { place in
                    NavigationLink(destination: ForecastView(place: place)) {
                        Label(place.name, systemImage: place.isFavourite ? "star.fill" : "clock.arrow.circlepath")
                    }
                }
                .onDelete { indexes in
                    for index in indexes {
                        Place.deleteCached(places[index])
                        places.remove(at: index)
                    }
                }
            }
            .navigationTitle("Recent")
            .task {
                places = Place.getCached()
                .sorted(by: { first, second in
                    if(first.lastAccessed > second.lastAccessed) {
                        return true
                    } else {
                        return false
                    }
                })
                .sorted(by: { first, second in
                    if(first.isFavourite && !second.isFavourite) {
                        return true
                    } else {
                        return false
                    }
                })
            }
        }
    }
}
