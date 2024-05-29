//
//  FacebookProvider.swift
//  remote
//
//  Created by damien on 10/12/2022.
//

import Foundation
import FirebaseAuth
import FacebookLogin

final class FacebookProvider: ProviderProtocol {
    
    @MainActor
    func signIn() async throws -> AuthCredential {
        try await withCheckedThrowingContinuation { continuation in
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { (result, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return continuation.resume(throwing: error!)
                }
                
                if !result!.isCancelled {
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    continuation.resume(returning: credential)
                }
            }
        }
    }
}
