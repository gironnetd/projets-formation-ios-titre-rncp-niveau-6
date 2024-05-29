//
//  NoOpAnalyticsHelper.swift
//  analytics
//
//  Created by Damien Gironnet on 22/07/2023.
//

import Foundation

///
/// Empty Implementation of AnalyticsHelper Protocol
///
public class NoOpAnalyticsHelper: AnalyticsHelper {
    public func logEvent(event: AnalyticsEvent) {}
}
