//
//  TestUserDataRepository.swift
//
//
//  Created by Damien Gironnet on 11/10/2023.
//

import Foundation
import data
import remote
import model
import Combine

public class TestUserDataRepository: UserDataRepository {
    
    public var userData: AnyPublisher<model.UserData, Error>! {
        Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func updateResourceBookmarked(idResource: String, bookmarked: Bool) async throws {}
    
    public var data: UserData = UserData(
        themeBrand: .primary,
        darkThemeConfig: .systemDefault,
        bookmarkedResources: [], uidUser: nil)
    
    public init() { }
    
    public func setThemeBrand(themeBrand: ThemeBrand) async throws {
        self.data.themeBrand = themeBrand
    }
    
    public func setDarkThemeConfig(darkThemeConfig: DarkThemeConfig) async throws {
        self.data.darkThemeConfig = darkThemeConfig
    }
}
