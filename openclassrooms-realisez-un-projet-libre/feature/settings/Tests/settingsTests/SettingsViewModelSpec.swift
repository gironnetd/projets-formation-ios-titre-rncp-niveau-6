//
//  SettingsViewModelSpec.swift
//  settingsTests
//
//  Created by Damien Gironnet on 11/10/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import domain
import remote
import model
import Factory
import XCTest

@testable import settings

class SettingsViewModelSpec: QuickSpec {
    
    override func spec() {
        var userRepository: UserRepository!
        var userDataRepository: UserDataRepository!
        var viewModel: SettingsViewModel!
        
        beforeEach {
            userDataRepository = TestUserDataRepository()
            
            DataModule.userDataRepository.register { userDataRepository }
            
            userRepository = TestUserRepository(
                user: User(id: DataFactory.randomString(),
                           providerID: AuthProvider.password.rawValue,
                           uidUser: DataFactory.randomString(),
                           email: DataFactory.randomEmail(),
                           displayName: DataFactory.randomString()))
            
            DataModule.userRepository.register { userRepository }
                        
            viewModel = SettingsViewModel()
        }
        
        describe("Set ThemeBrand") {
            context("Succeeded") {
                it("ThemeBrand is updated") { () -> Void in
                    try await viewModel.updateThemeBrand(themeBrand: .secondary)
                    await expect { try userDataRepository.userData.waitingCompletion().first?.themeBrand }.to(equal(.secondary))
                    
                    try await viewModel.updateThemeBrand(themeBrand: .primary)
                    await expect { try userDataRepository.userData.waitingCompletion().first?.themeBrand }.to(equal(.primary))
                }
            }
        }
        
        describe("Set DarkThemeConfig") {
            context("Succeeded") {
                it("DarkThemeConfig is updated") { () -> Void in
                    try await viewModel.updateDarkThemeConfig(darkThemeConfig: .light)
                    await expect { try userDataRepository.userData.waitingCompletion().first?.darkThemeConfig }.to(equal(.light))
                    
                    try await viewModel.updateDarkThemeConfig(darkThemeConfig: .dark)
                    await expect { try userDataRepository.userData.waitingCompletion().first?.darkThemeConfig }.to(equal(.dark))
                    
                    try await viewModel.updateDarkThemeConfig(darkThemeConfig: .systemDefault)
                    await expect { try userDataRepository.userData.waitingCompletion().first?.darkThemeConfig }.to(equal(.systemDefault))
                }
            }
        }
        
        describe("SignOut") {
            context("Succeeded") {
                it("User is nil") { () -> Void in
                    try await viewModel.signOut()
                    expect { userRepository.user.value.providerID }.to(beEmpty())
                }
            }
        }
    }
}

