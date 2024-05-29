//
//  PictureRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol PictureRepository {
    
    /// Retrieve a picture from its identifier
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: A Picture or throws an Error
    func findPicture(byIdPicture idPicture: String) -> AnyPublisher<Picture, Error>
    
    /// Retrieve a list of pictures from an identifier author, from the cache
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    func findPictures(byIdAuthor idAuthor: String) -> AnyPublisher<[Picture], Error>
    
    /// Retrieve a list of pictures from a identifier book, from the cache
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    func findPictures(byIdBook idBook: String) -> AnyPublisher<[Picture], Error>
    
    /// Retrieve a list of pictures from a movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    func findPictures(byIdMovement idMovement: String) -> AnyPublisher<[Picture], Error>
    
    /// Retrieve a list of pictures from a theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    func findPictures(byIdTheme idTheme: String) -> AnyPublisher<[Picture], Error>
    
    /// Retrieve a list of pictures from its small name
    ///
    /// - Parameters:
    ///   - nameSmall: The nameSmall of the picture
    ///
    /// - Returns: An AnyPublisher returning an Array of Picture or an Error
    func findPictures(byNameSmall nameSmall: String) -> AnyPublisher<[Picture], Error>
    
    /// Retrieve all pictures
    ///
    /// - Returns: An Array of Picture or throws an Error
    func findAllPictures() -> AnyPublisher<[Picture], Error>
}
