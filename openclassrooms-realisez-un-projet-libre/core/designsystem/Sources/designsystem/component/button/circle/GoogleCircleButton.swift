//
//  GoogleCircleButton.swift
//  designsystem
//
//  Created by damien on 03/12/2022.
//

import Foundation
import SwiftUI
import common

///
/// Structure representing circle Google signin button
///
public struct CircleGoogleSignInButton: CircleButton {
    
    @Environment(\.colorScheme) internal var colorScheme
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    internal var provider: Provider = .google
    internal var height: CGFloat = CGFloat(30.0).adjustImage()
    internal var width: CGFloat = CGFloat(30.0).adjustImage()
    internal var signIn: () async throws -> Void
    
    public init(signIn: @escaping () async throws -> Void) {
        self.signIn = signIn
    }
}

internal struct CircleGoogleSignInButton_Previews : PreviewProvider {
    static var previews: some View {
        UIElementPreview(CircleGoogleSignInButton { print("Click on CircleGoogleSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleGoogleSignInButton { print("Click on CircleGoogleSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleGoogleSignInButton { print("Click on CircleGoogleSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleGoogleSignInButton { print("Click on CircleGoogleSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
    }
}
