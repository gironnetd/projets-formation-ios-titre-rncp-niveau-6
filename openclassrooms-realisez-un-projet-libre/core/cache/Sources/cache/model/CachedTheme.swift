//
//  CachedTheme.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

///
/// Model used solely for the caching of a theme
///
public class CachedTheme: Object {
    
    @Persisted(primaryKey: true) public var idTheme: String
    @Persisted public var idParentTheme: String?
    @Persisted public var name: String
    @Persisted public var language: CachedLanguage
    @Persisted public var idRelatedThemes: List<String>
    @Persisted public var presentation: String?
    @Persisted public var sourcePresentation: String?
    @Persisted public var nbQuotes: Int
    @Persisted public var authors: List<CachedAuthor>
    @Persisted public var books: List<CachedBook>
    @Persisted public var themes: List<CachedTheme>
    @Persisted public var pictures: List<CachedPicture>
    @Persisted public var quotes: List<CachedQuote>
    @Persisted public var urls: List<CachedUrl>
    @Persisted public var topics: List<CachedTopic>
    
    public override init() {}
    
    public init(idTheme : String,
                idParentTheme: String? = nil,
                name: String,
                language: CachedLanguage,
                idRelatedThemes: List<String>,
                presentation: String? = nil,
                sourcePresentation: String? = nil,
                nbQuotes: Int = 0,
                authors: List<CachedAuthor>,
                books: List<CachedBook>,
                themes: List<CachedTheme>,
                pictures: List<CachedPicture>,
                quotes: List<CachedQuote>,
                urls: List<CachedUrl>,
                topics: List<CachedTopic>) {
        super.init()
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
        self.quotes = quotes
        self.urls = urls
        self.topics = topics
    }
    
    public convenience init?(idTheme: String) {
        guard let theme = try? Realm().objects(CachedTheme.self).where({ theme in theme.idTheme == idTheme }).first else { return nil }
        
        self.init(idTheme : theme.idTheme,
                  idParentTheme: theme.idParentTheme,
                  name: theme.name,
                  language: theme.language,
                  idRelatedThemes: theme.idRelatedThemes,
                  presentation: theme.presentation,
                  sourcePresentation: theme.sourcePresentation,
                  nbQuotes: theme.nbQuotes,
                  authors: theme.authors,
                  books: theme.books,
                  themes: theme.themes,
                  pictures: theme.pictures,
                  quotes: theme.quotes,
                  urls: theme.urls,
                  topics: theme.topics)
    }
}

extension CachedTheme {
    public func asExternalModel(onlyThemes: Bool = false) -> Theme {
        Theme(idTheme : self.idTheme,
              idParentTheme: self.idParentTheme,
              name: self.name,
              language: self.language.rawValue,
              idRelatedThemes: self.idRelatedThemes.isNotEmpty ? self.idRelatedThemes.toArray() : nil,
              presentation: self.presentation,
              sourcePresentation: self.sourcePresentation,
              nbQuotes : self.nbQuotes,
              authors : self.authors.isNotEmpty && onlyThemes == false ? self.authors.map { author in author.asExternalModel() } : nil,
              books : self.books.isNotEmpty && onlyThemes == false ? self.books.map { book in book.asExternalModel() } : nil,
              themes : self.themes.isNotEmpty ? self.themes.map { theme in theme.asExternalModel(onlyThemes: true) } : nil,
              pictures : self.pictures.isNotEmpty ? self.pictures.map { picture in picture.asExternalModel() } : nil,
              quotes: self.quotes.map { quote in quote.asExternalModel() },
              urls: self.urls.isNotEmpty && onlyThemes == false ? self.urls.map { url in url.asExternalModel() } : nil,
              topics: self.topics.isNotEmpty ? self.topics.map { topic in topic.asExternalModel() } : nil)
    }
}

extension Theme {
    public func asCached() -> CachedTheme {
        CachedTheme(idTheme : self.idTheme,
                    idParentTheme: self.idParentTheme,
                    name: self.name,
                    language: CachedLanguage(rawValue: self.language) ?? .none,
                    idRelatedThemes: self.idRelatedThemes != nil ? self.idRelatedThemes!.toList() : List<String>(),
                    presentation: self.presentation,
                    sourcePresentation: self.sourcePresentation,
                    nbQuotes : self.nbQuotes,
                    authors : self.authors != nil ? self.authors!.map { author in author.asCached() }.toList() : List<CachedAuthor>(),
                    books : self.books != nil ? self.books!.map { book in book.asCached() }.toList() : List<CachedBook>(),
                    themes : self.themes != nil ? self.themes!.map { theme in theme.asCached() }.toList() : List<CachedTheme>(),
                    pictures : self.pictures != nil ? self.pictures!.map { picture in picture.asCached() }.toList() : List<CachedPicture>(),
                    quotes: self.quotes.map { quote in quote.asCached() }.toList(),
                    urls: self.urls != nil ? self.urls!.map { url in url.asCached() }.toList() : List<CachedUrl>(),
                    topics: self.topics != nil ? self.topics!.map { topic in topic.asCached() }.toList() : List<CachedTopic>())
    }
}
