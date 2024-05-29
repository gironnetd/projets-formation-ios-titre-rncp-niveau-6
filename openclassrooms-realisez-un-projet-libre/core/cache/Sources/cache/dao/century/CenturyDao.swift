//
//  CenturyDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

///
/// Protocol defining methods for the Data Access Object of Centuries.
///
public protocol CenturyDao {
   
    /// Retrieve a century from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idCentury: The identifier of the century
    ///
    /// - Returns: A Future returning a ``CachedCentury`` or an Error
    func findCentury(byIdCentury idCentury: String) -> Future<CachedCentury, Error>

    /// Retrieve a century from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning a ``CachedCentury`` or an Error
    func findCentury(byIdAuthor idAuthor: String) -> Future<CachedCentury, Error>
    
    /// Retrieve a century from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning a ``CachedCentury`` or an Error
    func findCentury(byIdBook idBook: String) -> Future<CachedCentury, Error>
    
    /// Retrieve a century from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the century
    ///
    /// - Returns: A Future returning a ``CachedCentury`` or an Error
    func findCentury(byName name: String) -> Future<CachedCentury, Error>
    
    /// Retrieve all centuries, from the cache
    ///
    /// - Returns: An Array of ``CachedCentury`` or throws an Error
    func findAllCenturies() -> Future<[CachedCentury], Error>
}
