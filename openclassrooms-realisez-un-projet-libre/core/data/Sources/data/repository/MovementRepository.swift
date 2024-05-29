//
//  MovementRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol MovementRepository {
    
    /// Retrieve a movement from its identifier
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: A Movement or throws an Error
    func findMovement(byIdMovement idMovement: String) -> AnyPublisher<Movement, Error>
    
    /// Retrieve a movement from its name
    ///
    /// - Parameters:
    ///   - name: The name of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Movement or an Error
    func findMovements(byName name: String) -> AnyPublisher<[Movement], Error>
    
    /// Retrieve a list of movements containing with same parent identifier
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Movement or an Error
    func findMovements(byIdParent idParent: String) -> AnyPublisher<[Movement], Error>
    
    /// Retrieve a list of main movements containing  authors
    ///
    /// - Returns: An Array of Movement or throws an Error
    func findMainMovements() -> AnyPublisher<[Movement], Error>
    
    /// Retrieve all movements
    ///
    /// - Returns: An Array of Movement or throws an Error
    func findAllMovements() -> AnyPublisher<[Movement], Error>
}
