//
//  UrlRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol UrlRepository {
    
    /// Retrieve a url from its identifier
    ///
    /// - Parameters:
    ///   - idUrl: The identifier of the url
    ///
    /// - Returns: An AnyPublisher returning an Url or an Error
    func findUrl(byIdUrl idUrl : String) -> AnyPublisher<Url, Error>
    
    /// Retrieve a list of urls from an identifier author
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    func findUrls(byIdAuthor idAuthor: String) -> AnyPublisher<[Url], Error>
    
    /// Retrieve a list of urls from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    func findUrls(byIdBook idBook: String) -> AnyPublisher<[Url], Error>
    
    /// Retrieve a list of urls from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    func findUrls(byIdMovement idMovement: String) -> AnyPublisher<[Url], Error>
    
    /// Retrieve a list of urls from an identifier source
    ///
    /// - Parameters:
    ///   - idSource: The identifier of the source
    ///   - sourceType: The type of the source
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    func findUrls(byIdSource idSource: String) -> AnyPublisher<[Url], Error>
    
    /// Retrieve all urls
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    func findAllUrls() -> AnyPublisher<[Url], Error>
}
