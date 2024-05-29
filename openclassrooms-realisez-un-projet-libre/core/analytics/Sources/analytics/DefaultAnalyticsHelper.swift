//
//  DefaultAnalyticsHelper.swift
//  analytics
//
//  Created by Damien Gironnet on 22/07/2023.
//

import Foundation
import Firebase
import FirebaseAnalytics

///
/// Default implementation of AnalyticsHelper Protocol
///
public class DefaultAnalyticsHelper: AnalyticsHelper {
    
    public init() {
        if let path = Bundle.analytics.url(forResource: "GoogleService-Info", withExtension: "plist"),
           let firbaseOptions = FirebaseOptions(contentsOfFile: path.path) {
            if FirebaseApp.app() == nil {
                FirebaseApp.configure(options: firbaseOptions)
            }
        }
    }
    
    public func logEvent(event: AnalyticsEvent) {
        Analytics.logEvent(event.type, parameters: Dictionary(uniqueKeysWithValues: event.extras.map { ($0.key, $0.value) }))
    }
}
