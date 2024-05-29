//
//  CachedMovement.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

///
/// Model used solely for the caching of a movement
///
public class CachedMovement: Object {
    
    @Persisted(primaryKey: true) public var idMovement: String
    @Persisted public var idParentMovement: String?
    @Persisted public var name: String
    @Persisted public var language: CachedLanguage
    @Persisted public var idRelatedMovements: List<String>
    @Persisted public var mcc1: String?
    @Persisted public var mcc2: String?
    @Persisted public var presentation: CachedPresentation?
    @Persisted public var mcc3: String?
    @Persisted public var nbQuotes: Int
    @Persisted public var nbAuthors: Int
    @Persisted public var nbAuthorsQuotes: Int
    @Persisted public var nbBooks: Int
    @Persisted public var nbBooksQuotes: Int
    @Persisted public var selected: Bool = false
    @Persisted public var nbTotalQuotes: Int
    @Persisted public var nbTotalAuthors: Int
    @Persisted public var nbTotalBooks: Int
    @Persisted public var nbSubcourants: Int
    @Persisted public var nbAuthorsSubcourants: Int
    @Persisted public var nbBooksSubcourants: Int
    @Persisted public var authors: List<CachedAuthor>
    @Persisted public var books: List<CachedBook>
    @Persisted public var movements: List<CachedMovement>
    @Persisted public var pictures: List<CachedPicture>
    @Persisted public var urls: List<CachedUrl>
    @Persisted public var topics: List<CachedTopic>
    
    public override init() {}
    
    public init(idMovement : String,
                idParentMovement: String? = nil,
                name: String,
                language: CachedLanguage,
                idRelatedMovements: List<String>,
                mcc1: String? = nil,
                mcc2: String? = nil,
                presentation: CachedPresentation? = nil,
                mcc3: String? = nil,
                nbQuotes: Int? = nil,
                nbAuthors: Int? = nil,
                nbAuthorsQuotes: Int? = nil,
                nbBooks: Int? = nil,
                nbBooksQuotes: Int? = nil,
                selected: Bool = false,
                nbTotalQuotes: Int? = nil,
                nbTotalAuthors: Int? = nil,
                nbTotalBooks: Int? = nil,
                nbSubcourants: Int? = nil,
                nbAuthorsSubcourants: Int? = nil,
                nbBooksSubcourants : Int? = nil,
                authors: List<CachedAuthor>,
                books: List<CachedBook>,
                movements: List<CachedMovement>,
                pictures: List<CachedPicture>,
                urls: List<CachedUrl>,
                topics: List<CachedTopic>) {
        super.init()
        self.idMovement = idMovement
        self.idParentMovement = idParentMovement
        self.name = name
        self.language = language
        self.idRelatedMovements = idRelatedMovements
        self.mcc1 = mcc1
        self.mcc2 = mcc2
        self.presentation = presentation
        self.mcc3 = mcc3
        self.nbQuotes = nbQuotes ?? 0
        self.nbAuthors = nbAuthors ?? 0
        self.nbAuthorsQuotes = nbAuthorsQuotes ?? 0
        self.nbBooks = nbBooks ?? 0
        self.nbBooksQuotes = nbBooksQuotes ?? 0
        self.selected = selected
        self.nbTotalQuotes = nbTotalQuotes ?? 0
        self.nbTotalAuthors = nbTotalAuthors ?? 0
        self.nbTotalBooks = nbTotalBooks ?? 0
        self.nbSubcourants = nbSubcourants ?? 0
        self.nbAuthorsSubcourants = nbAuthorsSubcourants ?? 0
        self.nbBooksSubcourants = nbBooksSubcourants ?? 0
        self.authors = authors
        self.books = books
        self.movements = movements
        self.pictures = pictures
        self.urls = urls
        self.topics = topics
    }
    
    public convenience init?(idMovement: String) {
        guard let movement = try? Realm().objects(CachedMovement.self).where({ movement in movement.idMovement == idMovement }).first else { return nil }
        
        self.init(idMovement : movement.idMovement,
                  idParentMovement: movement.idParentMovement,
                  name: movement.name,
                  language: movement.language,
                  idRelatedMovements: movement.idRelatedMovements,
                  mcc1: movement.mcc1,
                  mcc2: movement.mcc2,
                  presentation: movement.presentation,
                  mcc3: movement.mcc3,
                  nbQuotes: movement.nbQuotes,
                  nbAuthors: movement.nbAuthors,
                  nbAuthorsQuotes: movement.nbAuthorsQuotes,
                  nbBooks: movement.nbBooks,
                  nbBooksQuotes: movement.nbBooksQuotes,
                  selected: movement.selected,
                  nbTotalQuotes: movement.nbTotalQuotes,
                  nbTotalAuthors: movement.nbTotalAuthors,
                  nbTotalBooks: movement.nbTotalBooks,
                  nbSubcourants: movement.nbSubcourants,
                  nbAuthorsSubcourants: movement.nbAuthorsSubcourants,
                  nbBooksSubcourants : movement.nbBooksSubcourants,
                  authors: movement.authors,
                  books: movement.books,
                  movements: movement.movements,
                  pictures: movement.pictures,
                  urls: movement.urls,
                  topics: movement.topics)
    }
}

