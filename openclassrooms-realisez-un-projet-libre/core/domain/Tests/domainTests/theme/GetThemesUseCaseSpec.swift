//
//  GetMainThemesUseCaseSpec.swift
//  domainTests
//
//  Created by Damien Gironnet on 26/07/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import remote
import model
import Factory

@testable import domain

class GetThemesUseCaseSpec: QuickSpec {

    override func spec() {
        var themeRepository: ThemeRepository!
        var useCase: GetThemesUseCase!

        describe("Get Themes") {
            context("Succeeded") {
                it("Themes is Returned") {
                    themeRepository = TestThemeRepository(themes: [
                        Theme(idTheme: DataFactory.randomString(),
                                name: "La Réalisation",
                                language: Locale.current.identifier,
                                themes: []),
                          Theme(idTheme: DataFactory.randomString(),
                                name: "Ascetisme ?",
                                language: Locale.current.identifier,
                                themes: []),
                          Theme(idTheme: DataFactory.randomString(),
                                name: "Authenticité & Spontanéité",
                                language: Locale.current.identifier,
                                themes: []),
                          Theme(idTheme: DataFactory.randomString(),
                                name: "Nature Divine",
                                language: Locale.current.identifier,
                                themes: [])
                    ])
                    
                    DataModule.themeRepository.register { themeRepository }
                    
                    useCase = GetThemesUseCase()
    
                    let themes = useCase()
                
                    await expect { try themes.waitingCompletion().first }.to( equal((themeRepository as? TestThemeRepository)?.themes.map { UserTheme(theme: $0) }))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    themeRepository = TestThemeRepository()
                    
                    DataModule.themeRepository.register { themeRepository }
                    
                    useCase = GetThemesUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
