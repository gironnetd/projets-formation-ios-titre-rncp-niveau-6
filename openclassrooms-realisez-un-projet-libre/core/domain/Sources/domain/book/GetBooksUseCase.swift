//
//  GetBooksUseCase.swift
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
/// A use case which obtains an exhaustive Array of ``UserBook``
///
@dynamicCallable
public class GetBooksUseCase {
    
    @LazyInjected(\.bookRepository) private var bookRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository

    public init() {}
    
    public init(bookRepository: BookRepository) {
        self.bookRepository = bookRepository
    }
    
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) -> AnyPublisher<[UserBook], Error> {
        Publishers.Zip(
            bookRepository.findAllBooks(),
            userDataRepository.userData)
            .map { books, userData in
                books.filter { $0.language.prefix(2) == Locale.current.identifier.prefix(2) }
                    .sorted { $0.name.compare($1.name, locale: NSLocale.current) == .orderedAscending }
                    .map { UserBook(book: $0, userData: userData) }
            }
            .eraseToAnyPublisher()
    }
}
