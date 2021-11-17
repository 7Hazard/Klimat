//
//  ContentViewModel.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-17.
//

import Foundation
import Network

class ContentViewModel : ObservableObject {
    @Published var isConnected = false
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    init() {
        print("SHIT")
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                print(path.status)
                if path.status == .satisfied {
                    self.isConnected = true
                    print("connected")
                }
                else {
                    self.isConnected = false
                    print("disconnected")
                }
//                print("Is connected? \(self.isConnected)")
            }
//            print(path.isExpensive)
        }
        monitor.start(queue: queue)
    }
}
