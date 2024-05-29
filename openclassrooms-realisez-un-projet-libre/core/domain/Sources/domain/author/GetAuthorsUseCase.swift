//
//  GetAuthorsUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import Combine
import model
import data
import Factory

///
/// A use case which obtains an exhaustive Array of ``UserAuthor``
///
@dynamicCallable
public class GetAuthorsUseCase {
    
    @LazyInjected(\.authorRepository) private var authorRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository

    public init() {}
    
    public init(authorRepository: AuthorRepository) {
        self.authorRepository = authorRepository
    }
    
    public func dynamicallyCall(withArguments args: [Any]) -> AnyPublisher<[UserAuthor], Error> {
        Publishers.Zip(
            authorRepository.findAllAuthors(),
            userDataRepository.userData)
            .map { authors, userData in
                authors.filter { $0.language.prefix(2) == Locale.current.identifier.prefix(2) }
                    .sorted { $0.name.compare($1.name, locale: NSLocale.current) == .orderedAscending }
                    .map { UserAuthor(author: $0, userData: userData) }
            }
            .eraseToAnyPublisher()
    }
}
