//
//  GetBookByIdUseCaseSpec.swift
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

class GetBookByIdUseCaseSpec: QuickSpec {
    
    override func spec() {
        var bookRepository: BookRepository!
        var userDataRepository: UserDataRepository!
        var useCase: GetBookByIdUseCase!
        
        describe("Get Book by Id") {
            context("Succeeded") {
                it("Book is Returned") {
                    let books = [
                        Book(idBook: DataFactory.randomString(),
                             name: "Khuddaka Nikaya",
                             language: Locale.current.identifier,
                             quotes: []),
                        Book(idBook: DataFactory.randomString(),
                             name: "Divers Sutras",
                             language: Locale.current.identifier,
                             quotes: []),
                        Book(idBook: DataFactory.randomString(),
                             name: "Bible",
                             language: Locale.current.identifier,
                             quotes: []),
                        Book(idBook: DataFactory.randomString(),
                             name: "Books Of Changes",
                             language: Locale.current.identifier,
                             quotes: [])
                    ].sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                    
                    bookRepository = TestBookRepository(books: books)
                    userDataRepository = TestUserDataRepository()
                    
                    DataModule.bookRepository.register { bookRepository }
                    DataModule.userDataRepository.register { userDataRepository }
                    
                    useCase = GetBookByIdUseCase()
                    
                    let book = useCase(books[0].idBook)
                    
                    expect { try book.waitingCompletion().first }.to(equal(UserBook(book: books.first(where: { $0.idBook == books[0].idBook })!)))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    bookRepository = TestBookRepository()
                    useCase = GetBookByIdUseCase(bookRepository: bookRepository)
                    
                    await expect { try useCase(DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

