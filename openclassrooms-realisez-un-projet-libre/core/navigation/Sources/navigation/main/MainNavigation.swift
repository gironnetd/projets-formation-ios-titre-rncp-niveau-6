//
//  MainNavigation.swift
//  navigation
//
//  Created by damien on 06/12/2022.
//

import Foundation
import model

///
/// Enum for the Main navigation across application
///
public enum MainNavigation: Equatable {
    public static func == (lhs: MainNavigation, rhs: MainNavigation) -> Bool {
        switch(lhs, rhs) {
        case (.splash, .splash):
            return true
        case (.main, .main):
            return true
        case (.content(let lhsFollowableTopic, _), .content(let rhsFollowableTopic, _)):
            return lhsFollowableTopic == rhsFollowableTopic
        default:
            return false
        }
    }
    
    public static let NavigationDuration = 0.6
    
    case splash
    case main
    case content(followableTopic: FollowableTopic, returnToPrevious: Bool)
}
