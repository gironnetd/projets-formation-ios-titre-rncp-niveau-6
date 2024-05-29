//
//  TestAuthorDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestAuthorDao: AuthorDao {
    
    internal var authors: [CachedAuthor] = []
    internal var themes: [CachedTheme] = []

    func findAuthor(byIdAuthor idAuthor: String) -> Future<cache.CachedAuthor, Error> {
        Future { promise in
            guard let author = self.authors.filter({ author in author.idAuthor == idAuthor }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(author))
        }
    }
    
    func findAuthors(byName name: String) -> Future<[CachedAuthor], Error> {
        Future { promise in
            guard let authors = Optional(self.authors.filter({ author in author.name == name })), authors.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard authors.count == 1, let author = authors.first, author.idRelatedAuthors.isNotEmpty else {
                return promise(.success(authors))
            }
            
            promise(
                .success(
                    author.idRelatedAuthors
                        .reduce(into: [CachedAuthor](arrayLiteral: author)) { result, idAuthor in
                            if let author = self.authors.filter({ author in author.idAuthor == idAuthor }).first {
                                result.append(author)
                            }
                        }
                )
            )
        }
    }
    
    func findAuthors(byIdMovement idMovement: String) -> Future<[CachedAuthor], Error> {
        Future { promise in
            guard let authors = Optional(self.authors.filter({ author in author.idMovement == idMovement })), authors.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(authors))
        }
    }
    
    func findAuthors(byIdTheme idTheme: String) -> Future<[CachedAuthor], Error> {
        Future { promise in
            guard let authors = Optional(self.themes.filter({ theme in theme.idTheme == idTheme}))?.first?.authors, authors.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(authors.toArray()))
        }
    }
    
    func findAuthor(byIdPresentation idPresentation: String) -> Future<CachedAuthor, Error> {
        Future { promise in
            guard let presentations = Optional(self.authors.compactMap({ author in author.presentation })),
                  let presentation = presentations.filter({ presentation in presentation.idPresentation == idPresentation }).first,
                  let author = self.authors.filter({ author in author.presentation == presentation }).first
            else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(author))
        }
    }
    
    func findAuthor(byIdPicture idPicture: String) -> Future<CachedAuthor, Error> {
        Future { promise in
            guard let pictures = Optional(self.authors.flatMap { author in author.pictures }),
                  let picture = pictures.filter({ picture in picture.idPicture == idPicture }).first,
                  let author = self.authors.filter({ author in author.pictures.contains(picture)}).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(author))
        }
    }
    
    func findAllAuthors() -> Future<[cache.CachedAuthor], Error> {
        Future { promise in
            guard self.authors.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.authors))
        }
    }
}
