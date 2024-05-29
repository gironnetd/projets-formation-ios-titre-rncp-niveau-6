//
//  AppleProvider.swift
//  remote
//
//  Created by damien on 10/12/2022.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import Factory
import navigation

final class AppleProvider: ProviderProtocol {

    @Injected(\.mainViewController) var mainViewController

    // Unhashed nonce.
    fileprivate var currentNonce: String?

    func signIn() async -> AuthCredential {
        await withCheckedContinuation { continuation in
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)

            if let mainViewController = mainViewController as? AppleSignInSucceeded {
                mainViewController.currentNonce = nonce
                mainViewController.signInSucceeded = { credential in
                    continuation.resume(returning: credential)
                }
            }

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = mainViewController as? ASAuthorizationControllerDelegate
            authorizationController.presentationContextProvider = mainViewController as? ASAuthorizationControllerPresentationContextProviding
            authorizationController.performRequests()
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
