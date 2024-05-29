//
//  OlaUser.swift
//  navigation
//
//  Created by Damien Gironnet on 14/10/2023.
//

import Foundation
import model

public class OlaUser: ObservableObject {
    @Published public var user: User?
    
    public init(user: User? = nil) {
        self.user = user
    }
}
