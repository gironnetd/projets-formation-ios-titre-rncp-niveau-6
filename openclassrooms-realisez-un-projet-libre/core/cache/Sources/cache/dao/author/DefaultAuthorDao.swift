//
//  DefaultAuthorDao.swift
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
/// Implementation for the ``CachedAuthor`` Dao Protocol
///
public class DefaultAuthorDao: AuthorDao {
    
    @LazyInjected(\.realm) internal var realm
    @LazyInjected(\.queue) private var queue
    
    /// Retrieve an author from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A ``CachedAuthor`` or throws an Error
    public func findAuthor(byIdAuthor idAuthor: String) -> Future<CachedAuthor, Error> {
        return Future { promise  in
            do {
                let author = try self.queue.sync(execute: { () -> CachedAuthor in
                    guard let author = self.realm.objects(CachedAuthor.self)
                                .where({ author in author.idAuthor == idAuthor }).first else {
                        throw Realm.Error.init(Realm.Error.fail)
                    }
                    return author
                })
                
                promise(.success(author.freeze()))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Retrieve an author from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: A Future returning an Array of ``CachedAuthor`` or an Error
    public func findAuthors(byName name: String) -> Future<[CachedAuthor], Error> {
        Future { promise in
            guard let authors = Optional(self.realm.objects(CachedAuthor.self)
                    .where({ author in author.name == name })), authors.isNotEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            
            guard authors.count == 1, let author = authors.first, author.idRelatedAuthors.isNotEmpty else {
                return promise(.success(authors.toArray()))
            }
            
            promise(
                .success(
                    author.idRelatedAuthors
                        .reduce(into: [CachedAuthor](arrayLiteral: author)) { result, idAuthor in
                            if let author = self.realm.objects(CachedAuthor.self)
                                .where({ author in author.idAuthor == idAuthor }).first {
                                result.append(author)
                            }
                        }
                )
            )
        }
    }
    
    /// Retrieve a list of authors from its identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the author
    ///
    /// - Returns: A Future returning an Array of ``CachedAuthor`` or an Error
    public func findAuthors(byIdMovement idMovement: String) -> Future<[CachedAuthor], Error> {
        Future { promise in
            guard let authors = self.realm.objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first?.authors else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(authors.toArray()))
        }
    }
    
    /// Retrieve a list of authors containing in a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the author
    ///
    /// - Returns: A Future returning an Array of ``CachedAuthor`` or an Error
    public func findAuthors(byIdTheme idTheme: String) -> Future<[CachedAuthor], Error> {
        Future { promise in
            guard let authors = self.realm.objects(CachedTheme.self)
                    .where({ theme in theme.idTheme == idTheme }).first?.authors, authors.isNotEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(authors.toArray()))
        }
    }
    
    /// Retrieve a author from its identifier presentation, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A Future returning an ``CachedAuthor`` or an Error
    public func findAuthor(byIdPresentation idPresentation: String) -> Future<CachedAuthor, Error> {
        Future { promise in
            guard let author = self.realm.objects(CachedAuthor.self)
                    .where({ author in author.presentation.idPresentation == idPresentation }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(author))
        }
    }
    
    /// Retrieve a author from a identifier picture, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: A Future returning an ``CachedAuthor`` or an Error
    public func findAuthor(byIdPicture idPicture: String) -> Future<CachedAuthor, Error> {
        Future { promise in
            guard let picture = self.realm.objects(CachedPicture.self)
                    .where({ picture in picture.idPicture == idPicture}).first,
                  let author = self.realm.objects(CachedAuthor.self)
                    .where({ author in author.pictures.contains(picture)}).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(author))
        }
    }
    
    /// Retrieve all authors, from the cache
    ///
    /// - Returns: An Array of ``CachedAuthor`` or throws an Error
    public func findAllAuthors() -> Future<[CachedAuthor], Error> {
        return Future { promise  in
            do {
                let authors = try self.queue.sync(execute: { () -> [CachedAuthor] in
                    guard let authors = Optional(self.realm.objects(CachedAuthor.self)), authors.isNotEmpty else {
                        throw Realm.Error.init(Realm.Error.fail)
                    }
                    return authors.toArray()
                })
                
                promise(.success(authors.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
}
