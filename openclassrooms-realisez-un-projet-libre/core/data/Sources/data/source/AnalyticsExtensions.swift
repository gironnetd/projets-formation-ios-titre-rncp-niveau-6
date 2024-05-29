//
//  AnalyticsExtensions.swift
//  data
//
//  Created by Damien Gironnet on 10/10/2023.
//

import Foundation
import analytics

public extension AnalyticsHelper {
    
    func logThemeChanged(_ themeName: String) {
        logEvent(event: AnalyticsEvent(type: "theme_changed",
                                       extras: [AnalyticsEvent.Param(key: "theme_name", value: themeName)]))
    }
    
    func logDarkThemeConfigChanged(_ darkThemeConfigName: String) {
        logEvent(event: AnalyticsEvent(type: "dark_theme_config_changed",
                                       extras: [AnalyticsEvent.Param(key: "dark_theme_config", value: darkThemeConfigName)]))
    }
    
    func logNewsResourceBookmarkToggled(_ newsResourceId: String, isBookmarked: Bool) {
        let eventType = if isBookmarked { "news_resource_saved" } else { "news_resource_unsaved" }
        let paramKey = if isBookmarked { "saved_news_resource_id" } else { "unsaved_news_resource_id" }
        logEvent(
            event: AnalyticsEvent(
                type: eventType,
                extras: [AnalyticsEvent.Param(key: paramKey, value: eventType)]
            )
        )
    }
}

