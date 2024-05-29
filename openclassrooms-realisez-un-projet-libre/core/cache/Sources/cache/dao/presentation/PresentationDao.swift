//
//  PresentationDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

///
/// Protocol defining methods for the Data Access Object of Presentations.
///
public protocol PresentationDao {
    
    /// Retrieve a presentation from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A ``CachedPresentation`` or throws an Error
    func findPresentation(byIdPresentation idPresentation: String) -> Future<CachedPresentation, Error>
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning a ``CachedPresentation`` or an Error
    func findPresentation(byIdAuthor idAuthor: String) -> Future<CachedPresentation, Error>
    
    /// Retrieve a presentation from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning a ``CachedPresentation`` or an Error
    func findPresentation(byIdBook idBook: String) -> Future<CachedPresentation, Error>
    
    /// Retrieve a presentation from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning a ``CachedPresentation`` or an Error
    func findPresentation(byIdMovement idMovement: String) -> Future<CachedPresentation, Error>
    
    /// Retrieve all presentations, from the cache
    ///
    /// - Returns: An Array of ``CachedPresentation`` or throws an Error
    func findAllPresentations() -> Future<[CachedPresentation], Error>
}
