//
//  Theme.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Theme fetched from an external layer data source
///
public struct Theme: Equatable {

    public var idTheme: String
    public var idParentTheme: String?
    public var name: String
    public var language: String
    public var idRelatedThemes: [String]?
    public var presentation: String?
    public var sourcePresentation: String?
    public var nbQuotes: Int = 0
    public var authors: [Author]?
    public var books: [Book]?
    public var themes: [Theme]?
    public var pictures: [Picture]?
    public var quotes: [Quote]
    public var urls: [Url]?
    public var topics: [Topic]?
    
    public init(idTheme : String,
                idParentTheme: String? = nil,
                name: String,
                language: String,
                idRelatedThemes: [String]? = nil,
                presentation: String? = nil,
                sourcePresentation: String? = nil,
                nbQuotes : Int = 0,
                authors: [Author]? = nil,
                books : [Book]? = nil,
                themes: [Theme]? = nil,
                pictures: [Picture]? = nil,
                quotes: [Quote]? = nil,
                urls: [Url]? = nil,
                topics: [Topic]? = nil) {
        self.idTheme = idTheme
        self.idParentTheme = idParentTheme
        self.name = name
        self.language = language
        self.idRelatedThemes = idRelatedThemes
        self.presentation = presentation
        self.sourcePresentation = sourcePresentation
        self.nbQuotes = nbQuotes
        self.authors = authors
        self.books = books
        self.themes = themes
        self.pictures = pictures
        self.quotes = quotes != nil ? quotes! : []
        self.urls = urls
        self.topics = topics
    }
}
