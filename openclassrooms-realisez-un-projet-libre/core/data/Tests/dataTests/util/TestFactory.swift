//
//  TestFactory.swift
//  dataTests
//
//  Created by damien on 13/10/2022.
//

import Foundation
import util
import remote
import cache
import model
import RealmSwift

extension RemoteUser {
    
    static func testUser() -> RemoteUser {
        RemoteUser(uid: DataFactory.randomString(),
                   providerID: DataFactory.randomString(),
                   email: DataFactory.randomEmail(),
                   displayName: DataFactory.randomString(),
                   photo: DataFactory.randomData(),
                   bookmarks: nil)
    }
}

//extension RemoteFavourite {
//    
//    static func testFavourite() -> RemoteFavourite {
//        let favourite = RemoteFavourite(idDirectory: DataFactory.randomString(),
//                                        uidUser: DataFactory.randomString(),
//                                        idParentDirectory: DataFactory.randomString(),
//                                        directoryName: DataFactory.randomString(),
//                                        idAuthors: [DataFactory.randomInt(), DataFactory.randomInt()],
//                                        idBooks: [DataFactory.randomInt(), DataFactory.randomInt()],
//                                        idMovements: [DataFactory.randomInt(), DataFactory.randomInt()],
//                                        idThemes: [DataFactory.randomInt(), DataFactory.randomInt()],
//                                        idQuotes: [DataFactory.randomInt(), DataFactory.randomInt()],
//                                        idPictures: [DataFactory.randomInt(), DataFactory.randomInt()],
//                                        idPresentations: [DataFactory.randomInt(), DataFactory.randomInt()],
//                                        idUrls: [DataFactory.randomInt(), DataFactory.randomInt()])
//        
//        favourite.subDirectories = [
//            RemoteFavourite(idDirectory: DataFactory.randomString(),
//                            uidUser: DataFactory.randomString(),
//                            idParentDirectory: DataFactory.randomString(),
//                            directoryName: DataFactory.randomString(),
//                            idAuthors: [DataFactory.randomInt(), DataFactory.randomInt()],
//                            idBooks: [DataFactory.randomInt(), DataFactory.randomInt()],
//                            idMovements: [DataFactory.randomInt(), DataFactory.randomInt()],
//                            idThemes: [DataFactory.randomInt(), DataFactory.randomInt()],
//                            idQuotes: [DataFactory.randomInt(), DataFactory.randomInt()],
//                            idPictures: [DataFactory.randomInt(), DataFactory.randomInt()],
//                            idPresentations: [DataFactory.randomInt(), DataFactory.randomInt()],
//                            idUrls: [DataFactory.randomInt(), DataFactory.randomInt()])
//        ]
//        
//        return favourite
//    }
//}

extension CachedUser {
    
    static func testUser() -> CachedUser {
        CachedUser(id: DataFactory.randomString(),
                   providerID: DataFactory.randomString(),
                   email: DataFactory.randomString(),
                   displayName: DataFactory.randomString(),
                   photo: DataFactory.randomData())
    }
}

extension CachedAuthor {
    
    static func testAuthor() -> CachedAuthor {
        CachedAuthor(idAuthor: DataFactory.randomString(),
                     language: .none,
                     name: DataFactory.randomString(),
                     idRelatedAuthors: [DataFactory.randomString(), DataFactory.randomString()].toList(),
                     century: CachedCentury.testCentury(),
                     surname: DataFactory.randomString(),
                     details: DataFactory.randomString(),
                     period: DataFactory.randomString(),
                     idMovement: DataFactory.randomString(),
                     bibliography: DataFactory.randomString(),
                     presentation: CachedPresentation.testPresentation(),
                     mainPicture: DataFactory.randomInt(),
                     mcc1: DataFactory.randomString(),
                     quotes: [CachedQuote.testQuote(), CachedQuote.testQuote()].toList(),
                     pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                     urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList(),
                     topics:  [CachedTopic.testTopic(), CachedTopic.testTopic()].toList()
        )
    }
}

extension CachedBook {
    
