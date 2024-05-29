//
//  AnalyticsExtensions.swift
//  books
//
//  Created by Damien Gironnet on 10/10/2023.
//

import Foundation
import analytics

public extension AnalyticsHelper {
    func logFaithFilterClick(_ faith: String) {
        logEvent(event: AnalyticsEvent(type: "books_faith_filter_click",
                                       extras: [AnalyticsEvent.Param(key: "faith", value: faith)]))
    }
}
