//
//  AuthenticationView.swift
//  authentication
//
//  Created by damien on 02/12/2022.
//

import SwiftUI
import FirebaseAuth
import designsystem
import common
import remote
import Combine
import model
import ui
import navigation

struct ErrorMessage: Identifiable {
    var id: String { message }
    let message: String
}

///
/// Structure representing the View for the authentication view
///
public struct AuthenticationView: View {
        
    @ObservedObject private var authenticationRouter: AuthenticationRouter = AuthenticationRouter()
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.locale) private var locale
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var size: CGSize = .zero
    @State private var isKeyboardShowing: Bool = false
    @State private var isScreenHidden: Bool = false
    @State private var errorMessage: ErrorMessage?
    
    private let authenticationViewModel: AuthenticationViewModel
    
    private let welcomeScreen: WelcomeScreen = WelcomeScreen()
    private let signInScreen: SignInScreen = SignInScreen()
    private let signUpScreen: SignUpScreen = SignUpScreen()
    
    public init() {
        self.authenticationViewModel = AuthenticationViewModel()
    }
    
    @ViewBuilder var content: some View {
        switch authenticationRouter.currentScreen {
        case .signin:
            if isScreenHidden {
                signInScreen
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
            } else {
                signInScreen
            }
        case .signup:
            if isScreenHidden {
                signUpScreen
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
            } else {
                signUpScreen
            }
        }
    }
    
    @ViewBuilder var footer: some View {
        VStack(spacing: 10) {
            switch authenticationRouter.currentScreen {
            case .signin:
                SignInButton {
                    do {
                        let _  = try await self.authenticationViewModel.signIn(
                            withEmail: signInScreen.emailTextField.email.value,
                            password: signInScreen.enterPasswordTextField.password.value)
                        SheetUiState.shared.isShowing = false
                    } catch {
//                        let authErrorCode = AuthErrorCode(_nsError: error as NSError)
//                        print(authErrorCode.errorMessage)
//                        errorMessage = ErrorMessage(message: authErrorCode.errorMessage)
                    }
                }.padding(.bottom, 6)
            case .signup:
                CreateAccountButton {
                    do {
                        let _  = try await self.authenticationViewModel
                            .create(user: model.User(id: UUID().uuidString,
                                                     providerID: AuthProvider.password.rawValue,
                                                     uidUser: nil,
                                                     email: signUpScreen.emailTextField.email.value,
                                                     displayName: signUpScreen.usernameTextField.username.value,
                                                     photo: nil,
                                                     bookmarks: []),
                                    password: signUpScreen.setPasswordTextField.password.value)
                        SheetUiState.shared.isShowing = false
                    } catch {
//                        let authErrorCode = AuthErrorCode(_nsError: error as NSError)
//                        print(authErrorCode.errorMessage)
//                        errorMessage = ErrorMessage(message: authErrorCode.errorMessage)
                    }
                }.padding(.bottom, 6)
            }
            
            HStack(spacing: CGFloat(16.0).adjustHorizontalPadding()) {
                VStack {
                    Divider()
                        .frame(height: 1.0)
                        .background(colorScheme == .light ? Color.gray : Color.white)
                }
                
                Text("sign_in_with".localizedString(identifier: locale.identifier, bundle: Bundle.authentication))
                    .bold()
                    .foregroundColor(colorScheme == .light ? .gray : .white)
                    .textStyle(isTablet ? TypographyTokens.BodyLarge : TypographyTokens.BodyLarge)
                    .fixedSize()
                
                VStack {
                    Divider()
                        .frame(height: 1.0)
                        .background(colorScheme == .light ? Color.gray : Color.white)
                }
            }

            HStack(spacing: CGFloat(16.0).adjustHorizontalPadding()) {
                CircleGoogleSignInButton {
                    do {
                        let _  = try await self.authenticationViewModel.signIn(with: .google)
                        SheetUiState.shared.isShowing = false
                    } catch {
//                        let authErrorCode = AuthErrorCode(_nsError: error as NSError)
//                        print(authErrorCode.errorMessage)
//                        errorMessage = ErrorMessage(message: authErrorCode.errorMessage)
                    }
                }
                CircleTwitterSignInButton {
                    do {
                        let _  = try await self.authenticationViewModel.signIn(with: .twitter)
                        SheetUiState.shared.isShowing = false
                    } catch {
//                        let authErrorCode = AuthErrorCode(_nsError: error as NSError)
//                        print(authErrorCode.errorMessage)
//                        errorMessage = ErrorMessage(message: authErrorCode.errorMessage)
                    }
                }
                CircleFacebookSignInButton {
                    do {
                        let _  = try await self.authenticationViewModel.signIn(with: .facebook)
                        SheetUiState.shared.isShowing = false
                    } catch {
//                        let authErrorCode = AuthErrorCode(_nsError: error as NSError)
//                        print(authErrorCode.errorMessage)
//                        errorMessage = ErrorMessage(message: authErrorCode.errorMessage)
                    }
                }
                CircleAppleSignInButton {
                    do {
                        let _  = try await self.authenticationViewModel.signIn(with: .apple)
                        SheetUiState.shared.isShowing = false
                    } catch {
//                        let authErrorCode = AuthErrorCode(_nsError: error as NSError)
//                        print(authErrorCode.errorMessage)
//                        errorMessage = ErrorMessage(message: authErrorCode.errorMessage)
                    }
                }
            }
            
            HStack(spacing: CGFloat(10.0).adjustHorizontalPadding()) {
                switch authenticationRouter.currentScreen {
                case .signin:
                    Text("no_account".localizedString(identifier: locale.identifier, bundle: Bundle.authentication))
                        .bold()
                        .foregroundColor(colorScheme == .light ? .gray : .white)
                        .textStyle(isTablet ? TypographyTokens.BodyLarge : TypographyTokens.BodyLarge)
                default:
                    Text("already_account".localizedString(identifier: locale.identifier, bundle: Bundle.authentication))
                        .bold()
                        .foregroundColor(colorScheme == .light ? .gray : .white)
                        .textStyle(isTablet ? TypographyTokens.BodyLarge : TypographyTokens.BodyLarge)
                }
                
                VStack {
                    Button(action: {
                        switch authenticationRouter.currentScreen {
                        case .signin:
                            isScreenHidden = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isScreenHidden = false
                                self.authenticationRouter.currentScreen = .signup
                            }
                        default:
                            isScreenHidden = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isScreenHidden = false
                                self.authenticationRouter.currentScreen = .signin
                            }
                        }
                    }, label: {
                        switch authenticationRouter.currentScreen {
                        case .signup:
                            Text("sign_in".localizedString(identifier: locale.identifier, bundle: Bundle.authentication))
                                .bold()
                                .foregroundColor(colorScheme == .light ? localColorScheme.primary
                                                 : localColorScheme.primary)
                                .textStyle(isTablet ? TypographyTokens.BodyLarge : TypographyTokens.BodyLarge)
                        case .signin:
                            Text("sign_up".localizedString(identifier: locale.identifier, bundle: Bundle.authentication))
                                .bold()
                                .foregroundColor(colorScheme == .light ? localColorScheme.primary
                                                 : localColorScheme.primary)
                                .textStyle(isTablet ? TypographyTokens.BodyLarge : TypographyTokens.BodyLarge)
                        }
                    })
                }
            }
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            content
                .padding(
                    .bottom,
                    (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                    CGFloat(20.0).adjustPadding() : 0)
                .padding(.top, isTablet ? 20 : orientation.isLandscape ? 16 : 0)
            footer.padding(.top, isTablet || orientation.isPortrait ? 30 : 20)
        }
        .padding(.horizontal, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                 CGFloat(isTablet ? 30.0 : 20.0) :
                    CGFloat(isTablet ? 30.0 : 20.0))
        .padding(.top, orientation == .portrait ? geometry.safeAreaInsets.bottom : CGFloat(10.0).adjustVerticalPadding())
        .padding(.bottom, isTablet ? 44.0 : geometry.safeAreaInsets.bottom)
        .modifier(SizeModifier())
        .edgesIgnoringSafeArea(.bottom)
        .onPreferenceChange(SizePreferenceKey.self) { value in
            guard value.width != 0 && value.height != 0 else { return }
            
            DispatchQueue.main.async {
                self.size = value
            }
        }
    }
}

