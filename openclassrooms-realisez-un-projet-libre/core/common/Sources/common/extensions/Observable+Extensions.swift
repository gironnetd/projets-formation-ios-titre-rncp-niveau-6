//
//  Observable+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 29/11/2023.
//

import Foundation
import SwiftUI

public class BoolObservable: ObservableObject {
    @Published public var value: Bool
    
    public init(value: Bool) {
        self.value = value
    }
}
