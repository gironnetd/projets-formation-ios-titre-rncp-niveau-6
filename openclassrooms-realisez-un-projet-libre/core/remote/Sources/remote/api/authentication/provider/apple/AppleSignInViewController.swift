//
//  AppleSignInViewController.swift
//  remote
//
//  Created by Damien Gironnet on 28/02/2023.
//

import Foundation
import UIKit
import AuthenticationServices
import FirebaseAuth
import SwiftUI

protocol AppleSignInSucceeded: AnyObject {
    var signInSucceeded: ((AuthCredential) -> Void)? { get set }
    var currentNonce: String? { get set }
}

public class AppleSignInViewController<Content>: UIHostingController<Content>
, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, AppleSignInSucceeded
where Content: View {
    
    var currentNonce: String?
    var signInSucceeded: ((AuthCredential) -> Void)?
    
    public override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            if let signInSucceeded = signInSucceeded {
                signInSucceeded(credential)
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
