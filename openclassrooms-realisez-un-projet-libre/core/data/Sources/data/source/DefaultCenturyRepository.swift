//
//  DefaultCenturyRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import Factory

public class DefaultCenturyRepository: CenturyRepository {
    
    @LazyInjected(\.centuryDao) private var centuryDao

    /// Retrieve a century from its identifier
    ///
    /// - Parameters:
    ///   - idCentury: The identifier of the century
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    public func findCentury(byIdCentury idCentury: String) -> AnyPublisher<Century, Error> {
        self.centuryDao.findCentury(byIdCentury: idCentury).map { century in century.asExternalModel() }.eraseToAnyPublisher()
    }

    /// Retrieve a century from an identifier author
    ///
    /// - Parameters:
    ///   - idAuthor: The identifier of the author
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    public func findCentury(byIdAuthor idAuthor: String) -> AnyPublisher<Century, Error> {
        self.centuryDao.findCentury(byIdAuthor: idAuthor).map { century in century.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a century from an identifier book
    ///
    /// - Parameters:
    ///   - idBook: The identifier of the book
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    public func findCentury(byIdBook idBook: String) -> AnyPublisher<Century, Error> {
        self.centuryDao.findCentury(byIdBook: idBook).map { century in century.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve a century from its name
    ///
    /// - Parameters:
    ///   - name: The name of the century
    ///
    /// - Returns: An AnyPublisher returning a Century or an Error
    public func findCentury(byName name: String) -> AnyPublisher<Century, Error> {
        self.centuryDao.findCentury(byName: name).map { century in century.asExternalModel() }.eraseToAnyPublisher()
    }
    
    /// Retrieve all centuries
    ///
    /// - Returns: An Array of Century or throws an Error
    public func findAllCenturies() -> AnyPublisher<[Century], Error> {
        self.centuryDao.findAllCenturies().map { $0.map { $0.asExternalModel() } }.eraseToAnyPublisher()
    }
}
