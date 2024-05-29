//
//  AnalyticsEvent.swift
//  analytics
//
//  Created by Damien Gironnet on 22/07/2023.
//

import Foundation

///
/// Structure representing Analytics event
///
public struct AnalyticsEvent {
    
    /// type of the event
    let type: String
    /// Array of Param for the values
    let extras: [Param]
    
    public init(type: String, extras: [Param] = []) {
        self.type = type
        self.extras = extras
    }
    
    public class Types {
        public static let SCREEN_VIEW = "screen_view"
    }
    
    public struct Param {
        public let key: String
        public let value: String
        
        public init(key: String, value: String) {
            self.key = key
            self.value = value
        }
    }
    
    public class ParamKeys {
        public static let SCREEN_NAME = "screen_name"
    }
}
