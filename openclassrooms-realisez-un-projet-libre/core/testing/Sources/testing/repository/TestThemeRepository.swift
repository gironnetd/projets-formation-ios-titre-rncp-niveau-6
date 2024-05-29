//
//  TestThemeRepository.swift
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
/// Implementation of ThemeRepository Protocol for Testing
///
public class TestThemeRepository: ThemeRepository {
    
    public var themes: [model.Theme]
    
    public init(themes: [model.Theme] = []) {
        self.themes = themes
    }
    
    public func findTheme(byIdTheme idTheme: String) -> AnyPublisher<model.Theme, Error> {
        Future { promise in
            guard let theme = self.themes.filter({ theme in theme.idTheme == idTheme }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
    
            promise(.success(theme))
        }.eraseToAnyPublisher()
    }
    
    public func findThemes(byName name: String) -> AnyPublisher<[model.Theme], Error> {
        Future { promise in
            guard let themes = Optional(self.themes.filter({ theme in theme.name == name })), themes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard themes.count == 1, let theme = themes.first,
                  theme.idRelatedThemes!.isNotEmpty else {
                return promise(.success(themes))
            }
            
            promise(
                .success(
                    theme.idRelatedThemes!
                        .reduce(into: [model.Theme](arrayLiteral: theme)) { result, idTheme in
                            if let theme = self.themes.filter({ theme in theme.idTheme == idTheme }).first {
                                result.append(theme)
                            }
                        }
                )
            )
        }.eraseToAnyPublisher()
    }
    
    public func findThemes(byIdParent idParent: String) -> AnyPublisher<[model.Theme], Error> {
        Future { promise in
            guard let themes = self.themes.filter({ theme in theme.idTheme == idParent }).first?.themes,
                  themes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(themes))
        }.eraseToAnyPublisher()
    }
    
    public func findMainThemes() -> AnyPublisher<[model.Theme], Error> {
        Future { promise in
            guard let themes = Optional(self.themes.filter({ theme in theme.idParentTheme == nil })),
                      themes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(themes))
        }.eraseToAnyPublisher()
    }
    
    public func findAllThemes() -> AnyPublisher<[model.Theme], Error> {
        Future { promise in
            guard self.themes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.themes))
        }.eraseToAnyPublisher()
    }
}
