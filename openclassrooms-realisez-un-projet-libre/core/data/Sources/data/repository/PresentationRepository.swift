//
//  PresentationRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol PresentationRepository {
    
    /// Retrieve a presentation from its identifier
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A Presentation or throws an Error
    func findPresentation(byIdPresentation idPresentation: String) -> AnyPublisher<Presentation, Error>
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    func findPresentation(byIdAuthor idAuthor: String) -> AnyPublisher<Presentation, Error>
    
    /// Retrieve a presentation from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    func findPresentation(byIdBook idBook: String) -> AnyPublisher<Presentation, Error>
    
    /// Retrieve a presentation from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    func findPresentation(byIdMovement idMovement: String) -> AnyPublisher<Presentation, Error>
    
    /// Retrieve all presentations
    ///
    /// - Returns: An Array of Presentation or throws an Error
    func findAllPresentations() -> AnyPublisher<[Presentation], Error>
}
