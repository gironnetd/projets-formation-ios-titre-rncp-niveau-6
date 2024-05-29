//
//  DefaultOlaRemoteFirebase.swift
//  remote
//
//  Created by damien on 24/10/2022.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth
import Factory

///
/// Protocol defining methods for the Remote Firebase.
///
public class DefaultOlaRemoteFirebase: OlaRemoteFirebase {
    
    @LazyInjected(\.authentication) private var authentication
    @LazyInjected(\.firestore) private var firestore
    
    private var currentUser: User?
    
    public init() {}
    
    /// SignIn a User with a ``AuthProvider``
    ///
    /// - Parameters:
    ///   - authProvider: The ``AuthProvider`` of the user
    ///
    /// - Returns: A User or throws an Error
    @MainActor
    public func signIn(with authProvider: AuthProvider) async throws -> RemoteUser {
        do {
            self.currentUser = try await self.authentication.signIn(with: authProvider)
            let remoteUser = try await self.firestore.findUser(byUid: self.currentUser!.uid)
            
            return remoteUser
        } catch {
           throw error
        }
    }
    
    /// SignIn an User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: A User or throws an Error
    public func signIn(withEmail email: String, password: String) async throws -> RemoteUser {
        do {
            self.currentUser = try await self.authentication.signIn(withEmail: email, password: password)
            return try await self.firestore.findUser(byUid: self.currentUser!.uid)
        } catch {
            throw error
        }
    }
    
    private func createRemoteUser(from user: User) async throws -> RemoteUser {
        var currentUser = RemoteUser(
            uid: user.uid,
            providerID: user.providerData[0].providerID,
            email: user.providerData[0].email,
            displayName: user.providerData[0].displayName,
            photo: nil,
            bookmarks: nil)
        
        guard let photoUrl = user.photoURL else { return currentUser }
        
        currentUser.photo = try await URLSession.shared.data(from: photoUrl).0
        return currentUser
    }
    
    public func signOut() async throws {
        try await self.authentication.signOut()
        self.currentUser = nil
    }
    
    public func  create(user: RemoteUser, password: String) async throws -> RemoteUser {
        do {
            guard let email = user.email else { throw NSError(domain: "", code: 0, userInfo: nil) }
            
            self.currentUser = try await self.authentication.createUser(withEmail: email, password: password)
            
            try await self.firestore.saveOrUpdate(user: user)
            return user
        } catch {
            throw error
        }
    }
    
    public func deleteCurrentUser() async throws {
        guard let currentUser = self.currentUser else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        
        try await self.authentication.deleteUser(byUser: currentUser)
        try await self.firestore.deleteUser(byUid: currentUser.uid)
        self.currentUser = nil
    }
    
    public func createOrUpdate(group: RemoteBookmarkGroup) async throws {
        try await self.firestore.createOrUpdate(group: group)
    }
    
    public func remove(group: RemoteBookmarkGroup) async throws {
        try await self.firestore.remove(group: group)
    }
    
    public func createOrUpdate(bookmark: RemoteBookmark) async throws {
        try await self.firestore.createOrUpdate(bookmark: bookmark)
    }
    
    public func remove(bookmark: RemoteBookmark) async throws {
        try await self.firestore.remove(bookmark: bookmark)
    }
}
