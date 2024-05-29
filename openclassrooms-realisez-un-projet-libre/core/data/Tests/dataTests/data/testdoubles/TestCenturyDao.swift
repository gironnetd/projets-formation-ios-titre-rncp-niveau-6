//
//  TestCenturyDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestCenturyDao: CenturyDao {
    
    internal var centuries: [CachedCentury]  = []
    internal var authors: [CachedAuthor] = []
    internal var books: [CachedBook] = []
    internal var movements: [CachedMovement] = []
    
    func findCentury(byIdCentury idCentury: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = self.centuries.filter({ century in century.idCentury == idCentury }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(century))
        }
    }
    
    func findCentury(byIdAuthor idAuthor: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let author = self.authors.filter({ author in author.idAuthor == idAuthor }).first,
                  let century = author.century else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(century))
        }
    }
    
    func findCentury(byIdBook idBook: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let book = self.books.filter({ book in book.idBook == idBook }).first,
                  let century = book.century else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(century))
        }
    }
    
    func findCentury(byName name: String) -> Future<CachedCentury, Error> {
        Future { promise in
            guard let century = self.centuries.filter({ century in century.century == name }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(century))
        }
    }
    
    func findAllCenturies() -> Future<[cache.CachedCentury], Error> {
        Future { promise in
            guard self.centuries.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.centuries))
        }
    }
}
