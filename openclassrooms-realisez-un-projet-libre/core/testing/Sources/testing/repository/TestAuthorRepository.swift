//
//  TestAuthorRepository.swift
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
/// Implementation of AuthorRepository Protocol for Testing
///
public class TestAuthorRepository: AuthorRepository {
    
    public var authors: [Author]
    public var themes: [Theme]
    
    public init(authors: [Author] = [], themes: [Theme] = []) {
        self.authors = authors
        self.themes = themes
    }
    
    public func findAuthor(byIdAuthor idAuthor: String) -> AnyPublisher<model.Author, Error> {
        Future { promise in
            guard let author = self.authors.filter({ author in author.idAuthor == idAuthor }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(author))
        }.eraseToAnyPublisher()
    }
    
    public func findAuthors(byName name: String) -> AnyPublisher<[model.Author], Error> {
        Future { promise in
            guard let authors = Optional(self.authors.filter({ author in author.name == name })), authors.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard authors.count == 1, let author = authors.first, author.idRelatedAuthors!.isNotEmpty else {
                return promise(.success(authors))
            }
            
            promise(
                .success(
                    author.idRelatedAuthors!
                        .reduce(into: [model.Author](arrayLiteral: author)) { result, idAuthor in
                            if let author = self.authors.filter({ author in author.idAuthor == idAuthor }).first {
                                result.append(author)
                            }
                        }
                )
            )
        }.eraseToAnyPublisher()
    }
    
    public func findAuthors(byIdMovement idMovement: String) -> AnyPublisher<[model.Author], Error> {
        Future { promise in
            guard let authors = Optional(self.authors.filter({ author in author.idMovement == idMovement })), authors.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(authors))
        }.eraseToAnyPublisher()
    }
    
    public func findAuthors(byIdTheme idTheme: String) -> AnyPublisher<[model.Author], Error> {
        Future { promise in
            guard let authors = Optional(self.themes.filter({ theme in theme.idTheme == idTheme}))?.first?.authors, authors.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(authors))
        }.eraseToAnyPublisher()
    }
    
    public func findAuthor(byIdPresentation idPresentation: String) -> AnyPublisher<model.Author, Error> {
        Future { promise in
            guard let presentations = Optional(self.authors.compactMap({ author in author.presentation })),
                  let presentation = presentations.filter({ presentation in presentation.idPresentation == idPresentation }).first,
                  let author = self.authors.filter({ author in author.presentation == presentation }).first
            else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(author))
        }.eraseToAnyPublisher()
    }
    
    public func findAuthor(byIdPicture idPicture: String) -> AnyPublisher<model.Author, Error> {
        Future { promise in
            guard let pictures = Optional(self.authors.compactMap { author in author.pictures }.flatMap { $0 }),
                  let picture = pictures.filter({ picture in picture.idPicture == idPicture }).first,
                  let author = self.authors.filter({ author in author.pictures!.contains(picture)}).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(author))
        }.eraseToAnyPublisher()
    }
    
    public func findAllAuthors() -> AnyPublisher<[model.Author], Error> {
        Future { promise in
            guard self.authors.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(self.authors))
        }.eraseToAnyPublisher()
    }
}
