//
//  SettingsViewModel.swift
//  settings
//
//  Created by Damien Gironnet on 10/10/2023.
//

import Foundation
import model
import data
import Factory
import Combine
import SwiftUI

internal class SettingsViewModel: ObservableObject {
    
    @LazyInjected(\.userDataRepository) var userDataRepository
    @LazyInjected(\.userRepository) var userRepository
    
    @Published internal var user: model.User!
    @Published var settingsUiState: UserEditableSettings!
    
    var cancellables: Set<AnyCancellable> = Set()
    
    public init() {
        Task {
            userDataRepository.userData.sink(
                receiveCompletion: { _ in },
                receiveValue: { userData in
                    self.settingsUiState = UserEditableSettings(userData: userData) })
            .store(in: &cancellables)

            settingsUiState.objectWillChange.sink { (_) in self.objectWillChange.send() }.store(in: &cancellables)
        }
        userRepository.user.assertNoFailure().sink(receiveValue: { self.user = $0 }).store(in: &cancellables)
    }
    
    public convenience init(userRepository: UserRepository,
                userDataRepository: UserDataRepository) {
        self.init()
        self.userRepository = userRepository
        self.userDataRepository = userDataRepository
    }
    
    func updateThemeBrand(themeBrand: ThemeBrand) async throws {
        try await userDataRepository.setThemeBrand(themeBrand: themeBrand)
    }
    
    func updateDarkThemeConfig(darkThemeConfig: DarkThemeConfig) async throws {
        try await userDataRepository.setDarkThemeConfig(darkThemeConfig: darkThemeConfig)
    }
    
    func signOut() async throws {
        try await userRepository.signOut()
    }

    class UserEditableSettings: ObservableObject {
        @Published var brand: String
        @Published var darkThemeConfig: String
        
        init(userData: UserData) {
            brand = userData.themeBrand.description
            darkThemeConfig = userData.darkThemeConfig.description
        }
    }
    
    internal enum SettingsUiState {
        case Loading
        case Success(settings: UserEditableSettings)
    }
}

extension ThemeBrand: CustomStringConvertible {
    
    public init?(rawValue: String) {
        switch rawValue {
        case "blue".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings):
            self = .primary
        case "orange".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings):
            self = .secondary
        case "garnet".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings):
            self = .tertiary
        case "green".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings):
            self = .quaternary
        default:
            self = .primary
        }
    }
    
    public var description: String {
        switch self {
        case .primary:
            return "blue".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings)
        case .secondary:
            return "orange".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings)
        case .tertiary:
            return "garnet".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings)
        case .quaternary:
            return "green".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings)
        }
    }
}

extension DarkThemeConfig: CustomStringConvertible {
    
    public init?(rawValue: String) {
        switch rawValue {
        case "system_default".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings):
            self = .systemDefault
        case "light".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings):
            self = .light
        case "dark".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings):
            self = .dark
        default:
            self = .systemDefault
        }
    }
    
    public var description: String {
        switch self {
        case .systemDefault:
            return "system_default".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings)
        case .light:
            return "light".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings)
        case .dark:
            return "dark".localizedString(identifier: Locale.current.identifier, bundle: Bundle.settings)
        }
    }
}
