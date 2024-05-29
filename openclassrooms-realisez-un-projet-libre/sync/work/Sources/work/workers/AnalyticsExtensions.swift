//
//  AnalyticsExtensions.swift
//  work
//
//  Created by Damien Gironnet on 14/11/2023.
//

import Foundation
import analytics

public extension AnalyticsHelper {
    func logSyncStarted() {
        logEvent(event: AnalyticsEvent(type: "network_sync_started"))
    }
    
    func logSyncFinished(_ syncedSuccessfully: Bool) {
        let eventType = syncedSuccessfully ? "network_sync_successful" : "network_sync_failed"
        logEvent(event: AnalyticsEvent(type: eventType))
    }
}
