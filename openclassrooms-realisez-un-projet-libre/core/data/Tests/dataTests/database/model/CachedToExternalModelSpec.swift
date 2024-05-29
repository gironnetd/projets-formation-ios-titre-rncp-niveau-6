//
//  CachedToExternalModelSpec.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Quick
import Nimble
import util
import cache
import model

class CachedToExternalModelSpec: QuickSpec {
    
    override func spec() {
        
        describe("Cached user") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedUser = CachedUser.testUser()
                    let externalModel = cachedUser.asExternalModel()
                    
                    expect { externalModel.id }.to(equal(cachedUser.id))
                    expect { externalModel.providerID }.to(equal(cachedUser.providerID))
                    expect { externalModel.email }.to(equal(cachedUser.email))
                    expect { externalModel.displayName }.to(equal(cachedUser.displayName))
                    expect { externalModel.photo }.to(equal(cachedUser.photo))
//                    expect { externalModel.favourites }.to(equal(cachedUser.favourites?.asExternalModel()))
                }
            }
        }
        
        describe("Cached author") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedAuthor = CachedAuthor.testAuthor()
                    let externalModel = cachedAuthor.asExternalModel()
                                        
                    expect { externalModel.idAuthor }.to(equal(cachedAuthor.idAuthor))
                    expect { externalModel.name }.to(equal(cachedAuthor.name))
                    expect { externalModel.language }.to(equal(cachedAuthor.language.rawValue))
                    expect { externalModel.century }.to(equal(cachedAuthor.century?.asExternalModel()))
                    expect { externalModel.surname }.to(equal(cachedAuthor.surname))
                    expect { externalModel.details }.to(equal(cachedAuthor.details))
                    expect { externalModel.period }.to(equal(cachedAuthor.period))
                    expect { externalModel.idMovement }.to(equal(cachedAuthor.idMovement))
                    expect { externalModel.bibliography }.to(equal(cachedAuthor.bibliography))
                    expect { externalModel.presentation }.to(equal(cachedAuthor.presentation?.asExternalModel()))
                    expect { externalModel.mainPicture }.to(equal(cachedAuthor.mainPicture))
                    expect { externalModel.mcc1 }.to(equal(cachedAuthor.mcc1))
                    expect { externalModel.quotes }.to(equal(cachedAuthor.quotes.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.pictures }.to(equal(cachedAuthor.pictures.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.urls }.to(equal(cachedAuthor.urls.toArray().map { $0.asExternalModel() }))
                }
            }
        }
        
        describe("Cached book") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedBook = CachedBook.testBook()
                    let externalModel = cachedBook.asExternalModel()
                                        
                    expect { externalModel.idBook }.to(equal(cachedBook.idBook))
                    expect { externalModel.name }.to(equal(cachedBook.name))
                    expect { externalModel.language }.to(equal(cachedBook.language.rawValue))
                    expect { externalModel.idRelatedBooks }.to(equal(cachedBook.idRelatedBooks.toArray() ))
                    expect { externalModel.century }.to(equal(cachedBook.century?.asExternalModel()))
                    expect { externalModel.details }.to(equal(cachedBook.details))
                    expect { externalModel.period }.to(equal(cachedBook.period))
                    expect { externalModel.idMovement }.to(equal(cachedBook.idMovement))
                    expect { externalModel.presentation }.to(equal(cachedBook.presentation?.asExternalModel()))
                    expect { externalModel.mcc1 }.to(equal(cachedBook.mcc1))
                    expect { externalModel.quotes }.to(equal(cachedBook.quotes.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.pictures }.to(equal(cachedBook.pictures.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.urls }.to(equal(cachedBook.urls.toArray().map { $0.asExternalModel() }))
                }
            }
        }
        
        describe("Cached century") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedCentury = CachedCentury.testCentury()
                    let externalModel = cachedCentury.asExternalModel()
                
                    expect { externalModel.idCentury }.to(equal(cachedCentury.idCentury))
                    expect { externalModel.century }.to(equal(cachedCentury.century))
                    expect { externalModel.presentations }.to(equal(cachedCentury.presentations.toDictionary()))
                }
            }
        }
        
