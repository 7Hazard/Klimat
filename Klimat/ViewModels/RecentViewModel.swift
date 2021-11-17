//
//  RecentViewModel.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-16.
//

import Foundation

class RecentViewModel : ObservableObject {
    @Published var places: [Place] = []
    
    func fetch() {
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
    
    func delete(_ index: Int) {
        Place.uncache(places[index])
        places.remove(at: index)
    }
}
