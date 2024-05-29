//
//  QuoteRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol QuoteRepository: Syncable {
    
    /// Retrieve a quote from its identifier
    ///
    /// - Parameters:
    ///   - idQuote: The identifier of the quote
    ///
    /// - Returns: A Quote or throws an Error
    func findQuote(byIdQuote idQuote: String) -> AnyPublisher<Quote, Error>
    
    /// Retrieve a list of quotes from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    func findQuotes(byIdAuthor idAuthor: String) -> AnyPublisher<[Quote], Error>
    
    /// Retrieve a list of quotes from a author name
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    func findQuotes(byAuthor name: String) -> AnyPublisher<[Quote], Error>
    
    /// Retrieve a list of quotes from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    func findQuotes(byIdBook idBook: String) -> AnyPublisher<[Quote], Error>
    
    /// Retrieve a list of quotes from a book name
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    func findQuotes(byBook name: String) -> AnyPublisher<[Quote], Error>
    
    /// Retrieve a list of quotes from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    func findQuotes(byIdMovement idMovement: String) -> AnyPublisher<[Quote], Error>
    
    /// Retrieve a list of quotes from a movement name
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    func findQuotes(byMovement name: String) -> AnyPublisher<[Quote], Error>
    
    /// Retrieve a list of quotes from an identifier theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    func findQuotes(byIdTheme idTheme: String) -> AnyPublisher<[Quote], Error>
    
    /// Retrieve a list of quotes from a theme name
    ///
    /// - Parameters:
    ///   - name: The name of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Quote or an Error
    func findQuotes(byTheme name: String) -> AnyPublisher<[Quote], Error>
    
    /// Retrieve all quotes
    ///
    /// - Returns: An Array of Quote or throws an Error
    func findAllQuotes()  -> AnyPublisher<[Quote], Error>
}
