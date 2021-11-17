//
//  Network.swift
//  Klimat
//
//  Created by Leo Zaki on 2021-11-17.
//

import Foundation
import Network

class Network {
    static var isConnected = false
    static var isExpensive = false
    static func subscribe(_ handler: @escaping () -> Void) {
        if(monitor == nil) {
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                isConnected = path.status == .satisfied
                isExpensive = path.isExpensive
                print("is connected? \(isConnected)")
                print("is expensive? \(isExpensive)")
                
                for handler in subscribed {
                    handler()
                }
            }
            monitor.start(queue: queue)
            self.monitor = monitor
        }
        
        subscribed.append(handler)
    }
    
    private static var subscribed: [() -> Void] = []
    private static let queue = DispatchQueue(label: "Monitor")
    private static var monitor: NWPathMonitor?
}
