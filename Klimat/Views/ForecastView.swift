//
//  PlaceView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import SwiftUI

struct ForecastView: View {
    @StateObject var vm: ForecastViewModel
    
    var body: some View {
        VStack {
            // Info
            HStack{
                vm.place.cachedForecast != nil
                ? Text("Forecast from \(vm.place.cachedForecast!.approvedTime.formatted())")
                    .foregroundColor(vm.place.cachedForecast!.outdated ? Color.red : Color.white)
                : Text("Could not fetch forecast").foregroundColor(Color.red)
                Button(action: { vm.toggleFavourite() }) {
                    Image(systemName: vm.place.isFavourite ? "star.fill" : "star")
                }
            }
            
            // List
            List(vm.place.cachedForecast?.forecasts ?? []) { f in
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
                await vm.update()
            }
            .task {
                await vm.update()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationTitle(vm.place.name)
    }
}
