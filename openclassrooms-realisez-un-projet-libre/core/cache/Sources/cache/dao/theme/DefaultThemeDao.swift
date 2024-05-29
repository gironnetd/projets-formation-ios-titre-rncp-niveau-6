//
//  DefaultThemeDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine
import Factory

///
/// Implementation for the ``CachedTheme`` Dao Protocol
///
public class DefaultThemeDao: ThemeDao {
    
    @LazyInjected(\.realm) internal var realm
    @LazyInjected(\.queue) private var queue
        
    /// Retrieve a theme from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: A ``CachedTheme`` or throws an Error
    public func findTheme(byIdTheme idTheme: String) -> Future<CachedTheme, Error> {
        return Future { promise  in
            do {
                let theme = try self.queue.sync(execute: { () -> CachedTheme in
                    guard let theme = self.realm.objects(CachedTheme.self)
                            .where({ theme in theme.idTheme == idTheme }).first else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return theme
                })
                
                promise(.success(theme.freeze()))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Retrieve a theme from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The identifier of the name
    ///
    /// - Returns: A Future returning an Array of ``CachedTheme`` or an Error
    public func findThemes(byName name: String) -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = Optional(self.realm.objects(CachedTheme.self)
                    .where({ theme in theme.name == name })), themes.isNotEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            
            guard themes.count == 1, let theme = themes.first,
                  theme.idRelatedThemes.isNotEmpty else {
                return promise(.success(themes.toArray()))
            }
            
            promise(
                .success(
                    theme.idRelatedThemes
                        .reduce(into: [CachedTheme](arrayLiteral: theme)) { result, idTheme in
                            if let theme = self.realm.objects(CachedTheme.self)
                                .where({ theme in theme.idTheme == idTheme }).first {
                                result.append(theme)
                            }
                        }
                )
            )
        }
    }
    
    /// Retrieve a list of themes containing with same parent identifier, from the cache
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent theme
    ///
    /// - Returns: A Future returning an Array of ``CachedTheme`` or an Error
    public func findThemes(byIdParent idParent: String) -> Future<[CachedTheme], Error> {
        Future { promise in
            guard let themes = self.realm.objects(CachedTheme.self)
                    .where({ theme in theme.idTheme == idParent }).first?.themes, themes.isNotEmpty else {
                return promise(.failure(Realm.Error(Realm.Error.fail)))
            }
            promise(.success(themes.toArray()))
        }
    }
    
    /// Retrieve a list of main themes containing with sub themes, from the cache
    ///
    /// - Returns: An Array of ``CachedTheme`` or throws an Error
    public func findMainThemes()  -> Future<[CachedTheme], Error> {
        return Future { promise  in
            do {
                let themes = try self.queue.sync(execute: { () -> [CachedTheme] in
                    guard let themes = Optional(self.realm.objects(CachedTheme.self)
                                .where({ theme in theme.idParentTheme == nil })), themes.isNotEmpty else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return themes.toArray()
                })
                
                promise(.success(themes.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Retrieve all themes, from the cache
    ///
    /// - Returns: A Future returning an Array of ``CachedTheme`` or an Error
    public func findAllThemes() -> Future<[CachedTheme], Error> {
        return Future { promise  in
            do {
                let themes = try self.queue.sync(execute: { () -> [CachedTheme] in
                    guard let themes = Optional(self.realm.objects(CachedTheme.self)), themes.isNotEmpty else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    return themes.toArray()
                })
                
                promise(.success(themes.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
}
