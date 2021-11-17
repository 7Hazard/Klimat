//
//  ContentViewModel.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-17.
//

import Foundation

class ContentViewModel : ObservableObject {
    @Published var isConnected = Network.isConnected
    
    init() {
        Network.subscribe {
            DispatchQueue.main.async {
                self.isConnected = Network.isConnected
            }
        }
    }
}
