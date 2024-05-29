//
//  CreateUserWithEmailAndPasswordUseCase.swift
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
/// A use case which create a user with User and password
///
@dynamicCallable
public class CreateUserWithUserAndPasswordUseCase {
    
    @LazyInjected(\.userRepository) private var userRepository
    
    public init() {}
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, (user: User, password: String)>) async throws -> model.User {
        guard let arguments = args.first?.value else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        
        do {
            return try await self.userRepository.create(user: arguments.user, password: arguments.password)
        } catch {
            throw error
        }
    }
}
