//
//  Favourite.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-11.
//

import Foundation

class Favourite: Identifiable {
    private static var tmp: [Favourite] = []
    
    static func getAll() -> [Favourite] {
        return tmp
    }
}
