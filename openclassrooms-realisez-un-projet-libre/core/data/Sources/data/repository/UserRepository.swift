//
//  UserRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import remote

public protocol UserRepository {

    var user: CurrentValueSubject<User, Error>! { get set }
    
    /// SignIn a User with a AuthProvider
    ///
    /// - Parameters:
    ///   - authProvider: The AuthProvider of the user
    ///
    /// - Returns: A Model User or throws an Error
    func signIn(with authProvider: AuthProvider) async throws -> model.User
    
    /// SignIn a User with email and password
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: A Model User or throws an Error
    func signIn(withEmail email: String, password: String) async throws -> model.User
    
    /// SignOut current User
    ///
    /// - Returns: Void or throws an Error
    func signOut() async throws -> Void
    
    /// Create a User with email and password
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: Void or throws an Error
    func create(user: model.User, password: String) async throws -> model.User
    
    /// Retrieve current user, from the cache
    ///
    /// - Returns: A User or throws an Error
    func findCurrentUser() -> AnyPublisher<User, Error>
}
