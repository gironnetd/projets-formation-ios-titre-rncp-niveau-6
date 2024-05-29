//
//  DefaultPictureDao.swift
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
/// Implementation for the ``CachedPicture`` Dao Protocol
///
public class DefaultPictureDao: PictureDao {
    
    @LazyInjected(\.realm) internal var realm
    @LazyInjected(\.queue) private var queue
        
    /// Retrieve a picture from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: A Future returning an Array of ``CachedPicture`` or an Error
    public func findPicture(byIdPicture idPicture: String) -> Future<CachedPicture, Error> {
        return Future { promise  in
            do {
                let picture = try DispatchQueue(label: "serial-background").sync(execute: { () -> CachedPicture in
                    guard let picture = self.realm.objects(CachedPicture.self)
                        .where({ picture in picture.idPicture == idPicture }).first else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return picture
                })
                                
                promise(.success(picture.freeze()))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Retrieve a list of pictures from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: A Future returning an Array of ``CachedPicture`` or an Error
    public func findPictures(byIdAuthor idAuthor: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard let pictures = self.realm.objects(CachedAuthor.self)
                    .where({ author in author.idAuthor == idAuthor }).first?.pictures, pictures.isNotEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(pictures.toArray()))
        }
    }
    
    /// Retrieve a list of pictures from a identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Future returning an Array of ``CachedPicture`` or an Error
    public func findPictures(byIdBook idBook: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard let pictures = self.realm.objects(CachedBook.self)
                    .where({ book in book.idBook == idBook }).first?.pictures, pictures.isNotEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(pictures.toArray()))
        }
    }
    
    /// Retrieve a list of pictures from a movement, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning an Array of ``CachedPicture`` or an Error
    public func findPictures(byIdMovement idMovement: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard let pictures = self.realm.objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idMovement }).first?.pictures, pictures.isNotEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(pictures.toArray()))
        }
    }
    
    /// Retrieve a list of pictures from a theme, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: A Future returning an Array of ``CachedPicture`` or an Error
    public func findPictures(byIdTheme idTheme: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard let pictures = self.realm.objects(CachedTheme.self)
                    .where({ theme in theme.idTheme == idTheme }).first?.pictures, pictures.isNotEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(pictures.toArray()))
        }
    }
    
    /// Retrieve a list of pictures from its small name, from the cache
    ///
    /// - Parameters:
    ///   - nameSmall: The nameSmall of the picture
    ///
    /// - Returns: A Future returning an Array of ``CachedPicture`` or an Error
    public func findPictures(byNameSmall nameSmall: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard let pictures = Optional(self.realm.objects(CachedPicture.self)
                    .where({ picture in picture.nameSmall == nameSmall })), pictures.isNotEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(pictures.toArray()))
        }
    }
    
    /// Retrieve all pictures, from the cache
    ///
    /// - Returns: An Array of ``CachedPicture`` or throws an Error
    public func findAllPictures() -> Future<[CachedPicture], Error> {
        return Future { promise  in
            do {
                let pictures = try self.queue.sync(execute: { () -> [CachedPicture] in
                    guard let pictures = Optional(self.realm.objects(CachedPicture.self)), pictures.isNotEmpty else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return pictures.toArray()
                })
                
                promise(.success(pictures.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
}
