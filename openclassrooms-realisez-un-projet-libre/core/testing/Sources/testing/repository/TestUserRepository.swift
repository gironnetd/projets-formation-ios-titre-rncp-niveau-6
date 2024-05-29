//
//  TestUserRepository.swift
//  testing
//
//  Created by Damien Gironnet on 29/03/2023.
//

import Foundation
import data
import remote
import model
import Combine
import util

///
/// Implementation of UserRepository Protocol for Testing
///
public class TestUserRepository: UserRepository {
    public var user: CurrentValueSubject<model.User, Error>!
    
    public func findCurrentUser() -> AnyPublisher<model.User, Error> {
        Just(user.value).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public var currentUser: model.User?
    public var emailPasswordProvider: model.User
    public var authProviders: [model.User]

    public init(user: model.User, emailPasswordProvider: model.User, authProviders: [model.User]) {
        self.user = CurrentValueSubject(user)
        self.authProviders = authProviders
        self.emailPasswordProvider = emailPasswordProvider
    }
    
    public init(emailPasswordProvider: model.User, authProviders: [model.User]) {
        self.authProviders = authProviders
        self.emailPasswordProvider = emailPasswordProvider
    }
    
    public init(user: model.User) {
        self.currentUser = user
        self.user = CurrentValueSubject(user)
        self.emailPasswordProvider = model.User(id: DataFactory.randomString(), providerID: AuthProvider.password.rawValue, uidUser: DataFactory.randomString())
        self.authProviders = [
            model.User(id: DataFactory.randomString(), providerID: AuthProvider.twitter.rawValue, uidUser: DataFactory.randomString()),
            model.User(id: DataFactory.randomString(), providerID: AuthProvider.google.rawValue, uidUser: DataFactory.randomString()),
                    model.User(id: DataFactory.randomString(), providerID: AuthProvider.apple.rawValue, uidUser: DataFactory.randomString()),
            model.User(id: DataFactory.randomString(), providerID: AuthProvider.facebook.rawValue, uidUser: DataFactory.randomString()),
                    self.emailPasswordProvider]
    }
    
    public init() {
        self.emailPasswordProvider = model.User(id: UUID().uuidString, providerID: AuthProvider.password.rawValue, uidUser: DataFactory.randomString())
        self.authProviders = [
            model.User(id: UUID().uuidString, providerID: AuthProvider.twitter.rawValue, uidUser: DataFactory.randomString()),
            model.User(id: UUID().uuidString, providerID: AuthProvider.google.rawValue, uidUser: DataFactory.randomString()),
            model.User(id: UUID().uuidString, providerID: AuthProvider.apple.rawValue, uidUser: DataFactory.randomString()),
            model.User(id: UUID().uuidString, providerID: AuthProvider.facebook.rawValue, uidUser: DataFactory.randomString()),
                    self.emailPasswordProvider]
    }
    
    public func signIn(with authProvider: remote.AuthProvider) async throws -> model.User {
        guard let currentUser = authProviders.first(where: { user in user.providerID == authProvider.rawValue }) else {
            throw NSError(domain: "", code: 0)
        }
        self.user.value = currentUser
        
        return self.user.value
    }
    
    public func signIn(withEmail email: String, password: String) async throws -> model.User {
        guard email.isNotEmpty, password.isNotEmpty else {
            throw NSError(domain: "", code: 0)
        }
        
        guard emailPasswordProvider.email == email else {
            throw NSError(domain: "", code: 0)
        }
        
        self.user.value = emailPasswordProvider
        
        return self.emailPasswordProvider
    }
    
    public func signOut() async throws {
        self.user.value.providerID = ""
        self.user.value.displayName = ""
        self.user.value.email = ""
        self.user.value.uidUser = ""
    }
    
    public func create(user: model.User, password: String) async throws -> model.User {
        guard password.isNotEmpty else {
            throw NSError(domain: "", code: 0)
        }
        
        self.authProviders.append(user)
        
        return user
    }
    
    public func findCurrentUser() async throws -> model.User {
        guard let currentUser = currentUser else {
            throw NSError(domain: "", code: 0)
        }
        return currentUser
    }
    
    public func deleteCurrentUser() async throws {
        self.user.value.providerID = ""
        self.user.value.displayName = ""
        self.user.value.email = ""
        self.user.value.uidUser = ""
    }
}
