//
//  GetBookByIdUseCase.swift
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
/// A use case which obtains a ``UserBook`` by Id
///
@dynamicCallable
public class GetBookByIdUseCase {
    
    @LazyInjected(\.bookRepository) private var bookRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository

    public init() {}
    
    public init(bookRepository: BookRepository) {
        self.bookRepository = bookRepository
    }
    
    public func dynamicallyCall(withArguments args: [String]) -> AnyPublisher<UserBook, Error> {
        guard let idBook = args.first else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return Publishers.CombineLatest(
            bookRepository.findBook(byIdBook: idBook),
            userDataRepository.userData)
        .map { book, userData in UserBook(book: book, userData: userData) }
        .eraseToAnyPublisher()
    }
}

