//
//  DefaultQuoteRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import Factory

public class DefaultQuoteRepository: QuoteRepository {
    
    @LazyInjected(\.quoteDao) private var quoteDao
    
    public func syncWith(synchronizer: Synchronizer) async -> Bool { true }
    
    /// Retrieve a quote from its identifier
    ///
    /// - Parameters:
    ///   - idQuote: The identifier of the quote
    ///
    /// - Returns: A Quote or throws an Error
    public func findQuote(byIdQuote idQuote: String) -> AnyPublisher<Quote, Error> {
        self.quoteDao.findQuote(byIdQuote: idQuote).map({ $0.asExternalModel() }).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byIdAuthor idAuthor: String) -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findQuotes(byIdAuthor: idAuthor).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a author name
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byAuthor name: String) -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findQuotes(byAuthor: name).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byIdBook idBook: String) -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findQuotes(byIdBook: idBook).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a book name
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byBook name: String) -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findQuotes(byBook: name).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byIdMovement idMovement: String) -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findQuotes(byIdMovement: idMovement).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a movement name
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byMovement name: String) -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findQuotes(byMovement: name).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from an identifier theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byIdTheme idTheme: String) -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findQuotes(byIdTheme: idTheme).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of quotes from a theme name
    ///
    /// - Parameters:
    ///   - name: The name of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findQuotes(byTheme name: String) -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findQuotes(byTheme: name).map { quotes in
            quotes.map { quote in quote.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve all quotes
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    public func findAllQuotes()  -> AnyPublisher<[Quote], Error> {
        self.quoteDao.findAllQuotes().map { $0.map { $0.asExternalModel() } }.eraseToAnyPublisher()
    }
}
