//
//  TestPresentationRepository.swift
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
/// Implementation of PresentationRepository Protocol for Testing
///
public class TestPresentationRepository: PresentationRepository {
    
    public var presentations: [model.Presentation]
    public var authors: [model.Author]
    public var books: [model.Book]
    public var movements: [model.Movement]
    
    public init(presentations: [model.Presentation] = [], authors: [model.Author] = [], books: [model.Book] = [], movements: [model.Movement] = []) {
        self.presentations = presentations
        self.authors = authors
        self.books = books
        self.movements = movements
    }
    
    public func findPresentation(byIdPresentation idPresentation: String) -> AnyPublisher<model.Presentation, Error> {
        Future { promise in
            guard let presentation = self.presentations.filter({ presentation in presentation.idPresentation == idPresentation }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(presentation))
        }.eraseToAnyPublisher()
    }
    
    public func findPresentation(byIdAuthor idAuthor: String) -> AnyPublisher<model.Presentation, Error> {
        Future { promise in
            guard let author = self.authors.filter({ author in author.idAuthor == idAuthor }).first,
                  let presentation = author.presentation else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(presentation))
        }.eraseToAnyPublisher()
    }
    
    public func findPresentation(byIdBook idBook: String) -> AnyPublisher<model.Presentation, Error> {
        Future { promise in
            guard let book = self.books.filter({ book in book.idBook == idBook }).first,
                  let presentation = book.presentation else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(presentation))
        }.eraseToAnyPublisher()
    }
    
    public func findPresentation(byIdMovement idMovement: String) -> AnyPublisher<model.Presentation, Error> {
        Future { promise in
            guard let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first,
                  let presentation = movement.presentation else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(presentation))
        }.eraseToAnyPublisher()
    }
    
    public func findAllPresentations() -> AnyPublisher<[model.Presentation], Error> {
        Future { promise in
            guard self.presentations.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(self.presentations))
        }.eraseToAnyPublisher()
    }
}
