//
//  OlaRemoteFirebase.swift
//  remote
//
//  Created by damien on 24/10/2022.
//

import Foundation
import Combine
import FirebaseAuth
import model

///
/// Protocol defining methods for the Remote Firebase.
///
public protocol OlaRemoteFirebase {
    
    /// SignIn a User with a ``AuthProvider``
    ///
    /// - Parameters:
    ///   - authProvider: The ``AuthProvider`` of the user
    ///
    /// - Returns: A ``RemoteUser`` or throws an Error
    func signIn(with authProvider: AuthProvider) async throws -> RemoteUser
    
    /// SignIn an User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: A ``RemoteUser`` or throws an Error
    func signIn(withEmail email: String, password: String) async throws -> RemoteUser
    
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
    /// - Returns: Nothing or throws an Error
    func create(user: RemoteUser, password: String) async throws -> RemoteUser
    
    /// Delete current user
    ///
    /// - Returns: Void or throws an Error
    func deleteCurrentUser() async throws
    
    /// Save or update an Favourite to remote
    ///
    /// - Parameters:
    ///   - favourite: A ``RemoteFavourite``
    func createOrUpdate(group: RemoteBookmarkGroup) async throws
    
    func remove(group: RemoteBookmarkGroup) async throws
    
    func createOrUpdate(bookmark: RemoteBookmark) async throws
    
    func remove(bookmark: RemoteBookmark) async throws
}
