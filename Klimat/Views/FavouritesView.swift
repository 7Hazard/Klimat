//
//  FavouritesView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import SwiftUI

struct FavouritesView: View {
    @State private var favourites: [Place] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favourites) { place in
                    NavigationLink(place.name, destination: ForecastView(place: place))
                }
                .onDelete { indexes in
                    for index in indexes {
                        favourites[index].toggleFavourite()
                        favourites.remove(at: index)
                    }
                }
            }
            .navigationTitle("Favourites")
            .task {
                favourites = Place.getFavourites()
            }
        }
    }
}
