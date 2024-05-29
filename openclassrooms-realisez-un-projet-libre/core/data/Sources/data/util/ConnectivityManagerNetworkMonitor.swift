//
//  ConnectivityManagerNetworkMonitor.swift
//  data
//
//  Created by Damien Gironnet on 06/11/2023.
//

import Foundation
import Combine
import Network
import common
import Factory
import remote

public class ConnectivityManagerNetworkMonitor: NetworkMonitor {
    
    @LazyInjected(\.firestore) private var firestore
    
    public let isOnline: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    public init() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
                Log.debug("There is internet")
                DispatchQueue.main.async { self.firestore.enablOffline(enabled: false) }
                isOnline.value = true
            } else {
                Log.debug("No internet")
                DispatchQueue.main.async { self.firestore.enablOffline(enabled: true) }
                isOnline.value = false
            }
        }
    }
}
