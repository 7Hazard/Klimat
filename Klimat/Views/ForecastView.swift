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
        VStack {
            // Info
            HStack{
                forecast != nil
                ? Text("Forecast from \(forecast!.approvedTime.formatted())")
                    .foregroundColor(forecast!.outdated ? Color.red : Color.white)
                : Text("Could not fetch forecast").foregroundColor(Color.red)
                Button(action: {
                    place.toggleFavourite()
                    isFavourite = place.isFavourite
                }) {
                    Image(systemName: isFavourite ? "star.fill" : "star")
                }
            }
            
            // List
            List(forecast?.forecasts ?? []) { f in
                HStack {
                    Text("\(f.time.formatted())")
                        .font(.system(size: 16))
                    Spacer()
                    Image("day/\(f.icon)")
                    Spacer()
                    Text("\(f.temp, specifier: "%.1f")°C")
                        .font(.system(size: 32))
                }
            }
            .refreshable {
                forecast = await place.forecast()
            }
            .task {
                isFavourite = place.isFavourite
                forecast = await place.forecast()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationTitle(place.name)
    }
}
