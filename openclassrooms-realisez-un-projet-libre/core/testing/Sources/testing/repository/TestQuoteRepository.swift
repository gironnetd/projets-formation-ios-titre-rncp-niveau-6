//
//  TestQuoteRepository.swift
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
/// Implementation of QuoteRepository Protocol for Testing
///
public class TestQuoteRepository: QuoteRepository {
    
    public func syncWith(synchronizer: data.Synchronizer) async throws -> Bool { true }
    
    public var quotes: [model.Quote]
    public var authors: [model.Author]
    public var books: [model.Book]
    public var movements: [model.Movement]
    public var themes: [model.Theme]
    
    public init(quotes: [model.Quote] = [], authors: [model.Author] = [], books: [model.Book] = [], movements: [model.Movement] = [], themes: [model.Theme] = []) {
        self.quotes = quotes
        self.authors = authors
        self.books = books
        self.movements = movements
        self.themes = themes
    }
    
    public func findQuote(byIdQuote idQuote: String) -> AnyPublisher<model.Quote, Error> {
        Future { promise in
            guard let quote = self.quotes.filter({ quote in quote.idQuote == idQuote }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(quote))
        }.eraseToAnyPublisher()
    }
    
    public func findQuotes(byIdAuthor idAuthor: String) -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard let quotes = self.authors.filter({ author in author.idAuthor == idAuthor }).first?.quotes,
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes))
        }.eraseToAnyPublisher()
    }
    
    public func findQuotes(byAuthor name: String) -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard let authors = Optional(self.authors.filter({ author in author.name == name })),
                  let quotes = Optional(authors.compactMap({ author in author.quotes })),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes.flatMap{ $0 }))
        }.eraseToAnyPublisher()
    }
    
    public func findQuotes(byIdBook idBook: String) -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard let quotes = self.books.filter({ book in book.idBook == idBook }).first?.quotes, quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes))
        }.eraseToAnyPublisher()
    }
    
    public func findQuotes(byBook name: String) -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard let books = Optional(self.books.filter({ book in book.name == name })),
                  let quotes = Optional(books.compactMap({ book in book.quotes })),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes.flatMap{ $0 }))
        }.eraseToAnyPublisher()
    }
    
    public func findQuotes(byIdMovement idMovement: String) -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first,
                  let quotes = Optional(
                    movement.authors!.compactMap { author in author.quotes } +
                    movement.books!.compactMap { book in book.quotes }
                  ),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes.flatMap{ $0 }))
        }.eraseToAnyPublisher()
    }
    
    public func findQuotes(byMovement name: String) -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard let movements = Optional(self.movements.filter({ movement in movement.name == name })),
                  movements.isNotEmpty,
                  let quotes = Optional(
                    movements.flatMap { movement in
                        movement.authors!.compactMap { author in author.quotes } +
                        movement.books!.compactMap { book in book.quotes }
                    }
                  ), quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(quotes.flatMap{ $0 }))
        }.eraseToAnyPublisher()
    }
    
    public func findQuotes(byIdTheme idTheme: String) -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard let theme = self.themes.filter({ theme in theme.idTheme == idTheme }).first,
                  let quotes = Optional(
                    theme.authors!.compactMap { author in author.quotes } +
                    theme.books!.compactMap { book in book.quotes }
                  ),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes.flatMap{ $0 }))
        }.eraseToAnyPublisher()
    }
    
    public func findQuotes(byTheme name: String) -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard let themes = Optional(self.themes.filter({ theme in theme.name == name })),
                  themes.isNotEmpty,
                  let quotes = Optional(
                    themes.flatMap { theme in
                        theme.authors!.compactMap { author in author.quotes } +
                        theme.books!.compactMap { book in book.quotes }
                    }),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes.flatMap{ $0 }))
        }.eraseToAnyPublisher()
    }
    
    public func findAllQuotes() -> AnyPublisher<[model.Quote], Error> {
        Future { promise in
            guard self.quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.quotes))
        }.eraseToAnyPublisher()
    }
}