    static func testBook() -> CachedBook {
        CachedBook(idBook: DataFactory.randomString(),
                   name: DataFactory.randomString(),
                   language: .none,
                   idRelatedBooks: [DataFactory.randomString(), DataFactory.randomString()].toList(),
                   century: CachedCentury.testCentury(),
                   details: DataFactory.randomString(),
                   period: DataFactory.randomString(),
                   idMovement: DataFactory.randomString(),
                   presentation: CachedPresentation.testPresentation(),
                   mcc1: DataFactory.randomString(),
                   quotes: [CachedQuote.testQuote(), CachedQuote.testQuote()].toList(),
                   pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                   urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList(),
                   topics:  [CachedTopic.testTopic(), CachedTopic.testTopic()].toList()
        )
    }
}

extension CachedCentury {
    
    static func testCentury() -> CachedCentury {
        CachedCentury(idCentury: DataFactory.randomString(),
                      century: DataFactory.randomString(),
                      presentations: [
                        DataFactory.randomString(): DataFactory.randomString(),
                        DataFactory.randomString(): DataFactory.randomString()
                      ].toMap(),
                      topics:  [CachedTopic.testTopic(), CachedTopic.testTopic()].toList()
        )
    }
}

extension CachedBookmark {
    static func testBookmark() -> CachedBookmark {
        CachedBookmark(id: DataFactory.randomString(),
                       idBookmarkGroup: DataFactory.randomString(),
                       note: DataFactory.randomString(),
                       idResource: DataFactory.randomString(),
                       kind: .unknown,
                       dateCreation: .now)
    }
}

extension CachedBookmarkGroup {
    static func testGroup() -> CachedBookmarkGroup {
        CachedBookmarkGroup(id: DataFactory.randomString(),
                            location: .device,
                            directoryName: DataFactory.randomString(),
                            groups: List(),
                            bookmarks: [CachedBookmark.testBookmark()].toList())
    }
}

extension CachedMovement {
    
    static func testMovement() -> CachedMovement {
        let movement = CachedMovement(idMovement: DataFactory.randomString(),
                                      idParentMovement: DataFactory.randomString(),
                                      name: DataFactory.randomString(),
                                      language: .none,
                                      idRelatedMovements: [DataFactory.randomString(), DataFactory.randomString()].toList(),
                                      mcc1: DataFactory.randomString(),
                                      mcc2: DataFactory.randomString(),
                                      presentation: CachedPresentation.testPresentation(),
                                      mcc3: DataFactory.randomString(),
                                      nbQuotes: DataFactory.randomInt(),
                                      nbAuthors: DataFactory.randomInt(),
                                      nbAuthorsQuotes: DataFactory.randomInt(),
                                      nbBooks: DataFactory.randomInt(),
                                      nbBooksQuotes: DataFactory.randomInt(),
                                      selected: DataFactory.randomBoolean(),
                                      nbTotalQuotes: DataFactory.randomInt(),
                                      nbTotalAuthors: DataFactory.randomInt(),
                                      nbTotalBooks: DataFactory.randomInt(),
                                      nbSubcourants: DataFactory.randomInt(),
                                      nbAuthorsSubcourants: DataFactory.randomInt(),
                                      nbBooksSubcourants: DataFactory.randomInt(),
                                      authors: [CachedAuthor.testAuthor(), CachedAuthor.testAuthor()].toList(),
                                      books: [CachedBook.testBook(), CachedBook.testBook()].toList(),
                                      movements: List<CachedMovement>(),
                                      pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                                      urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList(),
                                      topics: [CachedTopic.testTopic(), CachedTopic.testTopic()].toList()
        )
        
        movement.movements.append(
            CachedMovement(idMovement: DataFactory.randomString(),
                           idParentMovement: DataFactory.randomString(),
                           name: DataFactory.randomString(),
                           language: .none,
                           idRelatedMovements: [DataFactory.randomString(), DataFactory.randomString()].toList(),
                           mcc1: DataFactory.randomString(),
                           mcc2: DataFactory.randomString(),
                           presentation: CachedPresentation.testPresentation(),
                           mcc3: DataFactory.randomString(),
                           nbQuotes: DataFactory.randomInt(),
                           nbAuthors: DataFactory.randomInt(),
                           nbAuthorsQuotes: DataFactory.randomInt(),
                           nbBooks: DataFactory.randomInt(),
                           nbBooksQuotes: DataFactory.randomInt(),
                           selected: DataFactory.randomBoolean(),
                           nbTotalQuotes: DataFactory.randomInt(),
                           nbTotalAuthors: DataFactory.randomInt(),
                           nbTotalBooks: DataFactory.randomInt(),
                           nbSubcourants: DataFactory.randomInt(),
                           nbAuthorsSubcourants: DataFactory.randomInt(),
                           nbBooksSubcourants: DataFactory.randomInt(),
                           authors: [CachedAuthor.testAuthor(), CachedAuthor.testAuthor()].toList(),
                           books: [CachedBook.testBook(), CachedBook.testBook()].toList(),
                           movements: List<CachedMovement>(),
                           pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                           urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList(),
                           topics: [CachedTopic.testTopic(), CachedTopic.testTopic()].toList())
        )
        
        return movement
    }
}

