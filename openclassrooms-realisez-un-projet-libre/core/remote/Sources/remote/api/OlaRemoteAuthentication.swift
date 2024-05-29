//
//  OlaRemoteAuthentication.swift
//  remote
//
//  Created by damien on 26/09/2022.
//

import Foundation
import Combine
import FirebaseAuth

///
/// Protocol defining methods for the Remote Authentication.
///
public protocol OlaRemoteAuthentication {
    
    /// SignIn a User with a ``AuthProvider``
    ///
    /// - Parameters:
    ///   - authProvider: The ``AuthProvider`` of the user
    ///
    /// - Returns: A  User or throws an Error
    func signIn(with authProvider: AuthProvider) async throws -> User
    
    /// SignIn an User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: A User or throws an Error
    func signIn(withEmail email: String, password: String) async throws -> User
    
    /// SignOut current User
    ///
    /// - Returns: Void or throws an Error
    func signOut() async throws
    
    /// Create a User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: A User or throws an Error
    func createUser(withEmail email: String, password: String) async throws -> User
    
    /// Delete a User
    ///
    /// - Parameters:
    ///   - uid: The user to delete
    ///
    /// - Returns: Void or throws an Error
    func deleteUser(byUser user: User) async throws
}
