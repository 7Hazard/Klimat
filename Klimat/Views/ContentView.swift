//
//  ContentView.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-09.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ContentViewModel
    
    var body: some View {
        VStack {
            if(!vm.isConnected) {
                HStack {
                    Text("Disconnected from internet")
                        .foregroundColor(.red)
                    Image(systemName: "wifi.slash")
                }
            }
            
            TabView {
                RecentView(vm: RecentViewModel()).tabItem{
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Recent")
                }
                SearchView(vm: SearchViewModel()).tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                PreferencesView(vm: PreferencesViewModel()).tabItem {
                    Image(systemName: "gear")
                    Text("Preferences")
                }
            }
        }
    }
}
