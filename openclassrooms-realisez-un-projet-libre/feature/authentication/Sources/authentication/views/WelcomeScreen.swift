//
//  WelcomeScreen.swift
//  authentication
//
//  Created by damien on 05/11/2022.
//

import SwiftUI
import designsystem
import common
import model

///
/// Structure representing the View for the welcome screen
///
public struct WelcomeScreen: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @EnvironmentObject var authenticationRouter: AuthenticationRouter
    @Environment(\.locale) private var locale
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var height = CGFloat.zero
    @State var appeared: Bool = false
    @State var disappeared: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("welcome".localizedString(identifier: locale.identifier, bundle: Bundle.authentication))
                .foregroundColor(localColorScheme.primary)
                .textStyle(TypographyTokens.DisplaySmall)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: true, vertical: true)
                .frame(height: TypographyTokens.DisplaySmall.lineHeight.rawValue * 2,
                       alignment: .center)
                .padding(.bottom,
                          (UIScreen.inches > 4.7 ?
                           CGFloat(10.0).adjustHeight() :
                            10.0 * (UIScreen.main.nativeBounds.height) / 2796))
        }
        .opacity(appeared ? 1 : 0)
        .animation(.easeInOut(duration: 1.0), value: disappeared ? true : false)
        .onAppear { appeared = true }
        .onDisappear {
            disappeared = true
            appeared = false
        }
    }
}

public struct WelcomeScreen_Previews : PreviewProvider {
    public static var previews: some View {
        UIElementPreview(WelcomeScreen().environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.both,
                         multiLanguage: true,
                         landscapeMode: true,
                         previewLayout: PreviewLayout.device,
                         bundle: Bundle.authentication)
    }
}
