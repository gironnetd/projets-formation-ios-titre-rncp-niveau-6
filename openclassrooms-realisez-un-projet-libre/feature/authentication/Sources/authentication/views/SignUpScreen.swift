//
//  SignUpScreen.swift
//  authentication
//
//  Created by damien on 28/11/2022.
//

import SwiftUI
import designsystem
import common
import model

///
/// Structure representing the View for the signup screen
///
public struct SignUpScreen: View {
    
    @EnvironmentObject private var authenticationRouter: AuthenticationRouter
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.locale) private var locale
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isKeyboardShowing: Bool = false
    @State var appeared: Bool = false
    @State var disappeared: Bool = false
    @State public var email: String = ""
    @State private var password: String = ""
    
    internal let emailTextField: EmailTextField
    internal let usernameTextField: UsernameTextField
    internal let setPasswordTextField: PasswordTextField
    
    public init() {
        self.emailTextField = EmailTextField()
        self.usernameTextField = UsernameTextField()
        self.setPasswordTextField = PasswordTextField(passwordType: .set)
    }
    
    public var body: some View {
        VStack(spacing:
                (UIScreen.inches > 4.7 ?
                         CGFloat(12.0).adjustHeight() :
                          12.0 * (UIScreen.main.nativeBounds.height) / 2796))
        {
            self.usernameTextField
            self.emailTextField
            self.setPasswordTextField
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        UIElementPreview(SignUpScreen().environmentObject(OlaColorScheme(themeBrand: .primary)),
                         darkMode: DarkMode.both,
                         multiLanguage: true,
                         landscapeMode: true,
                         bundle: Bundle.authentication)
    }
}
