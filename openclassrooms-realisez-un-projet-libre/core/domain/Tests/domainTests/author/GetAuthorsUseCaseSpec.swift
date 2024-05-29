//
//  GetAuthorsUseCaseSpec.swift
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
import Factory
import model

@testable import domain

class GetAuthorsUseCaseSpec: QuickSpec {
    
    override func spec() {
        var authorRepository: AuthorRepository!
        var useCase: GetAuthorsUseCase!
        
        describe("Get Authors") {
            context("Succeeded") {
                it("Authors are Returned") {
                    authorRepository = TestAuthorRepository(authors: [
                        Author(idAuthor: DataFactory.randomString(),
                               language: Locale.current.identifier,
                               name: "Nicolas Berdiaev",
                               quotes: []),
                        Author(idAuthor: DataFactory.randomString(),
                               language: Locale.current.identifier,
                               name: "Aurobindo Ghose",
                               quotes: []),
                        Author(idAuthor: DataFactory.randomString(),
                               language: Locale.current.identifier,
                               name: "Paramhansa Yogananda",
                               quotes: []),
                        Author(idAuthor: DataFactory.randomString(),
                               language: Locale.current.identifier,
                               name: "Karlfried Graf Durckheim",
                               quotes: [])
                    ].sorted(by: { $0.name.lowercased() < $1.name.lowercased() }))
                    
                    DataModule.authorRepository.register { authorRepository }
                    
                    useCase = GetAuthorsUseCase()
                    
                    let authors = useCase()
                
                    await expect { try authors.waitingCompletion().first }.to( equal((authorRepository as? TestAuthorRepository)?.authors.map { UserAuthor(author: $0) }))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    authorRepository = TestAuthorRepository()
                    
                    DataModule.authorRepository.register { authorRepository }
                    
                    useCase = GetAuthorsUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
