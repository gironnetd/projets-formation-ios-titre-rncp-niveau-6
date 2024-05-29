//
//  AnalyticsHelper.swift
//  analytics
//
//  Created by Damien Gironnet on 22/07/2023.
//

import Foundation

///
/// Protocol defining methods for objects used to do analytics
///
public protocol AnalyticsHelper {
    
    /// Function to log event
    /// - Parameters:
    ///   - event: Event to log
    func logEvent(event: AnalyticsEvent)
}
