//
//  DefaultCenturyDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine
import Factory

///
/// Implementation for the ``CachedCentury`` Dao Protocol
///
public class DefaultCenturyDao: CenturyDao {
    
    @LazyInjected(\.realm) internal var realm
    @LazyInjected(\.queue) private var queue
        
    /// Retrieve a century from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idCentury: The identifier of the century
    ///
    /// - Returns: A Future returning a ``CachedCentury`` or an Error
    public func findCentury(byIdCentury idCentury: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = self.realm.objects(CachedCentury.self)
                .where({ century in century.idCentury == idCentury }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(century))
        }
    }

    /// Retrieve a century from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning a ``CachedCentury`` or an Error
    public func findCentury(byIdAuthor idAuthor: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = self.realm.objects(CachedAuthor.self)
                .where({ author in author.idAuthor == idAuthor }).first?.century else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(century))
        }
        
    }
    
    /// Retrieve a century from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning a ``CachedCentury`` or an Error
    public func findCentury(byIdBook idBook: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = self.realm.objects(CachedBook.self)
                .where({ book in book.idBook == idBook }).first?.century else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(century))
        }
    }
    
    /// Retrieve a century from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the century
    ///
    /// - Returns: A Future returning a ``CachedCentury`` or an Error
    public func findCentury(byName name: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = self.realm.objects(CachedCentury.self)
                    .where({ century in century.century == name }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(century))
        }
    }
    
    /// Retrieve all centuries, from the cache
    ///
    /// - Returns: An Array of ``CachedCentury`` or throws an Error
    public func findAllCenturies() -> Future<[CachedCentury], Error> {
        return Future { promise  in
            do {
                let centuries = try self.queue.sync(execute: { () -> [CachedCentury] in
                    guard let centuries = Optional(self.realm.objects(CachedCentury.self)), centuries.isNotEmpty else {
                        throw Realm.Error.init(Realm.Error.fail)
                    }
                    return centuries.toArray()
                })
                
                promise(.success(centuries.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
}
