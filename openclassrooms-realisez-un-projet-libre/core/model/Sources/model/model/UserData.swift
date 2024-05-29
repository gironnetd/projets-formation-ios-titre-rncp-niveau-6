//
//  UserData.swift
//  model
//
//  Created by Damien Gironnet on 10/10/2023.
//

import Foundation

public struct UserData {
    public var themeBrand: ThemeBrand
    public var darkThemeConfig: DarkThemeConfig
    public var bookmarkedResources: [String]
    public var uidUser: String?
    
    public init(themeBrand: ThemeBrand, darkThemeConfig: DarkThemeConfig, bookmarkedResources: [String], uidUser: String?) {
        self.themeBrand = themeBrand
        self.darkThemeConfig = darkThemeConfig
        self.bookmarkedResources = bookmarkedResources
        self.uidUser = uidUser
    }
}
