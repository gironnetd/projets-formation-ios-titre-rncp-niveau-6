//
//  ThemeRepositorySpec.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Quick
import Nimble
import util
import remote
import cache
import model
import Factory

@testable import data

@MainActor
class ThemeRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.themeDao) private var themeDao
    
    override func spec() {
        
        var themeRepository: DefaultThemeRepository!
        
        var firstTheme: Theme!
        var secondTheme: Theme!
        var thirdTheme: Theme!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.themeDao.register(factory: { TestThemeDao() })
        }
        
        beforeEach {
            themeRepository = DefaultThemeRepository()
            
            firstTheme = Theme.testTheme()
            secondTheme = Theme.testTheme()
            thirdTheme = Theme.testTheme()
        }
        
        afterEach { @MainActor () -> Void in
            (self.themeDao as? TestThemeDao)?.themes = []
        }
        
        describe("Find theme by idTheme") {
            context("Found") {
                it("Theme is returned") { @MainActor () -> Void in
                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf: [firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    await expect { try themeRepository.findTheme(byIdTheme: firstTheme.idTheme).waitingCompletion().first }.to(equal(firstTheme))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[secondTheme.asCached(), thirdTheme.asCached()])
                    
                    await expect { try themeRepository.findTheme(byIdTheme: firstTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find themes by name") {
            context("Found") {
                it("Themes are returned") { @MainActor () -> Void in
                    secondTheme.name = firstTheme.name

                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byName: firstTheme.name).waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Found themes with idRelatedThemes") {
                it("Themes are returned") { @MainActor () -> Void in
                    firstTheme.idRelatedThemes = [secondTheme.idTheme]

                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byName: firstTheme.name).waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    secondTheme.name = firstTheme.name

                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byName: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find themes by idParent") {
            context("Found") {
                it("Themes are returned") { @MainActor () -> Void in
                    firstTheme.themes = [secondTheme, thirdTheme]
                    
                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byIdParent: firstTheme.idTheme).waitingCompletion().first }.to(equal([secondTheme, thirdTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    expect { try themeRepository.findThemes(byIdParent: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find main Themes") {
            context("Found") {
                it("Main themes are returned") { @MainActor () -> Void in
                    firstTheme.idParentTheme = nil
                    secondTheme.idParentTheme = nil

                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    await expect { try themeRepository.findMainThemes().waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Nout found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    await expect { try themeRepository.findMainThemes().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all themes") {
            context("Found") {
                it("All Themes are returned") { @MainActor () -> Void in
                    (self.themeDao as? TestThemeDao)?.themes.append(contentsOf:[firstTheme.asCached(), secondTheme.asCached(), thirdTheme.asCached()])
                    
                    await expect { try themeRepository.findAllThemes().waitingCompletion().first }.to(equal([firstTheme, secondTheme, thirdTheme]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    await expect { try themeRepository.findAllThemes().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