extension CachedPicture {
    
    static func testPicture() -> CachedPicture {
        CachedPicture(idPicture: DataFactory.randomString(),
                      nameSmall: DataFactory.randomString(),
                      extension: DataFactory.randomString(),
                      comments: [
                        DataFactory.randomString(): DataFactory.randomString(),
                        DataFactory.randomString(): DataFactory.randomString()
                      ].toMap(),
                      width: DataFactory.randomInt(),
                      height: DataFactory.randomInt(),
                      picture: DataFactory.randomData(),
                      topics: [CachedTopic.testTopic(), CachedTopic.testTopic()].toList()
        )
    }
}

extension CachedPresentation {
    
    static func testPresentation() -> CachedPresentation {
        CachedPresentation(idPresentation: DataFactory.randomString(),
                           language: .none,
                           presentation: DataFactory.randomString(),
                           presentationTitle1: DataFactory.randomString(),
                           presentation1: DataFactory.randomString(),
                           presentationTitle2: DataFactory.randomString(),
                           presentation2: DataFactory.randomString(),
                           presentationTitle3: DataFactory.randomString(),
                           presentation3: DataFactory.randomString(),
                           presentationTitle4: DataFactory.randomString(),
                           presentation4: DataFactory.randomString(),
                           sourcePresentation: DataFactory.randomString(),
                           topics: [CachedTopic.testTopic(), CachedTopic.testTopic()].toList()
        )
    }
}

extension CachedQuote {
    
    static func testQuote() -> CachedQuote {
        CachedQuote(idQuote: DataFactory.randomString(),
                    topics: [CachedTopic.testTopic(), CachedTopic.testTopic()].toList(),
                    language: .none,
                    quote: DataFactory.randomString(),
                    source: DataFactory.randomString(),
                    reference: DataFactory.randomString(),
                    remarque: DataFactory.randomString(),
                    comment: DataFactory.randomString(),
                    commentName: DataFactory.randomString())
    }
}

extension CachedTheme {
    
    static func testTheme() -> CachedTheme {
        let theme = CachedTheme(idTheme: DataFactory.randomString(),
                                idParentTheme: DataFactory.randomString(),
                                name: DataFactory.randomString(),
                                language: .none,
                                idRelatedThemes: [DataFactory.randomString(), DataFactory.randomString()].toList(),
                                presentation: DataFactory.randomString(),
                                sourcePresentation: DataFactory.randomString(),
                                nbQuotes: DataFactory.randomInt(),
                                authors: [CachedAuthor.testAuthor(), CachedAuthor.testAuthor()].toList(),
                                books: [CachedBook.testBook(), CachedBook.testBook()].toList(),
                                themes: List<CachedTheme>(),
                                pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                                quotes: [CachedQuote.testQuote(), CachedQuote.testQuote()].toList(),
                                urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList(),
                                topics: [CachedTopic.testTopic(), CachedTopic.testTopic()].toList())
        
        theme.themes.append(
            CachedTheme(idTheme: DataFactory.randomString(),
                        idParentTheme: DataFactory.randomString(),
                        name: DataFactory.randomString(),
                        language: .none,
                        idRelatedThemes: [DataFactory.randomString(), DataFactory.randomString()].toList(),
                        presentation: DataFactory.randomString(),
                        sourcePresentation: DataFactory.randomString(),
                        nbQuotes: DataFactory.randomInt(),
                        authors: [CachedAuthor.testAuthor(), CachedAuthor.testAuthor()].toList(),
                        books: [CachedBook.testBook(), CachedBook.testBook()].toList(),
                        themes: List<CachedTheme>(),
                        pictures: [CachedPicture.testPicture(), CachedPicture.testPicture()].toList(),
                        quotes: [CachedQuote.testQuote(), CachedQuote.testQuote()].toList(),
                        urls: [CachedUrl.testUrl(), CachedUrl.testUrl()].toList(),
                        topics: [CachedTopic.testTopic(), CachedTopic.testTopic()].toList()))
        
        return theme
    }
}

