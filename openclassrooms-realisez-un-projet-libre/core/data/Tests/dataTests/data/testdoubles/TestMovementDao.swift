//
//  TestMovementDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestMovementDao: MovementDao {

    internal var movements: [CachedMovement]  = []
    
    func findMovement(byIdMovement idMovement: String) -> Future<cache.CachedMovement, Error> {
        Future { promise in
            guard let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(movement))
        }
    }
    
    func findMovements(byName name: String) -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = Optional(self.movements.filter({ movement in movement.name == name })), movements.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard movements.count == 1, let movement = movements.first, movement.idRelatedMovements.isNotEmpty else {
                return promise(.success(movements))
            }
            
            promise(
                .success(
                    movement.idRelatedMovements
                        .reduce(into: [CachedMovement](arrayLiteral: movement)) { result, idMovement in
                            if let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first {
                                result.append(movement)
                            }
                        }
                )
            )
        }
    }
    
    func findMovements(byIdParent idParent: String) -> Future<[CachedMovement], Error> {
        Future { promise in
            guard let movements = self.movements.filter({ movement in movement.idMovement == idParent }).first?.movements,
                  movements.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(movements.toArray()))
        }
    }
    
    func findMainMovements() -> Future<[cache.CachedMovement], Error> {
        Future { [self] promise in
            guard let movements = Optional(self.movements.filter({ movement in movement.idParentMovement == nil })),
                      movements.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(movements))
        }
    }
    
    func findAllMovements() -> Future<[cache.CachedMovement], Error> {
        Future { [self] promise in
            guard movements.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(movements))
        }
    }
}
