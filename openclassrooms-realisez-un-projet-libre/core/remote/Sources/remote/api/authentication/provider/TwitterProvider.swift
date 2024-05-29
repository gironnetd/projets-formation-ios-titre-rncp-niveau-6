//
//  TwitterProvider.swift
//  remote
//
//  Created by damien on 10/12/2022.
//

import Foundation
import FirebaseAuth

final class TwitterProvider: ProviderProtocol {
    
    private var provider: OAuthProvider?
    
    @MainActor
    func signIn() async throws -> AuthCredential {
        provider = OAuthProvider(providerID: AuthProvider.twitter.rawValue)
        
        defer {
            provider = nil
        }
        
        return try await provider!.credential(with: nil)
    }
}
