//
//  TestPictureDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestPictureDao: PictureDao {
    
    internal var pictures: [CachedPicture] = []
    internal var author: CachedAuthor = CachedAuthor()
    internal var book: CachedBook = CachedBook()
    internal var movement: CachedMovement = CachedMovement()
    internal var theme: CachedTheme = CachedTheme()
    
    func findPicture(byIdPicture idPicture: String) -> Future<cache.CachedPicture, Error> {
        Future { promise in
            guard let picture = self.pictures.filter({ picture in picture.idPicture == idPicture }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(picture))
        }
    }
    
    func findPictures(byIdAuthor idAuthor: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard self.author.pictures.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.author.pictures.toArray()))
        }
    }
    
    func findPictures(byIdBook idBook: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard self.book.pictures.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.book.pictures.toArray()))
        }
    }
    
    func findPictures(byIdMovement idMovement: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard self.movement.pictures.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.movement.pictures.toArray()))
        }
    }
    
    func findPictures(byIdTheme idTheme: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard self.theme.pictures.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.theme.pictures.toArray()))
        }
    }
    
    func findPictures(byNameSmall nameSmall: String) -> Future<[CachedPicture], Error> {
        Future { promise in
            guard let pictures = Optional(self.pictures.filter({ picture in picture.nameSmall == nameSmall })),
                  pictures.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(pictures))
        }
    }
    
    func findAllPictures() -> Future<[cache.CachedPicture], Error> {
        Future { promise in
            guard self.pictures.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.pictures))
        }
    }
}
