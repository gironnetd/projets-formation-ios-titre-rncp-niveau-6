//
//  ProviderProtocol.swift
//  remote
//
//  Created by damien on 10/12/2022.
//

import Foundation
import FirebaseAuth

protocol ProviderProtocol {
    func signIn() async throws -> AuthCredential
}
