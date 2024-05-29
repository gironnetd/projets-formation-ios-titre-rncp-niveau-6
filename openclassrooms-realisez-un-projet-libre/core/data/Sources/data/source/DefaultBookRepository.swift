//
//  DefaultBookRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import Factory

public class DefaultBookRepository: BookRepository {
    
    @LazyInjected(\.bookDao) private var bookDao

    /// Retrieve an book from its identifier
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: A Book or throws an Error
    public func findBook(byIdBook idBook: String) -> AnyPublisher<Book, Error> {
        self.bookDao.findBook(byIdBook: idBook).map({ $0.asExternalModel() }).eraseToAnyPublisher()
    }
    
    /// Retrieve  books from a name
    ///
    /// - Parameters:
    ///   - name: The name of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Book or an Error
    public func findBooks(byName name: String) -> AnyPublisher<[Book], Error> {
        self.bookDao.findBooks(byName: name).map { books in
            books.map { book in book.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of books from its identifier movement
    ///
    /// - Parameters:
    ///   - idMovement: The identifier of the movement of the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Book or an Error
    public func findBooks(byIdMovement idMovement: String) -> AnyPublisher<[Book], Error> {
        self.bookDao.findBooks(byIdMovement: idMovement).map { books in
            books.map { book in book.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of books containing in a theme
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme containing the book
    ///
    /// - Returns: An AnyPublisher returning an Array of Book or an Error
    public func findBooks(byIdTheme idTheme: String) -> AnyPublisher<[Book], Error> {
        self.bookDao.findBooks(byIdTheme: idTheme).map { books in
            books.map { book in book.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a book from its identifier presentation
    ///
    /// - Parameters:
    ///   - idPresentation: The identifier of the presentation
    ///
    /// - Returns: An AnyPublisher returning a Book or an Error
    public func findBook(byIdPresentation idPresentation: String) -> AnyPublisher<Book, Error> {
        self.bookDao.findBook(byIdPresentation: idPresentation).map { book in book.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a book from a identifier picture
    ///
    /// - Parameters:
    ///   - idPicture: The identifier of the picture
    ///
    /// - Returns: An AnyPublisher returning a Book or an Error
    public func findBook(byIdPicture idPicture: String) -> AnyPublisher<Book, Error> {
        self.bookDao.findBook(byIdPicture: idPicture).map { book in book.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve all books
    ///
    /// - Returns: An Array of Book or throws an Error
    public func findAllBooks() -> AnyPublisher<[Book], Error> {
        self.bookDao.findAllBooks().map { $0.map { $0.asExternalModel() } }.eraseToAnyPublisher()
    }
}
