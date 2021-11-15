//
//  PlaceView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import SwiftUI

struct ForecastView: View {
    @State private var forecast: ForecastGroup? = nil
    @State private var isFavourite = false
    
    let place: Place
    
    var body: some View {
        HStack{
            forecast != nil
            ? Text("Forecast from \(forecast!.approvedTime)")
                .foregroundColor(forecast!.outdated ? Color.red : Color.white)
            : Text("Could not fetch forecast").foregroundColor(Color.red)
            Button(action: {
                isFavourite = place.toggleFavourite()
            }) {
                Image(systemName: isFavourite ? "star.fill" : "star")
            }
        }
        List(forecast?.forecasts ?? []) { f in
            VStack {
                Text("\(f.time)")
                HStack {
                    Image("day/\(f.icon)")
                    Text("\(f.temp, specifier: "%.1f")°C")
                }
            }
        }
        .refreshable {
            forecast = await place.forecast()
        }
        .task {
            isFavourite = place.isFavourite
            forecast = await place.forecast()
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
