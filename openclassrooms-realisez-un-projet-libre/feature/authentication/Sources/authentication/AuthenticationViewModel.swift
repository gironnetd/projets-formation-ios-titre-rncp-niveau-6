//
//  AuthenticationViewModel.swift
//  authentication
//
//  Created by damien on 05/11/2022.
//

import Foundation
import domain
import model
import remote
import Combine
import Factory
import navigation
import data
import ui

///
/// ObservableObject representing the viewmodel for authentication package
///
class AuthenticationViewModel: ObservableObject {
    
    @LazyInjected(\.mainRouter) var mainRouter
    @LazyInjected(\.signInWithAuthProviderUseCase) var signInWithAuthProvider
    @LazyInjected(\.signInWithEmailAndPasswordUseCase) var signInWithEmailAndPassword
    @LazyInjected(\.createUserWithUserAndPasswordUseCase) var createUserWithUserAndPassword
    @LazyInjected(\.userRepository) var userRepository
    
    public init() {}
    
    public init(userRepository: UserRepository) {
        self.signInWithAuthProvider = SignInWithAuthProviderUseCase(userRepository: userRepository)
        self.signInWithEmailAndPassword = SignInWithEmailAndPasswordUseCase(userRepository: userRepository)
        self.createUserWithUserAndPassword = CreateUserWithUserAndPasswordUseCase(userRepository: userRepository)
    }
    
    func signIn(with authProvider: AuthProvider) async throws -> User {
        try await self.signInWithAuthProvider(authProvider)
    }
    
    public func signIn(withEmail email: String, password: String) async throws -> User {
        try await self.signInWithEmailAndPassword(email: email, password: password)
    }
    
    public func create(user: User, password: String) async throws -> User {
        try await self.createUserWithUserAndPassword(with: (user: user, password: password))
    }
}
