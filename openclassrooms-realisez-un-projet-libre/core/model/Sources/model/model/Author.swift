//
//  Author.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Author fetched from an external layer data source
///
public struct Author: Equatable {

    public var idAuthor: String
    public var name: String
    public var language: String
    public var idRelatedAuthors: [String]?
    public var century: Century?
    public var surname: String?
    public var details: String?
    public var period: String?
    public var idMovement: String?
    public var bibliography: String?
    public var presentation: Presentation?
    public var mainPicture: Int?
    public var mcc1: String?
    public var quotes: [Quote]
    public var pictures: [Picture]?
    public var urls: [Url]?
    public var topics: [Topic]?
    
    public init(idAuthor: String,
                language: String,
                name: String,
                idRelatedAuthors: [String]? = nil,
                century: Century? = nil,
                surname: String? = nil,
                details: String? = nil,
                period: String? = nil,
                idMovement: String? = nil,
                bibliography: String? = nil,
                presentation: Presentation? = nil,
                mainPicture: Int? = nil,
                mcc1: String? = nil,
                quotes: [Quote],
                pictures: [Picture]? = nil,
                urls: [Url]? = nil,
                topics: [Topic]? = nil) {
        self.idAuthor = idAuthor
        self.name = name
        self.language = language
        self.idRelatedAuthors = idRelatedAuthors
        self.century = century
        self.surname = surname
        self.details = details
        self.period = period
        self.idMovement = idMovement
        self.bibliography = bibliography
        self.presentation = presentation
        self.mainPicture = mainPicture
        self.mcc1 = mcc1
        self.quotes = quotes
        self.pictures = pictures
        self.urls = urls
        self.topics = topics
    }
}
