//
//  SignInButton.swift
//  designsystem
//
//  Created by damien on 08/11/2022.
//

import Foundation
import SwiftUI
import common

///
/// Structure representing signin button
///
public struct SignInButton: RectangleButton {
    
    @Environment(\.colorScheme) internal var colorScheme
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    internal var action: ButtonAction = .signin
    internal var signIn: () async throws -> Void
    
    public init(signIn: @escaping () async throws -> Void) {
        self.signIn = signIn
    }
}

public struct SignInButton_Previews : PreviewProvider {
    public static var previews: some View {
        
        UIElementPreview(SignInButton { print("Click on SignInButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.none,
                         multiLanguage: true,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)

        UIElementPreview(SignInButton { print("Click on SignInButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)

        UIElementPreview(SignInButton { print("Click on SignInButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.none,
                         multiLanguage: true,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)

        UIElementPreview(SignInButton { print("Click on SignInButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
    }
}
