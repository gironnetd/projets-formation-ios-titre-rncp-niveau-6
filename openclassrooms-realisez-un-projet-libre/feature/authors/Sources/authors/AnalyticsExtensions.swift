//
//  AnalyticsExtensions.swift
//  authors
//
//  Created by Damien Gironnet on 22/07/2023.
//

import Foundation
import analytics

public extension AnalyticsHelper {
    
    func logCenturyFilterClick(_ century: String) {
        logEvent(event: AnalyticsEvent(type: "authors_century_filter_click",
                                       extras: [AnalyticsEvent.Param(key: "century", value: century)]))
    }
    
    func logFaithFilterClick(_ faith: String) {
        logEvent(event: AnalyticsEvent(type: "authors_faith_filter_click",
                                       extras: [AnalyticsEvent.Param(key: "faith", value: faith)]))
    }
}
