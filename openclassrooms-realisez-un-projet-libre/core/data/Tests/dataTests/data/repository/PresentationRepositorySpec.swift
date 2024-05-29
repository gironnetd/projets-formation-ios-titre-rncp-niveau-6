//
//  PresentationRepositorySpec.swift
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
class PresentationRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.presentationDao) private var presentationDao
    
    override func spec() {
        
        var presentationRepository: DefaultPresentationRepository!
        
        var firstPresentation: Presentation!
        var secondPresentation: Presentation!
        var thirdPresentation: Presentation!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.presentationDao.register(factory: { TestPresentationDao() })
        }
        
        beforeEach {
            presentationRepository = DefaultPresentationRepository()
            
            firstPresentation = Presentation.testPresentation()
            secondPresentation = Presentation.testPresentation()
            thirdPresentation = Presentation.testPresentation()
        }
        
        afterEach { @MainActor () -> Void in
            (self.presentationDao as? TestPresentationDao)?.presentations = []
            (self.presentationDao as? TestPresentationDao)?.movements = []
            (self.presentationDao as? TestPresentationDao)?.books = []
            (self.presentationDao as? TestPresentationDao)?.authors = []
        }
        
        describe("Find presentation by idPresentation") {
            context("Found") {
                it("Presentation is returned") { @MainActor () -> Void in
                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    await expect { try presentationRepository.findPresentation(byIdPresentation: firstPresentation.idPresentation).waitingCompletion().first }.to(equal(firstPresentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[ secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    await expect { try presentationRepository.findPresentation(byIdPresentation: firstPresentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find presentation by idAuthor") {
            context("Found") {
                it("Presentation is returned") { @MainActor () -> Void in
                    let author = Author.testAuthor()
                    (self.presentationDao as? TestPresentationDao)?.authors.append(author.asCached())
                    
                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let author = Author.testAuthor()

                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        
        
        describe("Find presentation by idBook") {
            context("Found") {
                it("Presentation is returned") { @MainActor () -> Void in
                    let book = Book.testBook()

                    (self.presentationDao as? TestPresentationDao)?.books.append(book.asCached())
                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let book = Book.testBook()

                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find presentation by idMovement") {
            context("Found") {
                it("Presentation is returned") { @MainActor () -> Void in
                    let movement = Movement.testMovement()

                    (self.presentationDao as? TestPresentationDao)?.movements.append(movement.asCached())
                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let movement = Movement.testMovement()

                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    expect { try presentationRepository.findPresentation(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all presentations") {
            context("Found") {
                it("All presentations are returned") { @MainActor () -> Void in
                    (self.presentationDao as? TestPresentationDao)?.presentations.append(contentsOf:[firstPresentation.asCached(), secondPresentation.asCached(), thirdPresentation.asCached()])
                    
                    await expect { try presentationRepository.findAllPresentations().waitingCompletion().first }.to(equal([firstPresentation, secondPresentation, thirdPresentation]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    await expect { try presentationRepository.findAllPresentations().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
