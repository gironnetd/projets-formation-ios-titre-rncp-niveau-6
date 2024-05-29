//
//  FacebookCircleButton.swift
//  designsystem
//
//  Created by damien on 03/12/2022.
//

import Foundation
import SwiftUI
import common

///
/// Structure representing circle Facebook signin button
///
public struct CircleFacebookSignInButton: CircleButton {
    
    @Environment(\.colorScheme) internal var colorScheme
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    internal var provider: Provider = .facebook
    internal var height: CGFloat = CGFloat(30.0).adjustImage()
    internal var width: CGFloat = CGFloat(30.0).adjustImage() * 54 / 100
    internal var signIn: () async throws -> Void
    
    public init(signIn: @escaping () async throws -> Void) {
        self.signIn = signIn
    }
}

internal struct CircleFacebookSignInButton_Previews : PreviewProvider {
    public static var previews: some View {
        
        UIElementPreview(CircleFacebookSignInButton { print("Click on CircleFacebookSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleFacebookSignInButton { print("Click on CircleFacebookSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleFacebookSignInButton { print("Click on CircleFacebookSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleFacebookSignInButton { print("Click on CircleFacebookSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
    }
}
