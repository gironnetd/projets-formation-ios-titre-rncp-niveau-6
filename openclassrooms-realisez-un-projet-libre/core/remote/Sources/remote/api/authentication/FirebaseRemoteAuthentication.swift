//
//  FirebaseRemoteAuthentication.swift
//  remote
//
//  Created by damien on 26/09/2022.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift
import Factory
import common

/**
 * Default Implementation for the Remote Authentication Protocol.
 */
public class FirebaseRemoteAuthentication: OlaRemoteAuthentication {
    
    private let firebaseAuth: Auth
        
    public init() {
        self.firebaseAuth = Auth.auth()
    }
    
    public init(firebaseAuth: Auth) {
        self.firebaseAuth = firebaseAuth
    }
    
    /// SignIn a User with a ``AuthProvider``
    ///
    /// - Parameters:
    ///   - authProvider: The ``AuthProvider` of the user
    ///
    /// - Returns: A User or throws an Error
    public func signIn(with authProvider: AuthProvider) async throws -> User {
        var provider: ProviderProtocol
        
        switch authProvider {
        case .apple:
            provider = AppleProvider()
        case .facebook:
            provider = FacebookProvider()
        case .google:
            provider = GoogleProvider()
        case .twitter:
            provider = TwitterProvider()
        default:
            provider = AppleProvider()
        }
        
        do {
            let credential = try await provider.signIn()
            let authResult = try await self.firebaseAuth.signIn(with: credential)
            
            return authResult.user
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
    public func signIn(withEmail email: String, password: String) async throws -> User {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                guard email.isNotEmpty else {
                    return continuation.resume(throwing: NSError(domain: "", code: AuthErrorCode.missingEmail.rawValue))
                }
            
                self.firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
                    guard let authResult = authResult, error == nil else {
                        return continuation.resume(throwing: error!)
                    }
                    
                    return continuation.resume(returning: authResult.user)
                }
            }
        } catch {
            throw error
        }
    }
    
    /// SignOut current User
    ///
    /// - Returns: Void or throws an Error
    public func signOut() async throws {
        do {
            try self.firebaseAuth.signOut()
        } catch {
            throw error
        }
    }
    
    /// Create a User with email and password, from remote
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: A User or throws an Error
    public func createUser(withEmail email: String, password: String) async throws -> User {
        let authResult = try await self.firebaseAuth.createUser(withEmail: email, password: password)
        return authResult.user
    }
    
    /// Delete a User
    ///
    /// - Parameters:
    ///   - uid: The user to delete
    public func deleteUser(byUser user: User) async throws {
        do {
            try await user.delete()
        } catch {
            throw error
        }
    }
}
