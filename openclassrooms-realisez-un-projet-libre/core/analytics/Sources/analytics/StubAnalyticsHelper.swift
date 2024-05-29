//
//  StubAnalyticsHelper.swift
//  analytics
//
//  Created by Damien Gironnet on 22/07/2023.
//

import Foundation

///
/// Stub Implementation of AnalyticsHelper Protocol create for Testing
///
public class StubAnalyticsHelper: AnalyticsHelper {
    
    public init() { }
    
    public func logEvent(event: AnalyticsEvent) {
        print("Received analytics event: \(event)")
    }
}
