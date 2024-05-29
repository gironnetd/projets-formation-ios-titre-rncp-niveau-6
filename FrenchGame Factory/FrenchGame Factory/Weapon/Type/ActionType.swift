//
//  ActionType.swift
//  FrenchGame Factory
//
//  Created by damien on 25/05/2022.
//

import Foundation

//
// Enum that represents different actions enable by a weapon
//
enum ActionType {
    case healing((Character) -> Void)
    case damaging((Character) -> Void)
}
