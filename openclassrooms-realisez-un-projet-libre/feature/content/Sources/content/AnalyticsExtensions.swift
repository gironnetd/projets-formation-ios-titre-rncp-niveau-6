//
//  AnalyticsExtensions.swift
//  content
//
//  Created by Damien Gironnet on 10/10/2023.
//

import Foundation
import analytics

public extension AnalyticsHelper {
    func logAuthorBookFilterClick(_ authorBook: String) {
        logEvent(event: AnalyticsEvent(type: "author_book_filter_click",
                                       extras: [AnalyticsEvent.Param(key: "author_book", value: authorBook)]))
    }
}
