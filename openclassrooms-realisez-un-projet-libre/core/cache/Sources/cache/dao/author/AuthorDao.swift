//
//  AuthorDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

///
/// Protocol defining methods for the Data Access Object of Authors.
///
public protocol AuthorDao {
    
    /// Retrieve an author from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A ``CachedAuthor`` or throws an Error
    func findAuthor(byIdAuthor idAuthor: String) -> Future<CachedAuthor, Error>
    
    /// Retrieve an author from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: A Future returning an Array of ``CachedAuthor`` or an Error
    func findAuthors(byName name: String) -> Future<[CachedAuthor], Error>
    
    /// Retrieve a list of authors from its identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the author
    ///
    /// - Returns: A Future returning an Array of ``CachedAuthor`` or an Error
    func findAuthors(byIdMovement idMovement: String) -> Future<[CachedAuthor], Error>
    
    /// Retrieve a list of authors containing in a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the author
    ///
    /// - Returns: A Future returning an Array of ``CachedAuthor`` or an Error
    func findAuthors(byIdTheme idTheme: String) -> Future<[CachedAuthor], Error>
    
    /// Retrieve a author from its identifier presentation, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A Future returning an ``CachedAuthor`` or an Error
    func findAuthor(byIdPresentation idPresentation: String) -> Future<CachedAuthor, Error>
    
    /// Retrieve a author from a identifier picture, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: A Future returning an ``CachedAuthor`` or an Error
    func findAuthor(byIdPicture idPicture: String) -> Future<CachedAuthor, Error>
    
    /// Retrieve all authors, from the cache
    ///
    /// - Returns: An Array of ``CachedAuthor`` or throws an Error
    func findAllAuthors() -> Future<[CachedAuthor], Error>
}
