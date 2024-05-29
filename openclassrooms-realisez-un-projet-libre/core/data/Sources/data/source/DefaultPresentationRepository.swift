//
//  DefaultPresentationRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import Factory

public class DefaultPresentationRepository: PresentationRepository {
    
    @LazyInjected(\.presentationDao) private var presentationDao

    /// Retrieve a presentation from its identifier
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: A Presentation or throws an Error
    public func findPresentation(byIdPresentation idPresentation: String) -> AnyPublisher<Presentation, Error> {
        self.presentationDao.findPresentation(byIdPresentation: idPresentation).map({ $0.asExternalModel() }).eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    public func findPresentation(byIdAuthor idAuthor: String) -> AnyPublisher<Presentation, Error> {
        self.presentationDao.findPresentation(byIdAuthor: idAuthor).map { presentation in presentation.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    public func findPresentation(byIdBook idBook: String) -> AnyPublisher<Presentation, Error> {
        self.presentationDao.findPresentation(byIdBook: idBook).map { presentation in presentation.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a presentation from an identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning a Presentation or an Error
    public func findPresentation(byIdMovement idMovement: String) -> AnyPublisher<Presentation, Error> {
        self.presentationDao.findPresentation(byIdMovement: idMovement).map { presentation in presentation.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve all presentations
    ///
    /// - Returns: An Array of Presentation or throws an Error
    public func findAllPresentations() -> AnyPublisher<[Presentation], Error> {
        self.presentationDao.findAllPresentations().map { $0.map { $0.asExternalModel() } }.eraseToAnyPublisher()
    }
}
