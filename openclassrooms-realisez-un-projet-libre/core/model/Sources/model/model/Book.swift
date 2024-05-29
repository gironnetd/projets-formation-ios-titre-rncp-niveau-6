//
//  Book.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Book fetched from an external layer data source
///
public struct Book: Equatable {
    
    public var idBook: String
    public var name: String
    public var language: String
    public var idRelatedBooks: [String]?
    public var century: Century?
    public var details: String?
    public var period: String?
    public var idMovement: String?
    public var presentation: Presentation?
    public var mcc1: String?
    public var quotes: [Quote]
    public var pictures: [Picture]?
    public var urls: [Url]?
    public var topics: [Topic]?
    
    public init(idBook: String,
                name: String,
                language: String,
                idRelatedBooks: [String]? = nil,
                century: Century? = nil,
                details: String? = nil,
                period: String? = nil,
                idMovement: String? = nil,
                presentation: Presentation? = nil,
                mcc1: String? = nil,
                quotes: [Quote],
                pictures: [Picture]? = nil,
                urls: [Url]? = nil,
                topics: [Topic]? = nil
    ) {
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
}
