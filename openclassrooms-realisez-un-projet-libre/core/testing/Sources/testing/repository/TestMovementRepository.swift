//
//  TestMovementRepository.swift
//  testing
//
//  Created by Damien Gironnet on 26/07/2023.
//

import Foundation
import data
import remote
import model
import Combine

///
/// Implementation of MovementRepository Protocol for Testing
///
public class TestMovementRepository: MovementRepository {
    
    public var movements: [model.Movement]
    
    public init(movements: [model.Movement] = []) {
        self.movements = movements
    }
    
    public func findMovement(byIdMovement idMovement: String) -> AnyPublisher<model.Movement, Error> {
        Future { promise in
            guard let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(movement))
        }.eraseToAnyPublisher()
    }
    
    public func findMovements(byName name: String) -> AnyPublisher<[model.Movement], Error> {
        Future { promise in
            guard let movements = Optional(self.movements.filter({ movement in movement.name == name })), movements.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard movements.count == 1, let movement = movements.first, movement.idRelatedMovements!.isNotEmpty else {
                return promise(.success(movements))
            }
            
            promise(
                .success(
                    movement.idRelatedMovements!
                        .reduce(into: [model.Movement](arrayLiteral: movement)) { result, idMovement in
                            if let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first {
                                result.append(movement)
                            }
                        }
                )
            )
        }.eraseToAnyPublisher()
    }
    
    public func findMovements(byIdParent idParent: String) -> AnyPublisher<[model.Movement], Error> {
        Future { promise in
            guard let movements = self.movements.filter({ movement in movement.idMovement == idParent }).first?.movements,
                  movements.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(movements))
        }.eraseToAnyPublisher()
    }
    
    public func findMainMovements() -> AnyPublisher<[model.Movement], Error> {
        Future { promise in
            guard let movements = Optional(self.movements.filter({ movement in movement.idParentMovement == nil })),
                      movements.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(movements))
        }.eraseToAnyPublisher()
    }
    
    public func findAllMovements() -> AnyPublisher<[model.Movement], Error> {
        Future { promise in
            guard self.movements.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(self.movements))
        }.eraseToAnyPublisher()
    }
}
