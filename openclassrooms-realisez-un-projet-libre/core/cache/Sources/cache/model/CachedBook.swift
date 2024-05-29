//
//  CachedBook.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

///
/// Model used solely for the caching of a book
///
public class CachedBook: Object {
    
    @Persisted(primaryKey: true) public var idBook: String
    @Persisted public var name: String
    @Persisted public var language: CachedLanguage
    @Persisted public var idRelatedBooks: List<String>
    @Persisted public var century: CachedCentury?
    @Persisted public var details: String?
    @Persisted public var period: String?
    @Persisted public var idMovement: String?
    @Persisted public var presentation: CachedPresentation?
    @Persisted public var mcc1: String?
    @Persisted public var quotes: List<CachedQuote>
    @Persisted public var pictures: List<CachedPicture>
    @Persisted public var urls: List<CachedUrl>
    @Persisted public var topics: List<CachedTopic>
    
    public override init() {}
    
    public init(idBook: String,
                name: String,
                language: CachedLanguage,
                idRelatedBooks: List<String>,
                century: CachedCentury? = nil,
                details: String? = nil,
                period: String? = nil,
                idMovement: String? = nil,
                presentation: CachedPresentation? = nil,
                mcc1: String? = nil,
                quotes: List<CachedQuote>,
                pictures: List<CachedPicture>,
                urls: List<CachedUrl>,
                topics: List<CachedTopic>
    ) {
        super.init()
        self.idBook = idBook
        self.name = name
        self.language = language
        self.idRelatedBooks = idRelatedBooks
        self.century = century
        self.details = details
        self.period = period
        self.idMovement = idMovement
        self.presentation = presentation
        self.mcc1 = mcc1
        self.quotes = quotes
        self.pictures = pictures
        self.urls = urls
        self.topics = topics
    }
    
    public convenience init?(idBook: String) {
        guard let book = try? Realm().objects(CachedBook.self).where({ book in book.idBook == idBook }).first else { return nil }
        
        self.init(idBook: book.idBook,
                  name: book.name,
                  language: book.language,
                  idRelatedBooks: book.idRelatedBooks,
                  century: book.century,
                  details: book.details,
                  period: book.period,
                  idMovement: book.idMovement,
                  presentation: book.presentation,
                  mcc1: book.mcc1,
                  quotes: book.quotes,
                  pictures: book.pictures,
                  urls: book.urls,
                  topics: book.topics
        )
    }
}

extension CachedBook {
    public func asExternalModel() -> Book {
        Book(idBook:  self.idBook,
             name: self.name,
             language: self.language.rawValue,
             idRelatedBooks: self.idRelatedBooks.isNotEmpty ? self.idRelatedBooks.toArray() : nil,
             century: self.century?.asExternalModel(),
             details: self.details,
             period:  self.period,
             idMovement: self.idMovement,
             presentation: self.presentation?.asExternalModel(),
             mcc1: self.mcc1,
             quotes: self.quotes.map { quote in quote.asExternalModel() },
             pictures : self.pictures.isNotEmpty  ? self.pictures.map { picture in picture.asExternalModel() } : nil,
             urls: self.urls.isNotEmpty ? self.urls.map { url in url.asExternalModel() } : nil,
             topics: self.topics.isNotEmpty ? self.topics.map { topic in topic.asExternalModel() } : nil
        )
    }
}

extension Book {
    public func asCached() -> CachedBook {
        CachedBook(idBook:  self.idBook,
                   name: self.name,
                   language: CachedLanguage(rawValue: self.language) ?? .none,
                   idRelatedBooks: self.idRelatedBooks != nil ? self.idRelatedBooks!.toList() : List<String>(),
                   century: self.century?.asCached(),
                   details: self.details,
                   period:  self.period,
                   idMovement: self.idMovement,
                   presentation: self.presentation?.asCached(),
                   mcc1: self.mcc1,
                   quotes: self.quotes.map { quote in quote.asCached() }.toList(),
                   pictures : self.pictures != nil ? self.pictures!.map { picture in picture.asCached() }.toList() : List<CachedPicture>(),
                   urls: self.urls != nil ? self.urls!.map { url in url.asCached() }.toList() : List<CachedUrl>(),
                   topics: self.topics != nil ? self.topics!.map { topic in topic.asCached() }.toList() : List<CachedTopic>()
        )
    }
}
