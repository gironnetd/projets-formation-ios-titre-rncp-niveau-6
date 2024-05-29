//
//  TestQuoteDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestQuoteDao: QuoteDao {

    internal var quotes: [CachedQuote] = []
    internal var authors: [CachedAuthor] = []
    internal var books: [CachedBook] = []
    internal var movements: [CachedMovement] = []
    internal var themes: [CachedTheme] = []
    
    func findQuote(byIdQuote idQuote: String) -> Future<cache.CachedQuote, Error> {
        Future { promise in
            guard let quote = self.quotes.filter({ quote in quote.idQuote == idQuote }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quote))
        }
    }
    
    func findQuotes(byIdAuthor idAuthor: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let quotes = self.authors.filter({ author in author.idAuthor == idAuthor }).first?.quotes,
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes.toArray()))
        }
    }
    
    func findQuotes(byAuthor name: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let authors = Optional(self.authors.filter({ author in author.name == name })),
                  let quotes = Optional(authors.flatMap({ author in author.quotes })),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes))
        }
    }
    
    func findQuotes(byIdBook idBook: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let quotes = self.books.filter({ book in book.idBook == idBook }).first?.quotes, quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes.toArray()))
        }
    }
    
    func findQuotes(byBook name: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let books = Optional(self.books.filter({ book in book.name == name })),
                  let quotes = Optional(books.flatMap({ book in book.quotes })),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes))
        }
    }
    
    func findQuotes(byIdMovement idMovement: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first,
                  let quotes = Optional(
                    movement.authors.toArray().flatMap { author in author.quotes } +
                        movement.books.toArray().flatMap { book in book.quotes }
                  ),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes))
        }
    }
    
    func findQuotes(byMovement name: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let movements = Optional(self.movements.filter({ movement in movement.name == name })),
                  movements.isNotEmpty,
                  let quotes = Optional(
                    movements.flatMap { movement in
                        movement.authors.toArray().flatMap { author in author.quotes } +
                        movement.books.toArray().flatMap { book in book.quotes }
                    }
                  ), quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(quotes))
        }
    }
    
    func findQuotes(byIdTheme idTheme: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let theme = self.themes.filter({ theme in theme.idTheme == idTheme }).first,
                  let quotes = Optional(
                    theme.authors.toArray().flatMap { author in author.quotes } +
                    theme.books.toArray().flatMap { book in book.quotes }
                  ),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes))
        }
    }
    
    func findQuotes(byTheme name: String) -> Future<[CachedQuote], Error> {
        Future { promise in
            guard let themes = Optional(self.themes.filter({ theme in theme.name == name })),
                  themes.isNotEmpty,
                  let quotes = Optional(
                    themes.flatMap { theme in
                        theme.authors.toArray().flatMap { author in author.quotes } +
                        theme.books.toArray().flatMap { book in book.quotes }
                    }),
                  quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(quotes))
        }
    }
    
    func findAllQuotes() -> Future<[cache.CachedQuote], Error> {
        Future { promise in
            guard self.quotes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.quotes))
        }
    }
}
