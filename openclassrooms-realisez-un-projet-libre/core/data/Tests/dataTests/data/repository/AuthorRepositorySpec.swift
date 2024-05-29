//
//  AuthorRepositorySpec.swift
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
class AuthorRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.authorDao) private var authorDao
    
    override func spec() {
        
        var authorRepository: DefaultAuthorRepository!
        
        var firstAuthor: Author!
        var secondAuthor: Author!
        var thirdAuthor: Author!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.authorDao.register(factory: { TestAuthorDao() })
        }
        
        beforeEach {
            authorRepository = DefaultAuthorRepository()
            
            firstAuthor = Author.testAuthor()
            secondAuthor = Author.testAuthor()
            thirdAuthor = Author.testAuthor()
        }
        
        afterEach { @MainActor () -> Void in
            (self.authorDao as? TestAuthorDao)?.authors = []
            (self.authorDao as? TestAuthorDao)?.themes = []
        }
        
        describe("Find author by idAuthor") {
            context("Found") {
                it("Author is returned") { () -> Void in
                    await (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    await expect { try authorRepository.findAuthor(byIdAuthor: firstAuthor.idAuthor).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    await expect { try authorRepository.findAuthor(byIdAuthor: firstAuthor.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by name") {
            context("Found") {
                it("Authors are returned") { @MainActor () -> Void in
                    secondAuthor.name = firstAuthor.name
                    
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    await expect { try authorRepository.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Found with idRelatedAuthors") {
                it("Authors are returned") { @MainActor () -> Void in
                    firstAuthor.idRelatedAuthors?.append(secondAuthor.idAuthor)
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [secondAuthor.asCached(), thirdAuthor.asCached()])
                    await expect { try authorRepository.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by idMovement") {
            context("Found") {
                it("Authors are returned") { @MainActor () -> Void in
                    let movement = Movement.testMovement()
                    
                    firstAuthor.idMovement = movement.idMovement
                    secondAuthor.idMovement = movement.idMovement
                    
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthors(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let movement = Movement.testMovement()
                    firstAuthor.idMovement = movement.idMovement
                    secondAuthor.idMovement = movement.idMovement
                    
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached()])
                    await expect { try authorRepository.findAuthors(byIdMovement: thirdAuthor.idMovement!).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by idTheme") {
            context("Found") {
                it("Authors are returned") { @MainActor () -> Void in
                    let theme = CachedTheme.testTheme()
                    theme.authors.removeAll()
                    
                    theme.authors.append(objectsIn: [firstAuthor.asCached(), secondAuthor.asCached()])
                    
                    (self.authorDao as? TestAuthorDao)?.themes.append(theme)
                    
                    expect { try authorRepository.findAuthors(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    
                    firstTheme.authors.removeAll()
                    secondTheme.authors.removeAll()
                    
                    firstTheme.authors.append(objectsIn: [firstAuthor.asCached(), secondAuthor.asCached()])
                    
                    (self.authorDao as? TestAuthorDao)?.themes.append(contentsOf: [firstTheme, secondTheme])
                    (self.authorDao as? TestAuthorDao)?.authors.append(thirdAuthor.asCached())
                    
                    expect { try authorRepository.findAuthors(byIdTheme: secondTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find author by idPresentation") {
            context("Found") {
                it("Author is returned") { @MainActor () -> Void in
                    let presentation = Presentation.testPresentation()
                    firstAuthor.presentation = presentation
                    
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    await expect { try authorRepository.findAuthor(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let presentation = CachedPresentation.testPresentation()
                    
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthor(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find author by idPicture") {
            context("Found") {
                it("Author is returned") { @MainActor () -> Void in
                    let picture = CachedPicture.testPicture()
                    firstAuthor.pictures?.append(picture.asExternalModel())
                    
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    
                    expect { try authorRepository.findAuthor(byIdPicture: picture.idPicture).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let picture = CachedPicture.testPicture()
                    
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    expect { try authorRepository.findAuthor(byIdPicture: picture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all authors") {
            context("Found") {
                it("All Authors are returned") { @MainActor () -> Void in
                    (self.authorDao as? TestAuthorDao)?.authors.append(contentsOf: [firstAuthor.asCached(), secondAuthor.asCached(), thirdAuthor.asCached()])
                    await expect { try authorRepository.findAllAuthors().waitingCompletion().first }.to(equal([firstAuthor, secondAuthor, thirdAuthor]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    await expect { try authorRepository.findAllAuthors().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
