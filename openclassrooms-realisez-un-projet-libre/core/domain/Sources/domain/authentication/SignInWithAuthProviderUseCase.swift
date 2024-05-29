//
//  SignInWithAuthProviderUseCase.swift
//  domain
//
//  Created by damien on 10/12/2022.
//

import Foundation
import model
import data
import remote
import Factory

///
/// A use case which signin with AuthProvider enum
///
@dynamicCallable
public class SignInWithAuthProviderUseCase {
    
    @LazyInjected(\.userRepository) private var userRepository
    
    public init() {}
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func dynamicallyCall(withArguments args: [AuthProvider]) async throws -> model.User {
        guard let authProvider = args.first else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        
        do {
            return try await self.userRepository.signIn(with: authProvider)
        } catch {
            throw error
        }
    }
}
