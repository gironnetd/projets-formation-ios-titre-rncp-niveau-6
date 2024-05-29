//
//  DefaultUserDataRepository.swift
//  data
//
//  Created by Damien Gironnet on 10/10/2023.
//

import Foundation
import Factory
import preferences
import model
import analytics
import Combine

public class DefaultUserDataRepository: UserDataRepository {
    
    @LazyInjected(\.olaPreferences) private var olaPreferences
    @LazyInjected(\.analyticsHelper) private var analyticsHelper
    
    public var userData: AnyPublisher<UserData, Error>! {
        Just(self.olaPreferences.userData.value).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func setThemeBrand(themeBrand: ThemeBrand) async throws {
        olaPreferences.setThemeBrand(themeBrand: themeBrand)
        DispatchQueue.main.async {
            self.analyticsHelper.logThemeChanged(themeBrand.rawValue)
        }
    }
    
    public func setDarkThemeConfig(darkThemeConfig: DarkThemeConfig) async throws {
        olaPreferences.setDarkThemeConfig(darkThemeConfig: darkThemeConfig)
        DispatchQueue.main.async {
            self.analyticsHelper.logDarkThemeConfigChanged(darkThemeConfig.rawValue)
        }
    }
    
    public func updateResourceBookmarked(idResource: String, bookmarked: Bool) async throws {
        olaPreferences.setResourceBookmarked(resourceId: idResource, bookmarked: bookmarked)
        DispatchQueue.main.async {
            self.analyticsHelper.logNewsResourceBookmarkToggled(idResource, isBookmarked: bookmarked)
        }
    }
}
