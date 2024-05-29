//
//  AuthErrorCode+Extension.swift
//  remote
//
//  Created by Damien Gironnet on 09/03/2023.
//

import Foundation
import FirebaseAuth
import common

public extension AuthErrorCode {

    var errorMessage: String {
        switch self.code {
        case .emailAlreadyInUse:
            return "emailAlreadyInUse".localizedString(identifier: Locale.current.identifier, bundle: Bundle.remote)
        case .invalidEmail:
            return "invalidEmail".localizedString(identifier: Locale.current.identifier, bundle: Bundle.remote)
        case .userNotFound:
            return "userNotFound".localizedString(identifier: Locale.current.identifier, bundle: Bundle.remote)
        case .networkError:
            return "networkError".localizedString(identifier: Locale.current.identifier, bundle: Bundle.remote)
        case .missingEmail:
            return "missingEmail".localizedString(identifier: Locale.current.identifier, bundle: Bundle.remote)
        case .weakPassword:
            return "weakPassword".localizedString(identifier: Locale.current.identifier, bundle: Bundle.remote)
        case .wrongPassword:
            return "wrongPassword".localizedString(identifier: Locale.current.identifier, bundle: Bundle.remote)
        default:
            return "unknownError".localizedString(identifier: Locale.current.identifier, bundle: Bundle.remote)
        }
    }
}
