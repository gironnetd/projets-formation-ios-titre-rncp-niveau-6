//
//  TestBookRepository.swift
//  testing
//
//  Created by Damien Gironnet on 26/07/2023.
//

import Foundation
import data
import remote
import model
import Combine

///
/// Implementation of BookRepository Protocol for Testing
///
public class TestBookRepository: BookRepository {
    
    public var books: [model.Book]
    public var themes: [model.Theme]
    
    public init(books: [model.Book] = [], themes: [model.Theme] = []) {
        self.books = books
        self.themes = themes
    }
    
    public func findBook(byIdBook idBook: String) -> AnyPublisher<model.Book, Error> {
        Future { promise in
            guard let book = self.books.filter({ book in book.idBook == idBook }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(book))
        }.eraseToAnyPublisher()
    }
    
    public func findBooks(byName name: String) -> AnyPublisher<[model.Book], Error> {
        Future { promise in
            guard let books = Optional(self.books.filter({ book in book.name == name })), books.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard books.count == 1, let book = books.first, book.idRelatedBooks!.isNotEmpty else {
                return promise(.success(books))
            }
            
            promise(
                .success(
                    book.idRelatedBooks!
                        .reduce(into: [model.Book](arrayLiteral: book)) { result, idBook in
                            if let book = self.books.filter({ book in book.idBook == idBook }).first {
                                result.append(book)
                            }
                        }
                )
            )
        }.eraseToAnyPublisher()
    }
    
    public func findBooks(byIdMovement idMovement: String) -> AnyPublisher<[model.Book], Error> {
        Future { promise in
            guard let books = Optional(self.books.filter({ book in book.idMovement == idMovement })), books.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(books))
        }.eraseToAnyPublisher()
    }
    
    public func findBooks(byIdTheme idTheme: String) -> AnyPublisher<[model.Book], Error> {
        Future { promise in
            guard let books = Optional(self.themes.filter({ theme in theme.idTheme == idTheme}))?.first?.books, books.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(books))
        }.eraseToAnyPublisher()
    }
    
    public func findBook(byIdPresentation idPresentation: String) -> AnyPublisher<model.Book, Error> {
        Future { promise in
            guard let presentations = Optional(self.books.compactMap({ author in author.presentation })),
                  let presentation = presentations.filter({ presentation in presentation.idPresentation == idPresentation }).first,
                  let book = self.books.filter({ book in book.presentation == presentation }).first
            else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(book))
        }.eraseToAnyPublisher()
    }
    
    public func findBook(byIdPicture idPicture: String) -> AnyPublisher<model.Book, Error> {
        Future { promise in
            guard let pictures = Optional(self.books.compactMap { book in book.pictures }.flatMap { $0 }),
                  let picture = pictures.filter({ picture in picture.idPicture == idPicture }).first,
                  let book = self.books.filter({ book in book.pictures!.contains(picture)}).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(book))
        }.eraseToAnyPublisher()
    }
    
    public func findAllBooks() -> AnyPublisher<[model.Book], Error> {
        Future { promise in
            guard self.books.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(self.books))
        }.eraseToAnyPublisher()
    }
}
