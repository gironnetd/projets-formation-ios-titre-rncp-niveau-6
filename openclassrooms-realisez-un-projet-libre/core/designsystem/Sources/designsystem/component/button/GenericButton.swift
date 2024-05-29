//
//  GenericButton.swift
//  designsystem
//
//  Created by Damien Gironnet on 10/03/2023.
//

import Foundation
import SwiftUI

///
/// Protocol for all type of buttons
///
protocol GenericButton: View {
    var colorScheme: ColorScheme { get }
    var localColorScheme: OlaColorScheme { get }
    var signIn: () async throws -> Void { get set }
}
