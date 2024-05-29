//
//  TestThemeDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache

class TestThemeDao: ThemeDao {
    
    internal var themes: [CachedTheme] = []
    
    func findTheme(byIdTheme idTheme: String) -> Future<cache.CachedTheme, Error> {
        Future { promise in
            guard let theme = self.themes.filter({ theme in theme.idTheme == idTheme }).first else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(theme))
        }
    }
    
    func findThemes(byName name: String) -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = Optional(self.themes.filter({ theme in theme.name == name })), themes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            guard themes.count == 1, let theme = themes.first,
                  theme.idRelatedThemes.isNotEmpty else {
                return promise(.success(themes))
            }
            
            promise(
                .success(
                    theme.idRelatedThemes
                        .reduce(into: [CachedTheme](arrayLiteral: theme)) { result, idTheme in
                            if let theme = self.themes.filter({ theme in theme.idTheme == idTheme }).first {
                                result.append(theme)
                            }
                        }
                )
            )
        }
    }
    
    func findThemes(byIdParent idParent: String) -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = self.themes.filter({ theme in theme.idTheme == idParent }).first?.themes,
                  themes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(themes.toArray()))
        }
    }
    
    func findMainThemes() -> Future<[cache.CachedTheme], Error> {
        Future { promise in
            guard let themes = Optional(self.themes.filter({ theme in theme.idParentTheme == nil })),
                      themes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(themes))
        }
    }
    
    func findAllThemes() -> Future<[cache.CachedTheme], Error> {
        Future { promise in
            guard self.themes.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.themes))
        }
    }
}
