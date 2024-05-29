//
//  CenturyRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model

public protocol CenturyRepository {
    
    /// Retrieve a century from its identifier
    ///
    /// - Parameters:
    ///   - idCentury: The identifier of the century
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    func findCentury(byIdCentury idCentury: String) -> AnyPublisher<Century, Error>

    /// Retrieve a century from an identifier author
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    func findCentury(byIdAuthor idAuthor: String) -> AnyPublisher<Century, Error>
    
    /// Retrieve a century from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    func findCentury(byIdBook idBook: String) -> AnyPublisher<Century, Error>
    
    /// Retrieve a century from its name
    ///
    /// - Parameters:
    ///   - name: The name of the century
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    func findCentury(byName name: String) -> AnyPublisher<Century, Error>
    
    /// Retrieve all centuries
    ///
    /// - Returns: An Array of Century or throws an Error
    func findAllCenturies() -> AnyPublisher<[Century], Error>
}
