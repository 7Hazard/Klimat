//
//  ContentView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FavouritesView().tabItem{
                Image(systemName: "star.square")
                Text("Favourites")
            }
            SearchView().tabItem{
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            RecentView().tabItem {
                Image(systemName: "clock.arrow.circlepath")
                Text("Recent")
            }
        }
    }
}
