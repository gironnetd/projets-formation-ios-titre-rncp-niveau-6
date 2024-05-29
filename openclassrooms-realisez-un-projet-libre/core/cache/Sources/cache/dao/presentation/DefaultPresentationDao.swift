//
//  DefaultPresentationDao.swift
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
/// Implementation for the ``CachedPresentation`` Dao Protocol
///
public class DefaultPresentationDao: PresentationDao {
    
    @LazyInjected(\.realm) internal var realm
    @LazyInjected(\.queue) private var queue
        
    /// Retrieve a presentation from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A ``CachedPresentation`` or throws an Error
    public func findPresentation(byIdPresentation idPresentation: String) -> Future<CachedPresentation, Error> {
        return Future { promise  in
            do {
                let presentation = try DispatchQueue(label: "serial-background").sync(execute: { () -> CachedPresentation in
                    guard let presentation = self.realm.objects(CachedPresentation.self)
                        .where({ presentation in presentation.idPresentation == idPresentation }).first else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return presentation
                })
                
                promise(.success(presentation.freeze()))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning a ``CachedPresentation`` or an Error
    public func findPresentation(byIdAuthor idAuthor: String) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let presentation = self.realm.objects(CachedAuthor.self)
                    .where({ author in author.idAuthor == idAuthor }).first?.presentation else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(presentation))
        }
    }
    
    /// Retrieve a presentation from an identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning a ``CachedPresentation`` or an Error
    public func findPresentation(byIdBook idBook: String) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let presentation = self.realm.objects(CachedBook.self)
                    .where({ book in book.idBook == idBook }).first?.presentation else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(presentation))
        }
    }
    
    /// Retrieve a presentation from an identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning a ``CachedPresentation`` or an Error
    public func findPresentation(byIdMovement idMovement: String) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let presentation = self.realm.objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first?.presentation else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(presentation))
        }
    }
    
    /// Retrieve all presentations, from the cache
    ///
    /// - Returns: An Array of ``CachedPresentation`` or throws an Error
    public func findAllPresentations() -> Future<[CachedPresentation], Error> {
        return Future { promise  in
            do {
                let presentations = try self.queue.sync(execute: { () -> [CachedPresentation] in
                    guard let presentations = Optional(self.realm.objects(CachedPresentation.self)), presentations.isNotEmpty else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return presentations.toArray()
                })
                
                promise(.success(presentations.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
}