extension CachedUrl {
    
    static func testUrl() -> CachedUrl {
        CachedUrl(idUrl: DataFactory.randomString(),
                  idSource: DataFactory.randomString(),
                  title: DataFactory.randomString(),
                  url: DataFactory.randomString(),
                  presentation: DataFactory.randomString())
    }
}

extension CachedTopic {
    
    static func testTopic() -> CachedTopic {
        CachedTopic(id: DataFactory.randomString(),
                    language: .none,
                    name: DataFactory.randomString(),
                    shortDescription: DataFactory.randomString(),
                    longDescription: DataFactory.randomString(),
                    idResource: DataFactory.randomString(),
                    kind: .unknown)
    }
}



extension model.User {
    
    static func testUser() -> model.User {
        User(id: DataFactory.randomString(),
             providerID: DataFactory.randomString(),
             uidUser: DataFactory.randomString(),
             email: DataFactory.randomString(),
             displayName: DataFactory.randomString(),
             photo: DataFactory.randomData())
    }
}

extension Author {
    
    static func testAuthor() -> Author {
        Author(idAuthor: DataFactory.randomString(),
               language: CachedLanguage.none.rawValue,
               name: DataFactory.randomString(),
               idRelatedAuthors: [DataFactory.randomString(), DataFactory.randomString()],
               century: Century.testCentury(),
               surname: DataFactory.randomString(),
               details: DataFactory.randomString(),
               period: DataFactory.randomString(),
               idMovement: DataFactory.randomString(),
               bibliography: DataFactory.randomString(),
               presentation: Presentation.testPresentation(),
               mainPicture: DataFactory.randomInt(),
               mcc1: DataFactory.randomString(),
               quotes: [Quote.testQuote(), Quote.testQuote()],
               pictures: [Picture.testPicture(), Picture.testPicture()],
               urls: [Url.testUrl(), Url.testUrl()]
        )
    }
}

extension Book {
    
    static func testBook() -> Book {
        Book(idBook: DataFactory.randomString(),
             name: DataFactory.randomString(),
             language: CachedLanguage.none.rawValue,
             idRelatedBooks: [DataFactory.randomString(), DataFactory.randomString()],
             century: Century.testCentury(),
             details: DataFactory.randomString(),
             period: DataFactory.randomString(),
             idMovement: DataFactory.randomString(),
             presentation: Presentation.testPresentation(),
             mcc1: DataFactory.randomString(),
             quotes: [Quote.testQuote(), Quote.testQuote()],
             pictures: [Picture.testPicture(), Picture.testPicture()],
             urls: [Url.testUrl(), Url.testUrl()]
        )
    }
}

extension Century {
    
    static func testCentury() -> Century {
        Century(idCentury: DataFactory.randomString(),
                century: DataFactory.randomString(),
                presentations: [
                    DataFactory.randomString(): DataFactory.randomString(),
                    DataFactory.randomString(): DataFactory.randomString()
                ]
        )
    }
}

extension Bookmark {
    static func testBookmark() -> Bookmark {
        Bookmark(id: DataFactory.randomString(),
                 idBookmarkGroup: DataFactory.randomString(),
                 note: DataFactory.randomString(),
                 idResource: DataFactory.randomString(),
                 kind: .unknown,
                 dateCreation: .now)
    }
}

extension BookmarkGroup {
    static func testGroup() -> BookmarkGroup  {
        BookmarkGroup(id: DataFactory.randomString(),
                      location: .device,
                      bookmarks: [Bookmark.testBookmark()])
    }
}

//extension Favourite {
//    
//    static func testFavourite() -> Favourite {
//        Favourite(idDirectory: DataFactory.randomString(),
//                  idParentDirectory: DataFactory.randomString(),
//                  directoryName: DataFactory.randomString(),
//                  subDirectories: nil,
//                  authors: [Author.testAuthor()],
//                  books: [Book.testBook()],
//                  movements: [Movement.testMovement()],
//                  themes: [Theme.testTheme()],
//                  quotes: [Quote.testQuote()],
//                  pictures: [Picture.testPicture()],
//                  presentations: [Presentation.testPresentation()],
//                  urls: [Url.testUrl()]
//        )
//    }
//}

