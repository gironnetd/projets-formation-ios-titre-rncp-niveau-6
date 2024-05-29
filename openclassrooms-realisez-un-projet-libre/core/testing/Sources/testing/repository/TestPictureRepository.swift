//
//  TestPictureRepository.swift
//  testing
//
//  Created by Damien Gironnet on 26/07/2023.
//

import Foundation
import data
import remote
import model
import Combine
import util

///
/// Implementation of PictureRepository Protocol for Testing
///
public class TestPictureRepository: PictureRepository {
    
    public var pictures: [model.Picture]
    public var author: model.Author
    public var book: model.Book
    public var movement: model.Movement
    public var theme: model.Theme
    
    public init(pictures: [model.Picture] = [],
                author: model.Author = model.Author(idAuthor: DataFactory.randomString(),
                                                    language: Locale.current.identifier,
                                                    name: "Nicolas Berdiaev",
                                                    quotes: []),
                book: model.Book = model.Book(idBook: DataFactory.randomString(),
                                                  name: "Khuddaka Nikaya",
                                                  language: Locale.current.identifier,
                                                  quotes: []),
                movement: model.Movement = model.Movement(idMovement: DataFactory.randomString(),
                                                             name: "Bouddhisme",
                                                             language: Locale.current.identifier,
                                                             idRelatedMovements: nil),
                theme: model.Theme = model.Theme(idTheme: DataFactory.randomString(),
                                                  name: "Amour, Compassion, Devotion",
                                                  language: Locale.current.identifier)) {
        self.pictures = pictures
        self.author = author
        self.book = book
        self.movement = movement
        self.theme = theme
    }
    
    public func findPicture(byIdPicture idPicture: String) -> AnyPublisher<model.Picture, Error> {
        Future { promise in
            guard let picture = self.pictures.filter({ picture in picture.idPicture == idPicture }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(picture))
        }.eraseToAnyPublisher()
    }
    
    public func findPictures(byIdAuthor idAuthor: String) -> AnyPublisher<[model.Picture], Error> {
        Future { promise in
            guard self.author.pictures!.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.author.pictures!))
        }.eraseToAnyPublisher()
    }
    
    public func findPictures(byIdBook idBook: String) -> AnyPublisher<[model.Picture], Error> {
        Future { promise in
            guard self.book.pictures!.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.book.pictures!))
        }.eraseToAnyPublisher()
    }
    
    public func findPictures(byIdMovement idMovement: String) -> AnyPublisher<[model.Picture], Error> {
        Future { promise in
            guard self.movement.pictures!.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.movement.pictures!))
        }.eraseToAnyPublisher()
    }
    
    public func findPictures(byIdTheme idTheme: String) -> AnyPublisher<[model.Picture], Error> {
        Future { promise in
            guard self.theme.pictures!.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.theme.pictures!))
        }.eraseToAnyPublisher()
    }
    
    public func findPictures(byNameSmall nameSmall: String) -> AnyPublisher<[model.Picture], Error> {
        Future { promise in
            guard let pictures = Optional(self.pictures.filter({ picture in picture.nameSmall == nameSmall })),
                  pictures.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(pictures))
        }.eraseToAnyPublisher()
    }
    
    public func findAllPictures() -> AnyPublisher<[model.Picture], Error> {
        Future { promise in
            guard self.pictures.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(self.pictures))
        }.eraseToAnyPublisher()
    }
}
