//
//  GetThemeByIdUseCaseSpec.swift
//  domainTests
//
//  Created by Damien Gironnet on 08/10/2023.
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

class GetThemeByIdUseCaseSpec: QuickSpec {

    override func spec() {
        var themeRepository: ThemeRepository!
        var useCase: GetThemeByIdUseCase!

        describe("Get Theme by Id") {
            context("Succeeded") {
                it("Theme is Returned") {
                    let themes = [
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
                    ]
                    themeRepository = TestThemeRepository(themes: themes)
                    
                    DataModule.themeRepository.register { themeRepository }
                    
                    useCase = GetThemeByIdUseCase()
                    
                    let theme = useCase(themes[0].idTheme)
                    
                    await expect { try theme.waitingCompletion().first }.to(equal(UserTheme(theme: themes.first(where: { $0.idTheme == themes[0].idTheme })!)))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    themeRepository = TestThemeRepository()
                    
                    DataModule.themeRepository.register { themeRepository }
                    
                    useCase = GetThemeByIdUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

