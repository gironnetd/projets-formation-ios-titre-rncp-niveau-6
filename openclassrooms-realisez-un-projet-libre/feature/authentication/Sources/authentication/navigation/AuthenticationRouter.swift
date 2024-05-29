//
//  AuthenticationRouter.swift
//  authentication
//
//  Created by damien on 02/12/2022.
//

import SwiftUI

///
/// ObservableObject used to share navigation state in authentication module
///
class AuthenticationRouter: ObservableObject {
    @Published var currentScreen: AuthenticationNavigation = .signin
}