extension CachedMovement {
    public func asExternalModel() -> Movement {
        Movement(idMovement : self.idMovement,
                 idParentMovement: self.idParentMovement,
                 name: self.name,
                 language: self.language.rawValue,
                 idRelatedMovements: self.idRelatedMovements.isNotEmpty ? self.idRelatedMovements.toArray() : nil,
                 mcc1: self.mcc1,
                 mcc2: self.mcc2,
                 presentation: self.presentation?.asExternalModel(),
                 mcc3: self.mcc3,
                 nbQuotes: self.nbQuotes,
                 nbAuthors: self.nbAuthors,
                 nbAuthorsQuotes: self.nbAuthorsQuotes,
                 nbBooks: self.nbBooks,
                 nbBooksQuotes: self.nbBooksQuotes,
                 selected: self.selected,
                 nbTotalQuotes: self.nbTotalQuotes,
                 nbTotalAuthors: self.nbTotalAuthors,
                 nbTotalBooks: self.nbTotalBooks,
                 nbSubcourants: self.nbSubcourants,
                 nbAuthorsSubcourants: self.nbAuthorsSubcourants,
                 nbBooksSubcourants: self.nbBooksSubcourants,
                 authors: self.authors.isNotEmpty ? self.authors.map { author in author.asExternalModel() } : nil,
                 books: self.books.isNotEmpty ? self.books.map { book in book.asExternalModel() } : nil,
                 movements: self.movements.isNotEmpty ? self.movements.map { movement in movement.asExternalModel() } : nil,
                 pictures: self.pictures.isNotEmpty ? self.pictures.map { picture in picture.asExternalModel() } : nil,
                 urls: self.urls.isNotEmpty ? self.urls.map { url in url.asExternalModel() } : nil,
                 topics: self.topics.isNotEmpty ? self.topics.map { topic in topic.asExternalModel() } : nil)
    }
}

extension Movement {
    public func asCached() -> CachedMovement {
        CachedMovement(idMovement : self.idMovement,
                       idParentMovement: self.idParentMovement,
                       name: self.name,
                       language: CachedLanguage(rawValue: self.language) ?? .none,
                       idRelatedMovements: self.idRelatedMovements != nil ? self.idRelatedMovements!.toList() : List<String>(),
                       mcc1: self.mcc1,
                       mcc2: self.mcc2,
                       presentation: self.presentation?.asCached(),
                       mcc3: self.mcc3,
                       nbQuotes: self.nbQuotes,
                       nbAuthors: self.nbAuthors,
                       nbAuthorsQuotes: self.nbAuthorsQuotes,
                       nbBooks: self.nbBooks,
                       nbBooksQuotes: self.nbBooksQuotes,
                       selected: self.selected,
                       nbTotalQuotes: self.nbTotalQuotes,
                       nbTotalAuthors: self.nbTotalAuthors,
                       nbTotalBooks: self.nbTotalBooks,
                       nbSubcourants: self.nbSubcourants,
                       nbAuthorsSubcourants: self.nbAuthorsSubcourants,
                       nbBooksSubcourants : self.nbBooksSubcourants,
                       authors : self.authors != nil ? self.authors!.map { author in author.asCached() }.toList() : List<CachedAuthor>(),
                       books : self.books != nil ? self.books!.map { book in book.asCached() }.toList() : List<CachedBook>(),
                       movements : self.movements != nil ? self.movements!.map { movement in movement.asCached() }.toList() : List<CachedMovement>(),
                       pictures : self.pictures != nil ? self.pictures!.map { picture in picture.asCached() }.toList() : List<CachedPicture>(),
                       urls: self.urls != nil ? self.urls!.map { url in url.asCached() }.toList() : List<CachedUrl>(),
                       topics: self.topics != nil ? self.topics!.map { topic in topic.asCached() }.toList() : List<CachedTopic>()
        )
    }
}
