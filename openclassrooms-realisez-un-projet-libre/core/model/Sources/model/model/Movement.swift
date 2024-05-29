//
//  Movement.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Movement fetched from an external layer data source
///
public struct Movement: Equatable {
    
    public var idMovement: String
    public var idParentMovement: String?
    public var name: String
    public var language: String
    public var idRelatedMovements: [String]?
    public var mcc1: String?
    public var mcc2: String?
    public var presentation: Presentation?
    public var mcc3: String?
    public var nbQuotes: Int
    public var nbAuthors: Int
    public var nbAuthorsQuotes: Int
    public var nbBooks: Int
    public var nbBooksQuotes: Int
    public var selected: Bool = false
    public var nbTotalQuotes: Int
    public var nbTotalAuthors: Int
    public var nbTotalBooks: Int
    public var nbSubcourants: Int
    public var nbAuthorsSubcourants: Int
    public var nbBooksSubcourants: Int
    public var authors: [Author]?
    public var books: [Book]?
    public var movements: [Movement]?
    public var pictures: [Picture]?
    public var urls: [Url]?
    public var topics: [Topic]?
    
    public init(idMovement : String,
                idParentMovement: String? = nil,
                name: String,
                language: String,
                idRelatedMovements: [String]?,
                mcc1: String? = nil,
                mcc2: String? = nil,
                presentation: Presentation? = nil,
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
                authors: [Author]? = nil,
                books: [Book]? = nil,
                movements: [Movement]? = nil,
                pictures: [Picture]? = nil,
                urls: [Url]? = nil,
                topics: [Topic]? = nil) {
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
    
    mutating public func appendToMovements(movement: Movement) {
        self.movements?.append(movement)
    }
}
