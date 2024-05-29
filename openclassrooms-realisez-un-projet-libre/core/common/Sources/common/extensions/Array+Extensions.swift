//
//  Array+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 25/08/2023.
//

import Foundation
import SwiftUI

public extension Array {

    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    func partition(_ predicate: (Element) -> Bool) -> ([Element], [Element]) {
        var first = [Element]()
        var second = [Element]()
        for element in self {
            if (predicate(element)) {
                first.append(element)
            } else {
                second.append(element)
            }
        }
        return (first, second)
    }
}

public extension Array where Element: Equatable {
    func contains(_ element: Element) -> Binding<Bool> {
        Binding.constant(self.contains(where: { $0 == element }))
    }
}
