//
//  GoogleProvider.swift
//  remote
//
//  Created by damien on 10/12/2022.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import navigation
import Factory

enum FetchError: Error {
    case noMessages
}

final class GoogleProvider: ProviderProtocol {
    
    @Injected(\.mainViewController) var mainViewController
    
    @MainActor
    func signIn() async throws -> AuthCredential {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                guard let clientID = FirebaseApp.app()?.options.clientID
                else { return continuation.resume(throwing: FetchError.noMessages) }
                
                let config = GIDConfiguration(clientID: clientID)
                
                GIDSignIn.sharedInstance.configuration = config
                
                GIDSignIn.sharedInstance.signIn(withPresenting: mainViewController, completion: { result, error in
                    guard error == nil else { return continuation.resume(throwing: error!) }
                    
                    guard let idToken = result?.user.idToken, let accessToken = result?.user.accessToken
                    else { return }
                    print(Thread.current)
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
                    continuation.resume(returning: credential)
                })
                
//                GIDSignIn.sharedInstance.signIn(withPresenting: mainViewController) { result, error in
//                    guard error == nil else { return continuation.resume(throwing: error!) }
//                    
//                    guard let authentication = result.user.authentication, let idToken = authentication.idToken
//                    else { return }
//                    print(Thread.current)
//                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
//                    continuation.resume(returning: credential)
//                }
            }
        } catch {
            print(error)
            throw error
        }
    }
}
