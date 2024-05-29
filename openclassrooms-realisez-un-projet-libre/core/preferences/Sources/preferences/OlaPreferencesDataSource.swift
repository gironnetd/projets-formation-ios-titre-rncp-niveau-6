//
//  OlaPreferencesDataSource.swift
//  preferences
//
//  Created by Damien Gironnet on 05/07/2023.
//

import Foundation
import model
import Combine

public class OlaPreferencesDataSource {
    
    private let userPreferences: UserDefaults = UserDefaults.standard
    
    public var userData: CurrentValueSubject<UserData, Error>

//    public var userData: UserData {
//        UserData(
//            themeBrand: self.themeBrand,
//            darkThemeConfig: self.darkThemeConfig,
//            bookmarkedResources: self.bookmarkedResourceIds,
//            uidUser: self.uidUser)
//    }
    
    public init() {
        userData = CurrentValueSubject(
            UserData(
                themeBrand: ThemeBrand(rawValue: userPreferences.object(forKey: PreferencesConstants.THEME_BRAND) as? String ?? ThemeBrand.primary.rawValue)!,
                darkThemeConfig: DarkThemeConfig(rawValue: userPreferences.object(forKey: PreferencesConstants.DARK_THEME_CONFIG) as? String ?? DarkThemeConfig.systemDefault.rawValue)!,
                bookmarkedResources: userPreferences.object(forKey: PreferencesConstants.BOOKMARKED_RESOURCES_IDS) as? [String] ?? [],
                uidUser: userPreferences.object(forKey: PreferencesConstants.UID_USER) as? String ?? nil))
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    public var hasDateChanged: Bool {
        guard let date = userPreferences.string(forKey: PreferencesConstants.LAST_DATE_UPDATED) else {
            return true
        }
        
        if date != dateFormatter.string(from: Date()) {
            return true
        }
        
        return false
    }
    
    public func updateDate() {
        userPreferences.set(dateFormatter.string(from: Date()), forKey: PreferencesConstants.LAST_DATE_UPDATED)
    }
    
    public var dailyQuoteIds: AnyPublisher<[String], Error> {
        Just(userPreferences.object(forKey: PreferencesConstants.DAILY_QUOTE_IDS) as? [String] ?? [])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func setDailyQuoteIds(ids: [String]) {
        userPreferences.set(ids, forKey: PreferencesConstants.DAILY_QUOTE_IDS)
    }
    
    public var dailyPictureIds: AnyPublisher<[String], Error> {
        Just(userPreferences.object(forKey: PreferencesConstants.DAILY_PICTURE_IDS) as? [String] ?? [])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func setDailyPictureIds(ids: [String]) {
        userPreferences.set(ids, forKey: PreferencesConstants.DAILY_PICTURE_IDS)
    }
    
    public var dailyBiographyIds: AnyPublisher<[String], Error> {
        Just(userPreferences.object(forKey: PreferencesConstants.DAILY_BIOGRAPHY_IDS) as? [String] ?? [])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func setDailyBiographyIds(ids: [String]) {
        userPreferences.set(ids, forKey: PreferencesConstants.DAILY_BIOGRAPHY_IDS)
    }
    
    public var themeBrand: ThemeBrand {
        return ThemeBrand(rawValue: userPreferences.object(forKey: PreferencesConstants.THEME_BRAND) as? String ?? ThemeBrand.primary.rawValue)!
    }
    
    public func setThemeBrand(themeBrand: ThemeBrand) {
        userPreferences.set(themeBrand.rawValue, forKey: PreferencesConstants.THEME_BRAND)
    }
    
    public var darkThemeConfig: DarkThemeConfig {
        return DarkThemeConfig(rawValue: userPreferences.object(forKey: PreferencesConstants.DARK_THEME_CONFIG) as? String ?? DarkThemeConfig.systemDefault.rawValue)!
    }
    
    public func setDarkThemeConfig(darkThemeConfig: DarkThemeConfig) {
        userPreferences.set(darkThemeConfig.rawValue, forKey: PreferencesConstants.DARK_THEME_CONFIG)
    }
    
    public func setResourceBookmarked(resourceId: String, bookmarked: Bool) {
        var bookmarkedResources = userData.value.bookmarkedResources
        
        if bookmarked {
            if !bookmarkedResources.contains(resourceId) {
                bookmarkedResources.append(resourceId)
            }
        } else {
            if let index = bookmarkedResources.firstIndex(of: resourceId) {
                bookmarkedResources.remove(at: index)
            }
        }
        
        userPreferences.set(bookmarkedResources, forKey: PreferencesConstants.BOOKMARKED_RESOURCES_IDS)
        userData.value.bookmarkedResources = bookmarkedResources
        userData.send(userData.value)
    }
    
    public var bookmarkedResourceIds: [String] {
        userPreferences.object(forKey: PreferencesConstants.BOOKMARKED_RESOURCES_IDS) as? [String] ?? []
    }
    
    public func getChangeBookmarkVersions() -> ChangeBookmarkVersions {
        ChangeBookmarkVersions(userPreferences.object(forKey: PreferencesConstants.BOOKMARK_CHANGE_VERSIONS) as? Int ?? -1)
    }
    
    public func updateChangeBookmarkVersions(update: @escaping (ChangeBookmarkVersions) -> ChangeBookmarkVersions) {
        let updatedChangeBookmarkVersions = update(
            ChangeBookmarkVersions(userPreferences.object(forKey: PreferencesConstants.BOOKMARK_CHANGE_VERSIONS) as? Int ?? -1)
        )
        
        userPreferences.set(updatedChangeBookmarkVersions.bookmarkVersion, forKey: PreferencesConstants.BOOKMARK_CHANGE_VERSIONS)
    }
    
    public var uidUser: String? {
        userPreferences.object(forKey: PreferencesConstants.UID_USER) as? String ?? nil
    }
    
    public func setUidUser(uidUser: String?) {
        userPreferences.set(uidUser, forKey: PreferencesConstants.UID_USER)
    }
}
