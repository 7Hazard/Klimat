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
            RecentView().tabItem{
                Image(systemName: "clock.arrow.circlepath")
                Text("Recent")
            }
            SearchView().tabItem{
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            PreferencesView().tabItem {
                Image(systemName: "gear")
                Text("Preferences")
            }
        }
    }
}
