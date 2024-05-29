//
//  TestOlaRemoteFirebase.swift
//  dataTests
//
//  Created by damien on 31/10/2022.
//

import Foundation
import Combine
import remote
import FirebaseAuth
import util

class TestOlaRemoteFirebase: OlaRemoteFirebase {
    
    internal var currentUser: RemoteUser?
    internal var users: [RemoteUser]  = []
    internal var emailPassword: [(email: String, password: String)] = []
    
    func create(user: remote.RemoteUser, password: String) async throws -> remote.RemoteUser {
        RemoteUser(uid: DataFactory.randomString(),
                   providerID: DataFactory.randomString(),
                   email: DataFactory.randomString(),
                   displayName: DataFactory.randomString(),
                   photo: nil,
                   bookmarks: nil)
    }
    
    func createOrUpdate(group: RemoteBookmarkGroup) async throws {}
    
    func remove(group: RemoteBookmarkGroup) async throws {}
    
    func createOrUpdate(bookmark: RemoteBookmark) async throws {}
    
    func remove(bookmark: RemoteBookmark) async throws {}
    
    func signIn(with authProvider: remote.AuthProvider) async throws -> remote.RemoteUser {
        guard let currentUser = self.currentUser else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return currentUser
    }
    
    func signIn(withEmail email: String, password: String) async throws -> remote.RemoteUser {
        guard let currentUser = self.currentUser else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return currentUser
    }
    
    func create(user: remote.RemoteUser, password: String) async throws {
        currentUser = RemoteUser.testUser()
        currentUser?.email = user.email
    }
    
    public func signOut() async throws {
        guard self.currentUser != nil else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        self.currentUser = nil
    }
    
    public func deleteCurrentUser() async throws {
        guard self.currentUser != nil else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        self.currentUser = nil
    }
}