//        describe("Cached favourite") {
//            context("Mapped to external model") {
//                it("Value is equal") {
//                    let cachedFavourite = CachedFavourite.testFavourite()
//                    let externalModel = cachedFavourite.asExternalModel()
//                                        
//                    expect { externalModel.idDirectory }.to(equal(cachedFavourite.idDirectory))
//                    expect { externalModel.idParentDirectory }.to(equal(cachedFavourite.idParentDirectory))
//                    expect { externalModel.directoryName }.to(equal(cachedFavourite.directoryName))
//                    expect { externalModel.subDirectories }.to(equal(cachedFavourite.subDirectories.toArray().map { $0.asExternalModel() }))
//                    expect { externalModel.authors }.to(equal(cachedFavourite.authors.toArray().map { $0.asExternalModel() }))
//                    expect { externalModel.books }.to(equal(cachedFavourite.books.toArray().map { $0.asExternalModel() }))
//                    expect { externalModel.movements }.to(equal(cachedFavourite.movements.toArray().map { $0.asExternalModel() }))
//                    expect { externalModel.themes }.to(equal(cachedFavourite.themes.toArray().map { $0.asExternalModel() }))
//                    expect { externalModel.quotes }.to(equal(cachedFavourite.quotes.toArray().map { $0.asExternalModel() }))
//                    expect { externalModel.pictures }.to(equal(cachedFavourite.pictures.toArray().map { $0.asExternalModel() }))
//                    expect { externalModel.presentations }.to(equal(cachedFavourite.presentations.toArray().map { $0.asExternalModel() }))
//                    expect { externalModel.urls }.to(equal(cachedFavourite.urls.toArray().map { $0.asExternalModel() }))
//                }
//            }
//        }
        
        describe("Cached movement") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedMovement = CachedMovement.testMovement()
                    let externalModel = cachedMovement.asExternalModel()
                
                    expect { externalModel.idMovement }.to(equal(cachedMovement.idMovement))
                    expect { externalModel.idParentMovement }.to(equal(cachedMovement.idParentMovement))
                    expect { externalModel.name }.to(equal(cachedMovement.name))
                    expect { externalModel.language }.to(equal(cachedMovement.language.rawValue))
                    expect { externalModel.idRelatedMovements }.to(equal(cachedMovement.idRelatedMovements.toArray()))
                    expect { externalModel.mcc1 }.to(equal(cachedMovement.mcc1))
                    expect { externalModel.mcc2 }.to(equal(cachedMovement.mcc2))
                    expect { externalModel.presentation }.to(equal(cachedMovement.presentation?.asExternalModel()))
                    expect { externalModel.mcc3 }.to(equal(cachedMovement.mcc3))
                    expect { externalModel.nbQuotes }.to(equal(cachedMovement.nbQuotes))
                    expect { externalModel.nbAuthors }.to(equal(cachedMovement.nbAuthors))
                    expect { externalModel.nbAuthorsQuotes }.to(equal(cachedMovement.nbAuthorsQuotes))
                    expect { externalModel.nbBooks }.to(equal(cachedMovement.nbBooks))
                    expect { externalModel.nbBooksQuotes }.to(equal(cachedMovement.nbBooksQuotes))
                    expect { externalModel.selected }.to(equal(cachedMovement.selected))
                    expect { externalModel.nbTotalQuotes }.to(equal(cachedMovement.nbTotalQuotes))
                    expect { externalModel.nbTotalAuthors }.to(equal(cachedMovement.nbTotalAuthors))
                    expect { externalModel.nbTotalBooks }.to(equal(cachedMovement.nbTotalBooks))
                    expect { externalModel.nbSubcourants }.to(equal(cachedMovement.nbSubcourants))
                    expect { externalModel.nbAuthorsSubcourants }.to(equal(cachedMovement.nbAuthorsSubcourants))
                    expect { externalModel.nbBooksSubcourants }.to(equal(cachedMovement.nbBooksSubcourants))
                    expect { externalModel.authors }.to(equal(cachedMovement.authors.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.books }.to(equal(cachedMovement.books.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.movements }.to(equal(cachedMovement.movements.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.urls }.to(equal(cachedMovement.urls.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.pictures }.to(equal(cachedMovement.pictures.toArray().map { $0.asExternalModel() }))
                }
            }
        }
        
        describe("Cached picture") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedPicture = CachedPicture.testPicture()
                    let externalModel = cachedPicture.asExternalModel()
                    
                    expect { externalModel.idPicture }.to(equal(cachedPicture.idPicture))
                    expect { externalModel.nameSmall }.to(equal(cachedPicture.nameSmall))
                    expect { externalModel.extension }.to(equal(cachedPicture.extension))
                    expect { externalModel.comments }.to(equal(cachedPicture.comments.toDictionary()))
                    expect { externalModel.width }.to(equal(cachedPicture.width))
                    expect { externalModel.height }.to(equal(cachedPicture.height))
                    expect { externalModel.portrait }.to(equal(cachedPicture.portrait))
                    expect { externalModel.picture }.to(equal(cachedPicture.picture))
                }
            }
        }
        
        describe("Cached presentation") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedPresentation = CachedPresentation.testPresentation()
                    let externalModel = cachedPresentation.asExternalModel()
                    
                    expect { externalModel.idPresentation }.to(equal(cachedPresentation.idPresentation))
                    expect { externalModel.presentation }.to(equal(cachedPresentation.presentation))
                    expect { externalModel.presentationTitle1 }.to(equal(cachedPresentation.presentationTitle1))
                    expect { externalModel.presentation1 }.to(equal(cachedPresentation.presentation1))
                    expect { externalModel.presentationTitle2 }.to(equal(cachedPresentation.presentationTitle2))
                    expect { externalModel.presentation2 }.to(equal(cachedPresentation.presentation2))
                    expect { externalModel.presentationTitle3 }.to(equal(cachedPresentation.presentationTitle3))
                    expect { externalModel.presentation3 }.to(equal(cachedPresentation.presentation3))
                    expect { externalModel.presentationTitle4 }.to(equal(cachedPresentation.presentationTitle4))
                    expect { externalModel.presentation4 }.to(equal(cachedPresentation.presentation4))
                    expect { externalModel.sourcePresentation }.to(equal(cachedPresentation.sourcePresentation))
                }
            }
        }
        
        describe("Cached quote") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedQuote = CachedQuote.testQuote()
                    let externalModel = cachedQuote.asExternalModel()
                    
                    expect { externalModel.idQuote }.to(equal(cachedQuote.idQuote))
                    expect { externalModel.topics }.to(equal(cachedQuote.topics.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.quote }.to(equal(cachedQuote.quote))
                    expect { externalModel.source }.to(equal(cachedQuote.source))
                    expect { externalModel.reference }.to(equal(cachedQuote.reference))
                    expect { externalModel.remarque }.to(equal(cachedQuote.remarque))
                    expect { externalModel.comment }.to(equal(cachedQuote.comment))
                    expect { externalModel.commentName }.to(equal(cachedQuote.commentName))
                }
            }
        }
        
        describe("Cached theme") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedTheme = CachedTheme.testTheme()
                    let externalModel = cachedTheme.asExternalModel()
                    
                    expect { externalModel.idTheme }.to(equal(cachedTheme.idTheme))
                    expect { externalModel.idParentTheme }.to(equal(cachedTheme.idParentTheme))
                    expect { externalModel.name }.to(equal(cachedTheme.name))
                    expect { externalModel.language }.to(equal(cachedTheme.language.rawValue))
                    expect { externalModel.idRelatedThemes }.to(equal(cachedTheme.idRelatedThemes.toArray()))
                    expect { externalModel.presentation }.to(equal(cachedTheme.presentation))
                    expect { externalModel.sourcePresentation }.to(equal(cachedTheme.sourcePresentation))
                    expect { externalModel.nbQuotes }.to(equal(cachedTheme.nbQuotes))
                    expect { externalModel.name }.to(equal(cachedTheme.name))
                    expect { externalModel.language }.to(equal(cachedTheme.language.rawValue))
                    expect { externalModel.idRelatedThemes }.to(equal(cachedTheme.idRelatedThemes.toArray()))
                    expect { externalModel.presentation }.to(equal(cachedTheme.presentation))
                    expect { externalModel.sourcePresentation }.to(equal(cachedTheme.sourcePresentation))
                    expect { externalModel.authors }.to(equal(cachedTheme.authors.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.books }.to(equal(cachedTheme.books.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.themes }.to(equal(cachedTheme.themes.toArray().map { $0.asExternalModel(onlyThemes: true) }))
                    expect { externalModel.quotes }.to(equal(cachedTheme.quotes.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.pictures }.to(equal(cachedTheme.pictures.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.quotes }.to(equal(cachedTheme.quotes.toArray().map { $0.asExternalModel() }))
                    expect { externalModel.urls }.to(equal(cachedTheme.urls.toArray().map { $0.asExternalModel() }))
                }
            }
        }
        
        describe("Cached url") {
            context("Mapped to external model") {
                it("Value is equal") {
                    let cachedUrl = CachedUrl.testUrl()
                    let externalModel = cachedUrl.asExternalModel()
                    
                    expect { externalModel.idUrl }.to(equal(cachedUrl.idUrl))
                    expect { externalModel.idSource }.to(equal(cachedUrl.idSource))
                    expect { externalModel.title }.to(equal(cachedUrl.title))
                    expect { externalModel.url }.to(equal(cachedUrl.url))
                    expect { externalModel.presentation }.to(equal(cachedUrl.presentation))
                }
            }
        }
    }
}
