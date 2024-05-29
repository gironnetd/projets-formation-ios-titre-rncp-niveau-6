//
//  TwitterCircleButton.swift
//  designsystem
//
//  Created by damien on 03/12/2022.
//

import Foundation
import SwiftUI
import common

///
/// Structure representing circle Twitter signin button
///
public struct CircleTwitterSignInButton: CircleButton {
    
    @Environment(\.colorScheme) internal var colorScheme
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    internal var provider: Provider = .twitter
    internal var height: CGFloat = CGFloat(30.0).adjustImage()
    internal var width: CGFloat = CGFloat(30.0).adjustImage()
    internal var signIn: () async throws -> Void
    
    public init(signIn: @escaping () async throws -> Void) {
        self.signIn = signIn
    }
}

internal struct CircleTwitterSignInButton_Previews : PreviewProvider {
    static var previews: some View {
        UIElementPreview(CircleTwitterSignInButton { print("Click on CircleTwitterSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleTwitterSignInButton { print("Click on CircleTwitterSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleTwitterSignInButton { print("Click on CircleTwitterSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.none,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
        
        UIElementPreview(CircleTwitterSignInButton { print("Click on CircleTwitterSignInButton") }.environmentObject(OlaColorScheme(themeBrand: .secondary)),
                         darkMode: DarkMode.only,
                         multiLanguage: false,
                         landscapeMode: false,
                         bundle: Bundle.designsystem)
    }
}
