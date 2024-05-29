//
//  DefaultThemeRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import Factory

public class DefaultThemeRepository: ThemeRepository {
    
    @LazyInjected(\.themeDao) private var themeDao

    /// Retrieve a theme from its identifier
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: A Theme or throws an Error
    public func findTheme(byIdTheme idTheme: String) -> AnyPublisher<Theme, Error> {
        self.themeDao.findTheme(byIdTheme: idTheme).map({ $0.asExternalModel() }).eraseToAnyPublisher()
    }
    
    /// Retrieve a theme from its name
    ///
    /// - Parameters:
    ///   - name: The identifier of the name
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    public func findThemes(byName name: String) -> AnyPublisher<[Theme], Error> {
        self.themeDao.findThemes(byName: name).map { themes in
            themes.map { theme in theme.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of themes containing with same parent identifier
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent theme
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    public func findThemes(byIdParent idParent: String) -> AnyPublisher<[Theme], Error> {
        self.themeDao.findThemes(byIdParent: idParent).map { themes in
            themes.map { theme in theme.asExternalModel() }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieve a list of main themes containing with sub themes
    ///
    /// - Returns: An Array of Theme or throws an Error
    public func findMainThemes() -> AnyPublisher<[Theme], Error> {
        self.themeDao.findMainThemes().map { $0.map { $0.asExternalModel(onlyThemes: true) } }.eraseToAnyPublisher()
    }
    
    /// Retrieve all themes
    ///
    /// - Returns: An AnyPublisher returning an Array of Theme or an Error
    public func findAllThemes() -> AnyPublisher<[Theme], Error> {
        self.themeDao.findAllThemes().map { $0.map { $0.asExternalModel() } }.eraseToAnyPublisher()
    }
}
