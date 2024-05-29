//
// ThemesViewModelSpec.swift
// themesTests
//
// Created by Damien Gironnet on 31/03/2023.
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

@testable import themes

class ThemesViewModelSpec: QuickSpec {
    
    override func spec() {
        var themeRepository: ThemeRepository!
        var viewModel: ThemesViewModel!
        var themes: [Theme]!
        
        beforeEach {
            themes = [
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
            
            viewModel = ThemesViewModel()
        }
        
        describe("Get Themes Feed") {
            context("Succeeded") {
                it("Themes is Returned") {
                    viewModel.feeds()
                    
                    let exp = self.expectation(description: "Test after 5 seconds")
                    _ = await XCTWaiter.fulfillment(of: [exp], timeout: 5.0)

                    if case let .Success(feed) = viewModel.themesUiState {
                        expect(feed).to(equal(themes.map { UserTheme(theme: $0) }))
                    } else {
                        fail("Expected <content> but got <\(viewModel.themesUiState)>")
                    }
                }
            }
        }
    }
}

