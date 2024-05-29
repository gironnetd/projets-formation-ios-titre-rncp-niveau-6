//
//  UserDataRepositorySpec.swift
//  dataTests
//
//  Created by Damien Gironnet on 11/10/2023.
//

import Foundation
import Quick
import Nimble
import util
import remote
import cache
import model
import Factory
import analytics
import preferences

@testable import data

@MainActor
class UserDataRepositorySpec: QuickSpec {
    
    @LazyInjected(PreferencesModule.olaPreferences) private var olaPreferences
    @LazyInjected(\.analyticsHelper) private var analyticsHelper
    
    override func spec() {
        
        var userDataRepository: DefaultUserDataRepository!
        
        beforeSuite { @MainActor () -> Void in
            AnalyticsModule.analyticsHelper.register(factory: { StubAnalyticsHelper() })
        }
        
        beforeEach {
            userDataRepository = DefaultUserDataRepository()
        }
        
        describe("Set ThemeBrand") {
            context("Succeeded") {
                it("ThemeBrand is updated") { () -> Void in
                    try await userDataRepository.setThemeBrand(themeBrand: .secondary)
                    await expect { await self.olaPreferences.themeBrand }.to(equal(.secondary))
                    
                    try await userDataRepository.setThemeBrand(themeBrand: .primary)
                    await expect { await self.olaPreferences.themeBrand }.to(equal(.primary))
                }
            }
        }
        
        describe("Set DarkThemeConfig") {
            context("Succeeded") {
                it("DarkThemeConfig is updated") { () -> Void in
                    try await userDataRepository.setDarkThemeConfig(darkThemeConfig: .light)
                    await expect { await self.olaPreferences.darkThemeConfig }.to(equal(.light))
                    
                    try await userDataRepository.setDarkThemeConfig(darkThemeConfig: .dark)
                    await expect { await self.olaPreferences.darkThemeConfig }.to(equal(.dark))
                    
                    try await userDataRepository.setDarkThemeConfig(darkThemeConfig: .systemDefault)
                    await expect { await self.olaPreferences.darkThemeConfig }.to(equal(.systemDefault))
                }
            }
        }
        
        describe("Update resource bookmarked") {
            context("Succeeded") {
                it("resource is updated") { () -> Void in
                    let idResource = DataFactory.randomString()
                    
                    try await userDataRepository.updateResourceBookmarked(idResource: idResource, bookmarked: true)
                    await expect { await self.olaPreferences.bookmarkedResourceIds }.to(contain(idResource))
                    
                    try await userDataRepository.updateResourceBookmarked(idResource: idResource, bookmarked: false)
                    await expect { await self.olaPreferences.bookmarkedResourceIds }.toNot(contain(idResource))

                    try await userDataRepository.updateResourceBookmarked(idResource: idResource, bookmarked: true)
                    await expect { await self.olaPreferences.bookmarkedResourceIds }.to(contain(idResource))
                }
            }
        }
    }
}

