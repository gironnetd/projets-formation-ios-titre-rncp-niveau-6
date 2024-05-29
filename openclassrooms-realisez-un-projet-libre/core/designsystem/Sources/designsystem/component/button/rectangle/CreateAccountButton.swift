//
//  CreateAccountButton.swift
//  designsystem
//
//  Created by Damien Gironnet on 12/02/2023.
//

import Foundation
import SwiftUI
import common

///
/// Structure representing create account button 
///
public struct CreateAccountButton: RectangleButton {
    
    @Environment(\.colorScheme) internal var colorScheme
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
        
    internal var action: ButtonAction = .create
    internal var signIn: () async throws -> Void
    
    public init(signIn: @escaping () async throws -> Void) {
        self.signIn = signIn
    }
}

public struct CreateAccountButton_Previews : PreviewProvider {
    public static var previews: some View {
        
        UIElementPreview(CreateAccountButton { print("Click on CreateAccountButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CreateAccountButton { print("Click on CreateAccountButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CreateAccountButton { print("Click on CreateAccountButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CreateAccountButton { print("Click on CreateAccountButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
    }
}
