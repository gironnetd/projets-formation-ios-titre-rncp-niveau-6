//
//  FilterTab.swift
//  ui
//
//  Created by Damien Gironnet on 27/06/2023.
//

import Foundation
import SwiftUI
import designsystem
import domain
import Combine

///
/// Protocol for Tab in application
///
public protocol Tab: AnyObject {
    var titles: [(title: String, isActive: Bool , type: FilterTabType?)] { get set }
    var tabs: [((Any) -> Bool)] { get set }
}

///
/// ObservableObject representing filter tab
///
public class FilterTab: ObservableObject, Tab {
        
    @Published public var titles: [(title: String, isActive: Bool , type: FilterTabType?)]
    @Published public var tabs: [((Any) -> Bool)] = []
    
    public init(titles: [(title: String, isActive: Bool , type: FilterTabType?)]) {
        self.titles = titles
    }
}

///
/// Enum indicating the Tab type of the filter
///
public enum FilterTabType {
    case century, faith, authorBook
}

///
/// Enum indicating on which model the filter operates
///
public enum FilterType {
    case author, book, quote
}
