//
//  TestPresentationDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestPresentationDao: PresentationDao {
    
    internal var presentations: [CachedPresentation] = []
    internal var authors: [CachedAuthor] = []
    internal var books: [CachedBook] = []
    internal var movements: [CachedMovement] = []
    
    func findPresentation(byIdPresentation idPresentation: String) -> Future<cache.CachedPresentation, Error> {
        Future { promise in
            guard let presentation = self.presentations.filter({ presentation in presentation.idPresentation == idPresentation }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(presentation))
        }
    }
    
    func findPresentation(byIdAuthor idAuthor: String) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let author = self.authors.filter({ author in author.idAuthor == idAuthor }).first,
                  let presentation = author.presentation else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(presentation))
        }
    }
    
    func findPresentation(byIdBook idBook: String) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let book = self.books.filter({ book in book.idBook == idBook }).first,
                  let presentation = book.presentation else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(presentation))
        }
    }
    
    func findPresentation(byIdMovement idMovement: String) -> Future<CachedPresentation, Error> {
        Future { promise in
            guard let movement = self.movements.filter({ movement in movement.idMovement == idMovement }).first,
                  let presentation = movement.presentation else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(presentation))
        }
    }
    
    func findAllPresentations() -> Future<[cache.CachedPresentation], Error> {
        Future { promise in
            guard self.presentations.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(self.presentations))
        }
    }
}
