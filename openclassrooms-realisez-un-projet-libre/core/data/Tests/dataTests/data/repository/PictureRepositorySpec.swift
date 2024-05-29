//
//  PictureRepositorySpec.swift
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
class PictureRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.pictureDao) private var pictureDao
    
    override func spec() {
        
        var pictureRepository: DefaultPictureRepository!
        
        var firstPicture: Picture!
        var secondPicture: Picture!
        var thirdPicture: Picture!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.pictureDao.register(factory: { TestPictureDao() })
        }
        
        beforeEach {
            pictureRepository = DefaultPictureRepository()
            
            firstPicture = Picture.testPicture()
            secondPicture = Picture.testPicture()
            thirdPicture = Picture.testPicture()
        }
        
        afterEach { @MainActor () -> Void in
            (self.pictureDao as? TestPictureDao)?.pictures = []
            (self.pictureDao as? TestPictureDao)?.theme.pictures.removeAll()
            (self.pictureDao as? TestPictureDao)?.author.pictures.removeAll()
            (self.pictureDao as? TestPictureDao)?.book.pictures.removeAll()
            (self.pictureDao as? TestPictureDao)?.movement.pictures.removeAll()
        }
        
        describe("Find picture by idPicture") {
            context("Found") {
                it("Picture is returned") { @MainActor () -> Void in
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    await expect { try pictureRepository.findPicture(byIdPicture: firstPicture.idPicture).waitingCompletion().first }.to(equal(firstPicture))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[secondPicture.asCached(), thirdPicture.asCached()])
                    
                    await expect { try pictureRepository.findPicture(byIdPicture: firstPicture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idAuthor") {
            context("Found") {
                it("Pictures are returned") { @MainActor () -> Void in
                    var author = Author.testAuthor()
                    author.pictures?.append(contentsOf: [firstPicture, secondPicture])

                    (self.pictureDao as? TestPictureDao)?.author = author.asCached()
                    
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.pictures))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    var author = Author.testAuthor()
                    author.pictures?.removeAll()

                    (self.self.pictureDao as? TestPictureDao)?.author = author.asCached()
                    
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idBook") {
            context("Found") {
                it("Pictures are returned") { @MainActor () -> Void in
                    var book = Book.testBook()
                    book.pictures?.append(contentsOf: [firstPicture, secondPicture])

                    (self.pictureDao as? TestPictureDao)?.book = book.asCached()
                    
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.pictures))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    var book = Book.testBook()
                    book.pictures?.removeAll()

                    (self.pictureDao as? TestPictureDao)?.book = book.asCached()
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idMovement") {
            context("Pictures are found") {
                it("Pictures are returned") { @MainActor () -> Void in
                    var movement = Movement.testMovement()
                    movement.pictures = [firstPicture, secondPicture]

                    (self.pictureDao as? TestPictureDao)?.movement = movement.asCached()
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.pictures))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") { @MainActor () -> Void in
                    var movement = Movement.testMovement()
                    movement.pictures?.removeAll()
                    
                    (self.pictureDao as? TestPictureDao)?.movement = movement.asCached()
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idTheme") {
            context("Pictures are found") {
                it("Pictures are returned") { @MainActor () -> Void in
                    var theme = Theme.testTheme()
                    theme.pictures = [firstPicture, secondPicture]

                    (self.pictureDao as? TestPictureDao)?.theme = theme.asCached()
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal(theme.pictures))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let theme = Theme.testTheme()

                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    expect { try pictureRepository.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by nameSmall") {
            context("Found") {
                it("Picture is returned") { @MainActor () -> Void in
                    secondPicture.nameSmall = firstPicture.nameSmall

                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    expect { try pictureRepository.findPictures(byNameSmall: firstPicture.nameSmall).waitingCompletion().first }.to(equal([firstPicture, secondPicture]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    expect { try pictureRepository.findPictures(byNameSmall: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all pictures") {
            context("Found") {
                it("All Pictures are returned") { @MainActor () -> Void in
                    (self.pictureDao as? TestPictureDao)?.pictures.append(contentsOf:[firstPicture.asCached(), secondPicture.asCached(), thirdPicture.asCached()])
                    
                    await expect { try pictureRepository.findAllPictures().waitingCompletion().first }.to(equal([firstPicture, secondPicture, thirdPicture]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    await expect { try pictureRepository.findAllPictures().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
