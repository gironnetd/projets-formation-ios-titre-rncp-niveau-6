//
//  SignInWithEmailAnddPasswordUseCase.swift
//  domain
//
//  Created by damien on 05/11/2022.
//

import Foundation
import Combine
import model
import data
import Factory

///
/// A use case which signin with email and password
///
@dynamicCallable
public class SignInWithEmailAndPasswordUseCase {
    
    @LazyInjected(\.userRepository) private var userRepository
    
    public init() {}
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) async throws -> model.User {
        guard let email = args.firstIndex(where: { $0.key == "email" }),
              let password = args.firstIndex(where: { $0.key == "password" }) else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        
        do {
            return try await self.userRepository.signIn(withEmail: args[email].value, password: args[password].value)
        } catch {
            throw error
        }
    }
}
