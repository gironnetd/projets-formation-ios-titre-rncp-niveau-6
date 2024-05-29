//
//  DefaultPictureRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import Factory

public class DefaultPictureRepository: PictureRepository {
    
    @LazyInjected(\.pictureDao) private var pictureDao

    /// Retrieve a picture from its identifier
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: A Picture or throws an Error
    public func findPicture(byIdPicture idPicture: String) -> AnyPublisher<Picture, Error> {
        self.pictureDao.findPicture(byIdPicture: idPicture).map({ $0.asExternalModel() }).eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    public func findPictures(byIdAuthor idAuthor: String) -> AnyPublisher<[Picture], Error> {
        self.pictureDao.findPictures(byIdAuthor: idAuthor).map { pictures in
            pictures.map { picture in picture.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from a identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    public func findPictures(byIdBook idBook: String) -> AnyPublisher<[Picture], Error> {
        self.pictureDao.findPictures(byIdBook: idBook).map { pictures in
            pictures.map { picture in picture.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from a movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    public func findPictures(byIdMovement idMovement: String) -> AnyPublisher<[Picture], Error> {
        self.pictureDao.findPictures(byIdMovement: idMovement).map { pictures in
            pictures.map { picture in picture.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from a theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    public func findPictures(byIdTheme idTheme: String) -> AnyPublisher<[Picture], Error> {
        self.pictureDao.findPictures(byIdTheme: idTheme).map { pictures in
            pictures.map { picture in picture.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of pictures from its small name
    ///
    /// - Parameters:
    ///   - nameSmall: The nameSmall of the picture
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    public func findPictures(byNameSmall nameSmall: String) -> AnyPublisher<[Picture], Error> {
        self.pictureDao.findPictures(byNameSmall: nameSmall).map { pictures in
            pictures.map { picture in picture.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve all pictures
    ///
    /// - Returns: An Array of Picture or throws an Error
    public func findAllPictures() -> AnyPublisher<[Picture], Error> {
        self.pictureDao.findAllPictures().map { $0.map { $0.asExternalModel() } }.eraseToAnyPublisher()
    }
}
