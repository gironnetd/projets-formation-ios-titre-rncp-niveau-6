//
//  TestUrlDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestUrlDao: UrlDao {
    
    internal var urls: [CachedUrl] = []
    internal var authors: [CachedAuthor] = []
    internal var books: [CachedBook] = []
    internal var movements: [CachedMovement] = []
    
    func findUrl(byIdUrl idUrl: String) -> Future<CachedUrl, Error> {
        Future { promise in
            guard let url = self.urls.filter({ url in url.idUrl == idUrl }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(url))
        }
    }
    
    func findUrls(byIdAuthor idAuthor: String) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.authors.filter({ author in author.idAuthor == idAuthor }).first?.urls, urls.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    func findUrls(byIdBook idBook: String) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.books.filter({ book in book.idBook == idBook }).first?.urls,
                  urls.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    func findUrls(byIdMovement idMovement: String) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = self.movements.filter({ movement in movement.idMovement == idMovement }).first?.urls,
                  urls.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls.toArray()))
        }
    }
    
    func findUrls(byIdSource idSource: String) -> Future<[CachedUrl], Error> {
        Future { promise in
            guard let urls = Optional(self.urls.filter({ url in url.idSource == idSource })), urls.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(urls))
        }
    }
    
    func findAllUrls() -> Future<[CachedUrl], Error> {
        Future { promise in
            guard self.urls.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.urls))
        }
    }
}
