//
//  SignInScreen.swift
//  authentication
//
//  Created by damien on 28/11/2022.
//

import SwiftUI
import designsystem
import common
import model

///
/// Structure representing the View for the signin screen
///
public struct SignInScreen: View {
    
    @EnvironmentObject private var authenticationRouter: AuthenticationRouter
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.locale) private var locale
    @Environment(\.colorScheme) private var colorScheme
    
    @State var appeared: Bool = false
    @State var disappeared: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var height = CGFloat.zero
    @State private var isKeyboardShowing: Bool = false
    
    internal let emailTextField: EmailTextField
    internal let enterPasswordTextField: PasswordTextField
    
    public init() {
        self.emailTextField = EmailTextField()
        self.enterPasswordTextField = PasswordTextField(passwordType: .enter)
    }
    
    public var body: some View {
        VStack(spacing:
                (UIScreen.inches > 4.7 ?
                         CGFloat(12.0).adjustHeight() :
                          12.0 * (UIScreen.main.nativeBounds.height) / 2796))
        {
            emailTextField
            enterPasswordTextField
        }

    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        UIElementPreview(SignInScreen()
                            .environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.both,
                         multiLanguage: true,
                         landscapeMode: true,
                         previewLayout: PreviewLayout.sizeThatFits,
                         bundle: Bundle.authentication)
    }
}
