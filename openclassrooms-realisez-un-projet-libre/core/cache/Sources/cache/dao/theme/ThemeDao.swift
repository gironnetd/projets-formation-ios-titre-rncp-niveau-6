//
//  ThemeDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine

///
/// Protocol defining methods for the Data Access Object of Themes.
///
public protocol ThemeDao {
    
    /// Retrieve a theme from its identifier, from the cache
    ///
    /// - Parameters:
    ///   - idTheme: The identifier of the theme
    ///
    /// - Returns: A ``CachedTheme`` or throws an Error
    func findTheme(byIdTheme idTheme: String) -> Future<CachedTheme, Error>
    
    /// Retrieve a theme from its name, from the cache
    ///
    /// - Parameters:
    ///   - name: The identifier of the name
    ///
    /// - Returns: A Future returning an Array of ``CachedTheme`` or an Error
    func findThemes(byName name: String) -> Future<[CachedTheme], Error>
    
    /// Retrieve a list of themes containing with same parent identifier, from the cache
    ///
    /// - Parameters:
    ///   - idParent: The identifier of the parent theme
    ///
    /// - Returns: A Future returning an Array of ``CachedTheme`` or an Error
    func findThemes(byIdParent idParent: String) -> Future<[CachedTheme], Error>
    
    /// Retrieve a list of main themes containing with sub themes, from the cache
    ///
    /// - Returns: An Array of ``CachedTheme`` or throws an Error
    func findMainThemes() -> Future<[CachedTheme], Error>
    
    /// Retrieve all themes, from the cache
    ///
    /// - Returns: An Array of ``CachedTheme`` or throws an Error
    func findAllThemes() -> Future<[CachedTheme], Error>
}
