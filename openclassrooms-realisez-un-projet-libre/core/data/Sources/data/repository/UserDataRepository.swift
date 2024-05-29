//
//  UserDataRepository.swift
//  data
//
//  Created by Damien Gironnet on 10/10/2023.
//

import Foundation
import Combine
import model

public protocol UserDataRepository {
    
    var userData: AnyPublisher<UserData, Error>! { get }
    
    /// Set the current theme brand
    ///
    /// - Returns: Void or throws an Error
    func setThemeBrand(themeBrand: ThemeBrand) async throws
    
    /// Set the current  dark theme config
    ///
    /// - Returns: Void or throws an Error
    func setDarkThemeConfig(darkThemeConfig: DarkThemeConfig) async throws
    
    func updateResourceBookmarked(idResource: String, bookmarked: Bool) async throws
}
