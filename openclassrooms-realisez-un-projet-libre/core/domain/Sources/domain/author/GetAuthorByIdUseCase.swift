//
//  GetAuthorByIdUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 14/08/2023.
//

import Foundation
import Combine
import model
import data
import Factory

///
/// A use case which obtains a``UserAuthor`` by  Id
///
@dynamicCallable
public class GetAuthorByIdUseCase {
    
    @LazyInjected(\.authorRepository) private var authorRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository

    public init() {}
    
    public init(authorRepository: AuthorRepository, userDataRepository: UserDataRepository) {
        self.authorRepository = authorRepository
        self.userDataRepository = userDataRepository
    }
    
    public func dynamicallyCall(withArguments args: [String]) -> AnyPublisher<UserAuthor, Error> {
        guard let idAuthor = args.first else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return Publishers.Zip(
            authorRepository.findAuthor(byIdAuthor: idAuthor),
            userDataRepository.userData)
        .map { author, userData in UserAuthor(author: author, userData: userData) }
        .eraseToAnyPublisher()
    }
}

