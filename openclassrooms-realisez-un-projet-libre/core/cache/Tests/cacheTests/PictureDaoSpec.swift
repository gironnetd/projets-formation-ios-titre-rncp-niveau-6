//
//  PictureDaoSpec.swift
//  cacheTests
//
//  Created by damien on 14/09/2022.
//

import Foundation
import Quick
import Nimble
import RealmSwift
import util

@testable import cache

class PictureDaoSpec: QuickSpec {
    
    override func spec() {
        var pictureDatabase : Realm!
        var pictureDao : PictureDao!
        
        var firstPicture: CachedPicture!
        var secondPicture: CachedPicture!
        var thirdPicture: CachedPicture!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-picture-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                pictureDatabase = try? Realm()
                return pictureDatabase
            }
            pictureDao = DefaultPictureDao()
            
            firstPicture = CachedPicture.testPicture()
            secondPicture = CachedPicture.testPicture()
            thirdPicture = CachedPicture.testPicture()
        }
        
        afterEach {  () -> Void in
            if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find picture by idPicture") {
            context("Found") {
                it("Picture is returned") {  () -> Void in
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add([firstPicture, secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await pictureDao.findPicture(byIdPicture: firstPicture.idPicture).value.thaw() }.to(equal(firstPicture))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add([secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await pictureDao.findPicture(byIdPicture: firstPicture.idPicture).value }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idAuthor") {
            context("Found") {
                it("Pictures are returned") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    author.pictures.append(objectsIn: [firstPicture, secondPicture])
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add(author)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.pictures.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add(author)
                            realm.add([firstPicture, secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await pictureDao.findPictures(byIdAuthor: author.idAuthor).value.map({ $0.thaw() }) }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idBook") {
            context("Found") {
                it("Pictures are returned") {  () -> Void in
                    let book = CachedBook.testBook()
                    book.pictures.append(objectsIn: [firstPicture, secondPicture])
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add(book)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.pictures.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let book = CachedBook.testBook()
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add(book)
                            realm.add([firstPicture, secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idMovement") {
            context("Pictures are found") {
                it("Pictures are returned") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    movement.pictures.append(objectsIn: [firstPicture, secondPicture])
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add(movement)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.pictures.toArray()))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add(movement)
                            realm.add([firstPicture, secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by idTheme") {
            context("Pictures are found") {
                it("Pictures are returned") {  () -> Void in
                    let theme = CachedTheme.testTheme()
                    theme.pictures.append(objectsIn: [firstPicture, secondPicture])
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add(theme)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal(theme.pictures.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let theme = CachedTheme.testTheme()
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add(theme)
                            realm.add([firstPicture, secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byIdTheme: theme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find pictures by nameSmall") {
            context("Found") {
                it("Picture is returned") {  () -> Void in
                    secondPicture.nameSmall = firstPicture.nameSmall
                    
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add([firstPicture, secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byNameSmall: firstPicture.nameSmall).waitingCompletion().first }.to(equal([firstPicture, secondPicture]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add([firstPicture, secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try pictureDao.findPictures(byNameSmall: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all pictures") {
            context("Found") {
                it("All Pictures are returned") {  () -> Void in
                    if let realm = (pictureDao as? DefaultPictureDao)?.realm {
                        try? realm.write {
                            realm.add([firstPicture, secondPicture, thirdPicture])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await pictureDao.findAllPictures().value.map({ $0.thaw() }) }.to(equal([firstPicture, secondPicture, thirdPicture]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {  () -> Void in
                    await expect { try await pictureDao.findAllPictures().value }.to(throwError())
                }
            }
        }
    }
}

extension CachedPicture {
    
    internal static func testPicture() -> CachedPicture {
        CachedPicture(idPicture: UUID().uuidString,
                      nameSmall: DataFactory.randomString(),
                      extension: DataFactory.randomString(),
                      comments: Map<String, String>(),
                      width: DataFactory.randomInt(),
                      height: DataFactory.randomInt(),
                      picture: DataFactory.randomData(),
                      topics: List<CachedTopic>()
        )
    }
}
