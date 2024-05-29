//
//  DefaultBookDao.swift
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
/// Implementation for the ``CachedBook`` Dao Protocol
///
public class DefaultBookDao: BookDao {
    
    @LazyInjected(\.realm) internal var realm
    @LazyInjected(\.queue) private var queue
        
    /// Retrieve an book from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A ``CachedBook`` or throws an Error
    public func findBook(byIdBook idBook: String) -> Future<CachedBook, Error> {
        return Future { promise  in
            do {
                let book = try self.queue.sync(execute: { () -> CachedBook in
                    guard let book = self.realm.objects(CachedBook.self)
                            .where({ book in book.idBook == idBook }).first else {
                        throw Realm.Error.init(Realm.Error.fail)
                    }
                    return book
                })
                
                promise(.success(book.freeze()))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Retrieve  books from a name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: A Future returning an Array of ``CachedBook`` or an Error
    public func findBooks(byName name: String) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = Optional(self.realm.objects(CachedBook.self)
                    .where({ book in book.name == name })), books.isNotEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            
            guard books.count == 1, let book = books.first, book.idRelatedBooks.isNotEmpty else {
                return promise(.success(books.toArray()))
            }
            
            promise(
                .success(
                        book.idRelatedBooks
                            .reduce(into: [CachedBook](arrayLiteral: book)) { result, idBook in
                                if let book = self.realm.objects(CachedBook.self)
                                    .where({ book in book.idBook == idBook }).first {
                                    result.append(book)
                                }
                            }
                )
            )
        }
    }
    
    /// Retrieve a list of books from its identifier movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the book
    ///
    /// - Returns: A Future returning an Array of ``CachedBook`` or an Error
    public func findBooks(byIdMovement idMovement: String) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = self.realm.objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first?.books else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(books.toArray()))
        }
    }
    
    /// Retrieve a list of books containing in a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the book
    ///
    /// - Returns: A Future returning an Array of ``CachedBook`` or an Error
    public func findBooks(byIdTheme idTheme: String) -> Future<[CachedBook], Error> {
        Future { promise in
            guard let books = self.realm.objects(CachedTheme.self)
                    .where({ theme in theme.idTheme == idTheme }).first?.books, books.isNotEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(books.toArray()))
        }
    }
    
    /// Retrieve a book from its identifier presentation, from the cache
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A Future returning a ``CachedBook`` or an Error
    public func findBook(byIdPresentation idPresentation: String) -> Future<CachedBook, Error> {
        Future { promise in
            guard let book = self.realm.objects(CachedBook.self)
                    .where({ book in book.presentation.idPresentation == idPresentation }).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(book))
        }
    }
    
    /// Retrieve a book from a identifier picture, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: A Future returning an  ``CachedBook`` or an Error
    public func findBook(byIdPicture idPicture: String) -> Future<CachedBook, Error> {
        Future { promise in
            guard let picture = self.realm.objects(CachedPicture.self)
                    .where({ picture in picture.idPicture == idPicture}).first,
                  let book = self.realm.objects(CachedBook.self)
                    .where({ book in book.pictures.contains(picture)}).first else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            promise(.success(book))
        }
    }
    
    /// Retrieve all books, from the cache
    ///
    /// - Returns: An ``CachedBook`` or throws an Error
    public func findAllBooks() -> Future<[CachedBook], Error> {
        return Future { promise  in
            do {
                let books = try self.queue.sync(execute: { () -> [CachedBook] in
                    guard let books = Optional(self.realm.objects(CachedBook.self)), books.isNotEmpty else {
                        throw Realm.Error.init(Realm.Error.fail)
                    }
                    return books.toArray()
                })
                
                promise(.success(books.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
}
