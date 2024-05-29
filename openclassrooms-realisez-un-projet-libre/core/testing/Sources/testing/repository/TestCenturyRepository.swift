//
//  TestCenturyRepository.swift
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
/// Implementation of CenturyRepository Protocol for Testing
///
public class TestCenturyRepository: CenturyRepository {
    
    public var centuries: [model.Century]
    public var authors: [model.Author]
    public var books: [model.Book]
    public var movements: [model.Movement]
    
    public init(centuries: [model.Century] = [], authors: [model.Author] = [], books: [model.Book] = [], movements: [model.Movement] = []) {
        self.centuries = centuries
        self.authors = authors
        self.books = books
        self.movements = movements
    }
    
    public func findCentury(byIdCentury idCentury: String) -> AnyPublisher<model.Century, Error> {
        Future { promise in
            guard let century = self.centuries.filter({ century in century.idCentury == idCentury }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(century))
        }.eraseToAnyPublisher()
    }
    
    public func findCentury(byIdAuthor idAuthor: String) -> AnyPublisher<model.Century, Error> {
        Future { promise in
            guard let author = self.authors.filter({ author in author.idAuthor == idAuthor }).first,
                  let century = author.century else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(century))
        }.eraseToAnyPublisher()
    }
    
    public func findCentury(byIdBook idBook: String) -> AnyPublisher<model.Century, Error> {
        Future { promise in
            guard let book = self.books.filter({ book in book.idBook == idBook }).first,
                  let century = book.century else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(century))
        }.eraseToAnyPublisher()
    }
    
    public func findCentury(byName name: String) -> AnyPublisher<model.Century, Error> {
        Future { promise in
            guard let century = self.centuries.filter({ century in century.century == name }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(century))
        }.eraseToAnyPublisher()
    }
    
    public func findAllCenturies()  -> AnyPublisher<[model.Century], Error> {
        Future { promise in
            guard self.centuries.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.centuries))
        }.eraseToAnyPublisher()
    }
}
