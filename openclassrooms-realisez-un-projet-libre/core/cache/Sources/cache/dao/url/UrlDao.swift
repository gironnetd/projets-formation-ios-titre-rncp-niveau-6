//
//  UrlDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

///
/// Protocol defining methods for the Data Access Object of Urls.
///
public protocol UrlDao {
    
    /// Retrieve a url from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idUrl: The identifier of the url
    ///
    /// - Returns: A Future returning an ``CachedUrl`` or an Error
    func findUrl(byIdUrl idUrl : String) -> Future<CachedUrl, Error>
    
    /// Retrieve a list of urls from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning an Array of ``CachedUrl`` or an Error
    func findUrls(byIdAuthor idAuthor: String) -> Future<[CachedUrl], Error>
    
    /// Retrieve a list of urls from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning an Array of ``CachedUrl`` or an Error
    func findUrls(byIdBook idBook: String) -> Future<[CachedUrl], Error>
    
    /// Retrieve a list of urls from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning an Array of ``CachedUrl`` or an Error
    func findUrls(byIdMovement idMovement: String) -> Future<[CachedUrl], Error>
    
    /// Retrieve a list of urls from an identifier source, from the cache
    ///
    /// - Parameters:
    ///   - idSource: The identifier of the source
    ///   - sourceType: The type of the source
    ///
    /// - Returns: A Future returning an Array of ``CachedUrl`` or an Error
    func findUrls(byIdSource idSource: String) -> Future<[CachedUrl], Error>
    
    /// Retrieve all urls, from the cache
    ///
    /// - Returns: A Future returning an Array of ``CachedUrl`` or an Error
    func findAllUrls() -> Future<[CachedUrl], Error>
}