extension Movement {
    
    static func testMovement() -> Movement {
        Movement(idMovement: DataFactory.randomString(),
                 idParentMovement: DataFactory.randomString(),
                 name: DataFactory.randomString(),
                 language: CachedLanguage.none.rawValue,
                 idRelatedMovements: [DataFactory.randomString(), DataFactory.randomString()],
                 mcc1: DataFactory.randomString(),
                 mcc2: DataFactory.randomString(),
                 presentation: Presentation.testPresentation(),
                 mcc3: DataFactory.randomString(),
                 nbQuotes: DataFactory.randomInt(),
                 nbAuthors: DataFactory.randomInt(),
                 nbAuthorsQuotes: DataFactory.randomInt(),
                 nbBooks: DataFactory.randomInt(),
                 nbBooksQuotes: DataFactory.randomInt(),
                 selected: DataFactory.randomBoolean(),
                 nbTotalQuotes: DataFactory.randomInt(),
                 nbTotalAuthors: DataFactory.randomInt(),
                 nbTotalBooks: DataFactory.randomInt(),
                 nbSubcourants: DataFactory.randomInt(),
                 nbAuthorsSubcourants: DataFactory.randomInt(),
                 nbBooksSubcourants: DataFactory.randomInt(),
                 authors: nil,
                 books: nil,
                 movements: nil,
                 pictures: nil,
                 urls: nil
        )
    }
}

extension Picture {
    
    static func testPicture() -> Picture {
        Picture(idPicture: DataFactory.randomString(),
                nameSmall: DataFactory.randomString(),
                extension: DataFactory.randomString(),
                comments: [
                    DataFactory.randomString(): DataFactory.randomString(),
                    DataFactory.randomString(): DataFactory.randomString()
                ],
                width: DataFactory.randomInt(),
                height: DataFactory.randomInt(),
                picture: DataFactory.randomData()
        )
    }
}

extension Presentation {
    
    static func testPresentation() -> Presentation {
        Presentation(idPresentation: DataFactory.randomString(),
                     language: CachedLanguage.none.rawValue,
                     presentation: DataFactory.randomString(),
                     presentationTitle1: DataFactory.randomString(),
                     presentation1: DataFactory.randomString(),
                     presentationTitle2: DataFactory.randomString(),
                     presentation2: DataFactory.randomString(),
                     presentationTitle3: DataFactory.randomString(),
                     presentation3: DataFactory.randomString(),
                     presentationTitle4: DataFactory.randomString(),
                     presentation4: DataFactory.randomString(),
                     sourcePresentation: DataFactory.randomString())
    }
}

extension Quote {
    
    static func testQuote() -> Quote {
        Quote(idQuote: DataFactory.randomString(),
              topics: [Topic.testTopic(), Topic.testTopic()],
              language: CachedLanguage.none.rawValue,
              quote: DataFactory.randomString(),
              source: DataFactory.randomString(),
              reference: DataFactory.randomString(),
              remarque: DataFactory.randomString(),
              comment: DataFactory.randomString(),
              commentName: DataFactory.randomString())
    }
}

extension Theme {
    
    static func testTheme() -> Theme {
        Theme(idTheme: DataFactory.randomString(),
              idParentTheme: DataFactory.randomString(),
              name: DataFactory.randomString(),
              language: CachedLanguage.none.rawValue,
              idRelatedThemes: [DataFactory.randomString(), DataFactory.randomString()],
              presentation: DataFactory.randomString(),
              sourcePresentation: DataFactory.randomString(),
              nbQuotes: DataFactory.randomInt(),
              authors: nil,
              books: nil,
              themes: nil,
              pictures: nil,
              quotes: nil,
              urls: nil
        )
    }
}

extension Url {
    
    static func testUrl() -> Url {
        Url(idUrl: DataFactory.randomString(),
            idSource: DataFactory.randomString(),
            title: DataFactory.randomString(),
            url: DataFactory.randomString(),
            presentation: DataFactory.randomString())
    }
}

extension Topic {
    
    static func testTopic() -> Topic {
        Topic(id: DataFactory.randomString(),
              language: CachedLanguage.none.rawValue,
              name: DataFactory.randomString(),
              shortDescription: DataFactory.randomString(),
              longDescription: DataFactory.randomString(),
              idResource: DataFactory.randomString(),
              kind: .unknown)
    }
}
