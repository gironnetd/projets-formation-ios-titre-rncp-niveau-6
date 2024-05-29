//
//  GetAuthorByIdUseCaseSpec.swift
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
import Factory
import model

@testable import domain

class GetAuthorByIdUseCaseSpec: QuickSpec {
    
    override func spec() {
        var authorRepository: AuthorRepository!
        var userDataRepository: UserDataRepository!
        var useCase: GetAuthorByIdUseCase!
        
        describe("Get Author By Id") {
            context("Succeeded") {
                it("Author is Returned") {
                    let authors = [
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
                    ].sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                    
                    authorRepository = TestAuthorRepository(authors: authors)
                    userDataRepository = TestUserDataRepository()
                    
                    DataModule.authorRepository.register { authorRepository }
                    DataModule.userDataRepository.register { userDataRepository }
                    
                    useCase = GetAuthorByIdUseCase()
                    
                    let author = useCase(authors[0].idAuthor)
                    
                    await expect { try author.waitingCompletion().first }.to(equal(UserAuthor(author: authors.first(where: { $0.idAuthor == authors[0].idAuthor })! )))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    useCase = GetAuthorByIdUseCase()
                    
                    await expect { try useCase(DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