internal struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            OlaTheme(darkTheme: .systemDefault) {
                AuthenticationView().environmentObject(AuthenticationRouter())
                    .OlaBackground()
            }
            .preferredColorScheme(.light)
            .environment(\.locale, .init(identifier: "French"))
            .previewInterfaceOrientation(.portrait)
            .previewDisplayName("Preview Portrait")
            
            OlaTheme(darkTheme: .systemDefault) {
                AuthenticationView().environmentObject(AuthenticationRouter())
                    .OlaBackground()
            }
            .preferredColorScheme(.light)
            .environment(\.locale, .init(identifier: "French"))
            .previewInterfaceOrientation(.portraitUpsideDown)
            .previewDisplayName("Preview PortraitUpsideDown")
            
            OlaTheme(darkTheme: .systemDefault) {
                AuthenticationView().environmentObject(AuthenticationRouter())
                    .OlaBackground()
            }
            .preferredColorScheme(.light)
            .environment(\.locale, .init(identifier: "French"))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Preview Landscape Left")
            
            OlaTheme(darkTheme: .systemDefault) {
                AuthenticationView().environmentObject(AuthenticationRouter())
                    .OlaBackground()
            }
            .preferredColorScheme(.light)
            .environment(\.locale, .init(identifier: "French"))
            .previewInterfaceOrientation(.landscapeRight)
            .previewDisplayName("Preview Landscape Right")
        }
    }
}
