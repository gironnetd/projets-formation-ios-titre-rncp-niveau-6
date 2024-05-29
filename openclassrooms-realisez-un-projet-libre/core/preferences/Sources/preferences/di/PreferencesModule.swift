//
//  PreferencesModule.swift
//  preferences
//
//  Created by Damien Gironnet on 05/07/2023.
//

import Foundation
import Factory

///
/// Dependency injection for Preferences module
///
//public class PreferencesModule: SharedContainer {
//    public static let olaPreferences = Factory<OlaPreferencesDataSource>(scope: .singleton) { OlaPreferencesDataSource() }
//}

public extension SharedContainer {
    var olaPreferences: Factory<OlaPreferencesDataSource> { self { OlaPreferencesDataSource() }.singleton }
}
