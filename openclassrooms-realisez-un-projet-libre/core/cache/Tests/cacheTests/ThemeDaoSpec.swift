//
//  ThemeDaoSpec.swift
//  cacheTests
//
//  Created by damien on 14/09/2022.
//

import Foundation
import Quick
import Nimble
import RealmSwift
import util

@testable import cache

class ThemeDaoSpec: QuickSpec {
    
    override func spec() {
        
        var themeDatabase : Realm!
        var themeDao : ThemeDao!
        
        var firstTheme: CachedTheme!
        var secondTheme: CachedTheme!
        var thirdTheme: CachedTheme!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-theme-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                themeDatabase = try? Realm()
                return themeDatabase
            }
            themeDao = DefaultThemeDao()
            
            firstTheme = CachedTheme.testTheme()
            secondTheme = CachedTheme.testTheme()
            thirdTheme = CachedTheme.testTheme()
        }
        
        afterEach {  () -> Void in
            if let realm = (themeDao as? DefaultThemeDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find theme by idTheme") {
            context("Found") {
                it("Theme is returned") {  () -> Void in
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await themeDao.findTheme(byIdTheme: firstTheme.idTheme).value.thaw() }.to(equal(firstTheme))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await themeDao.findTheme(byIdTheme: firstTheme.idTheme).value }.to(throwError())
                }
            }
        }
        
        describe("Find themes by name") {
            context("Found") {
                it("Themes are returned") {  () -> Void in
                    secondTheme.name = firstTheme.name
                    
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try themeDao.findThemes(byName: firstTheme.name).waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Found themes with idRelatedThemes") {
                it("Themes are returned") {  () -> Void in
                    firstTheme.idRelatedThemes.append(secondTheme.idTheme)
                    
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try themeDao.findThemes(byName: firstTheme.name).waitingCompletion().first }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    secondTheme.name = firstTheme.name
                    
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try themeDao.findThemes(byName: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find themes by idParent") {
            context("Found") {
                it("Themes are returned") {  () -> Void in
                    firstTheme.themes.append(objectsIn: [secondTheme, thirdTheme])
                    
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try themeDao.findThemes(byIdParent: firstTheme.idTheme).waitingCompletion().first }.to(equal([secondTheme, thirdTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try themeDao.findThemes(byIdParent: UUID().uuidString).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find main Themes") {
            context("Found") {
                it("Main themes are returned") {  () -> Void in
                    firstTheme.idParentTheme = nil
                    secondTheme.idParentTheme = nil
                    
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await themeDao.findMainThemes().value.map({ $0.thaw() }) }.to(equal([firstTheme, secondTheme]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await themeDao.findMainThemes().value }.to(throwError())
                }
            }
        }
        
        describe("Find all themes") {
            context("Found") {
                it("All themes are returned") {  () -> Void in
                    if let realm = (themeDao as? DefaultThemeDao)?.realm {
                        try? realm.write {
                            realm.add([firstTheme, secondTheme, thirdTheme])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await themeDao.findAllThemes().value.map({ $0.thaw() }) }.to(equal([firstTheme, secondTheme, thirdTheme]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {  () -> Void in
                    await expect { try await themeDao.findAllThemes().value }.to(throwError())
                }
            }
        }
    }
}

extension CachedTheme {
    
    internal static func testTheme() -> CachedTheme {
        CachedTheme(idTheme: UUID().uuidString,
                    idParentTheme: UUID().uuidString,
                    name: DataFactory.randomString(),
                    language: .none,
                    idRelatedThemes: List<String>(),
                    presentation: DataFactory.randomString(),
                    sourcePresentation: DataFactory.randomString(),
                    nbQuotes: DataFactory.randomInt(),
                    authors: List<CachedAuthor>(),
                    books: List<CachedBook>(),
                    themes: List<CachedTheme>(),
                    pictures: List<CachedPicture>(),
                    quotes: List<CachedQuote>(),
                    urls: List<CachedUrl>(),
                    topics: List<CachedTopic>())
    }
}
