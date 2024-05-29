//
//  DefaultMovementDao.swift
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
/// Implementation for the ``CachedMovement`` Dao Protocol
///
public class DefaultMovementDao: MovementDao {
    
    @LazyInjected(\.realm) internal var realm
    @LazyInjected(\.queue) private var queue
        
    /// Retrieve a movement from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Future returning a ``CachedMovement`` or an Error
    public func findMovement(byIdMovement idMovement: String) -> Future<CachedMovement, Error> {
        return Future { promise  in
            do {
                let movement = try self.queue.sync(execute: { () -> CachedMovement in
                    guard let movement = self.realm.objects(CachedMovement.self)
                                .where({ movement in movement.idMovement == idMovement }).first else {
                            throw Realm.Error(Realm.Error.fail)
                    }
                    return movement
                })
                
                promise(.success(movement.freeze()))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Retrieve a movement from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: A Future returning an Array of ``CachedMovement`` or an Error
    public func findMovements(byName name: String) -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = Optional(self.realm.objects(CachedMovement.self)
                    .where({ book in book.name == name })), movements.isNotEmpty else {
                return promise(.failure(Realm.Error.init(Realm.Error.fail)))
            }
            
            guard movements.count == 1, let movement = movements.first, movement.idRelatedMovements.isNotEmpty else {
                return promise(.success(movements.toArray()))
            }
            
            promise(
                .success(
                    movement.idRelatedMovements
                        .reduce(into: [CachedMovement](arrayLiteral: movement)) { result, idMovement in
                            if let movement = self.realm.objects(CachedMovement.self)
                                .where({ movement in movement.idMovement == idMovement }).first {
                                result.append(movement)
                            }
                        }
                )
            )
        }
    }
    
    /// Retrieve a list of movements containing with same parent identifier, from the cache
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent movement
    ///
    /// - Returns: A Future returning an Array of ``CachedMovement`` or an Error
    public func findMovements(byIdParent idParent: String) -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = self.realm.objects(CachedMovement.self)
                    .where({ movement in movement.idMovement == idParent }).first?.movements, movements.isNotEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(movements.toArray()))
        }
    }
    
    /// Retrieve a list of main movements containing  authors, from the cache
    ///
    /// - Returns: An Array of ``CachedMovement`` or throws an Error
    public func findMainMovements() -> Future<[CachedMovement], Error> {
        return Future { promise  in
            do {
                let movements = try self.queue.sync(execute: { () -> [CachedMovement] in
                    guard let movements = Optional(self.realm.objects(CachedMovement.self)
                                .where({ movement in movement.idParentMovement == nil })), movements.isNotEmpty else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return movements.toArray()
                })
                
                promise(.success(movements.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Retrieve all movements, from the cache
    ///
    /// - Returns: An Array of ``CachedMovement`` or throws an Error
    public func findAllMovements() -> Future<[CachedMovement], Error> {
        return Future { promise  in
            do {
                let movements = try self.queue.sync(execute: { () -> [CachedMovement] in
                    guard let movements = Optional(self.realm.objects(CachedMovement.self)), movements.isNotEmpty else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return movements.toArray()
                })
                
                promise(.success(movements.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
}
