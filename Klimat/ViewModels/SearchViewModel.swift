//
//  SearchViewModel.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-16.
//

import Foundation

class SearchViewModel : ObservableObject {
    @Published var places: [Place] = []
    @Published var searchText: String = ""
    @Published var searchTask: Task<(), Error>?
    
    func search(_ input: String) {
        if searchText.isEmpty { return }
        searchTask?.cancel()
        searchTask = Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            
            struct Json: Decodable {
                let place: String
                let county: String?
                let lon: Float
                let lat: Float
            }
            
            do {
                let escapedInput = input.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                let url = URL(string: "https://www.smhi.se/wpt-a/backend_solr/autocomplete/search/\(escapedInput)")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let allJson = try JSONDecoder().decode([Json].self, from: data)
                
                var places: [Place] = []
                places.reserveCapacity(allJson.count)
                for j in allJson {
                    places.append(Place(place: j.place, county: j.county, lon: j.lon, lat: j.lat))
                }
                
                let constPlaces = places
                DispatchQueue.main.async {
                    self.places = constPlaces
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.places = Place.getCached().filter{ $0.name.uppercased().contains(input.uppercased()) }
                }
            }
        }
    }
}
