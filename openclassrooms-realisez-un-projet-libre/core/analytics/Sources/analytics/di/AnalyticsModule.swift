//
//  AnalyticsModule.swift
//  analytics
//
//  Created by Damien Gironnet on 22/07/2023.
//

import Foundation
import Factory

///
/// Dependency injection for Analytics package
/// 
//public final class AnalyticsModule: SharedContainer {
//    public static let analyticsHelper = Factory<AnalyticsHelper>() { DefaultAnalyticsHelper() }
//}

public extension SharedContainer {
    var analyticsHelper: Factory<AnalyticsHelper> { self { DefaultAnalyticsHelper() }.singleton }
}
