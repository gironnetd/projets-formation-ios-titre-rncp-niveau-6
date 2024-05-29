//
//  DefaultUrlRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import Factory

public class DefaultUrlRepository: UrlRepository {
    
    @LazyInjected(\.urlDao) private var urlDao

    /// Retrieve a url from its identifier
    ///
    /// - Parameters:
    ///   - idUrl: The identifier of the url
    ///
    /// - Returns: An AnyPublisher returning an Url or an Error
    public func findUrl(byIdUrl idUrl : String) -> AnyPublisher<Url, Error> {
        self.urlDao.findUrl(byIdUrl: idUrl).map { url in url.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an identifier author
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(byIdAuthor idAuthor: String) -> AnyPublisher<[Url], Error> {
        self.urlDao.findUrls(byIdAuthor: idAuthor).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(byIdBook idBook: String) -> AnyPublisher<[Url], Error> {
        self.urlDao.findUrls(byIdBook: idBook).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(byIdMovement idMovement: String) -> AnyPublisher<[Url], Error> {
        self.urlDao.findUrls(byIdMovement: idMovement).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of urls from an identifier source
    ///
    /// - Parameters:
    ///   - idSource: The identifier of the source
    ///   - sourceType: The type of the source
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findUrls(byIdSource idSource: String) -> AnyPublisher<[Url], Error> {
        self.urlDao.findUrls(byIdSource: idSource).map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve all urls
    ///
    /// - Returns: An AnyPublisher returning an Array of Url or an Error
    public func findAllUrls() -> AnyPublisher<[Url], Error> {
        self.urlDao.findAllUrls().map { urls in
            urls.map { url in url.asExternalModel() }
        }.eraseToAnyPublisher()
    }
}
