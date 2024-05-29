//
//  GetBooksUseCaseSpec.swift
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

class GetBooksUseCaseSpec: QuickSpec {

    override func spec() {
        var bookRepository: BookRepository!
        var useCase: GetBooksUseCase!
        
        describe("Get Books") {
            context("Succeeded") {
                it("Books is Returned") {
                    bookRepository = TestBookRepository(books: [
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
                    ].sorted(by: { $0.name.lowercased() < $1.name.lowercased() }))
                    
                    DataModule.bookRepository.register { bookRepository }
                    
                    useCase = GetBooksUseCase()
                    
                    let books = useCase()
                
                    await expect { try books.waitingCompletion().first }.to( equal((bookRepository as? TestBookRepository)?.books.map { UserBook(book: $0) }))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    bookRepository = TestBookRepository()
                    
                    DataModule.bookRepository.register { bookRepository }
                    
                    useCase = GetBooksUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
