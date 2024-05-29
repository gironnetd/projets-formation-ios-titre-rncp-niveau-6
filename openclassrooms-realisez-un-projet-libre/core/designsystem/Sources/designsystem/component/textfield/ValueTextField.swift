//
//  ValueTextField.swift
//  designsystem
//
//  Created by Damien Gironnet on 07/03/2023.
//

import Foundation
import SwiftUI

public class ValueTextField: ObservableObject {
    @Published public var value: String = ""
    
    public init() {}
    
    public init(value: String) {
        self.value = value
    }
}

public class EditedTextField: ObservableObject {
    @Published public var value: Bool = false
}
