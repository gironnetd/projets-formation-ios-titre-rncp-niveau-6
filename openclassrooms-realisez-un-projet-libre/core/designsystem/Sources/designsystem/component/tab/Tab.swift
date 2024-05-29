//
//  OlaTab.swift
//  designsystem
//
//  Created by Damien Gironnet on 21/04/2023.
//

import Foundation
import SwiftUI
import Combine

///
/// Protocol for Tab in application
///
public protocol OlaTab {
    static var title: String { get }
}

public class Frame: ObservableObject {
    @Published public var bounds: CGRect

    public init(bounds: CGRect) {
        self.bounds = bounds
    }
}
