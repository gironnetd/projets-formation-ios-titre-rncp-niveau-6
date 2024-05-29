//
//  PageIndex.swift
//  designsystem
//
//  Created by Damien Gironnet on 06/09/2023.
//

import Foundation
import SwiftUI

///
/// ObservableObject used to share page index
///
public class PageIndex: ObservableObject {
    @Published public var currentIndex: Int
    @Published public var previousIndex: Int
        
    public init(currentIndex: Int, previousIndex: Int) {
        self.currentIndex = currentIndex
        self.previousIndex = previousIndex
    }
}
