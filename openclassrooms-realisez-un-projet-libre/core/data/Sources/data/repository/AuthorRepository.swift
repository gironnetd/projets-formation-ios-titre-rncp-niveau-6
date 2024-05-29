//
//  AuthorRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol AuthorRepository {
   
    /// Retrieve an author from its identifier
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An Author or throws an Error
    func findAuthor(byIdAuthor idAuthor: String) -> AnyPublisher<Author, Error>
    
    /// Retrieve an author from its name
    ///
    /// - Parameters:
    ///   - name: The name of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Author or an Error
    func findAuthors(byName name: String) -> AnyPublisher<[Author], Error>
    
    /// Retrieve a list of authors from its identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Author or an Error
    func findAuthors(byIdMovement idMovement: String) -> AnyPublisher<[Author], Error>
    
    /// Retrieve a list of authors containing in a theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the author
    ///
    /// - Returns: An AnyPublisher returning an Array of Author or an Error
    func findAuthors(byIdTheme idTheme: String) -> AnyPublisher<[Author], Error>
    
    /// Retrieve a author from its identifier presentation
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning an Author or an Error
    func findAuthor(byIdPresentation idPresentation: String) -> AnyPublisher<Author, Error>
    
    /// Retrieve a author from a identifier picture
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning an Author or an Error
    func findAuthor(byIdPicture idPicture: String) -> AnyPublisher<Author, Error>
    
    /// Retrieve all authors
    ///
    /// - Returns: An Array of Author or throws an Error
    func findAllAuthors() -> AnyPublisher<[Author], Error>
}
