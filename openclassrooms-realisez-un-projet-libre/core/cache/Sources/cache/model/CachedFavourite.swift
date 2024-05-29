//
//  CachedFavorite.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

//enum CachedFavouriteGenre: String, PersistableEnum {
//    case author, book, movement, theme, quote, picture, biography, url
//}

///
/// Model used solely for the caching of a favourite
///
//public class CachedFavourite: Object {
//    
//    @Persisted(primaryKey: true) var idDirectory: String
//    @Persisted var idParentDirectory: String?
//    @Persisted var directoryName: String
//    @Persisted var directories: List<CachedFavourite>
//    @Persisted var authors: List<String>
//    @Persisted var books: List<String>
//    @Persisted var movements: List<String>
//    @Persisted var themes: List<String>
//    @Persisted var quotes: List<String>
//    @Persisted var pictures: List<String>
//    @Persisted var presentations: List<String>
//    @Persisted var urls: List<String>
//    
//    public override init() {}
//    
//    public init(idDirectory: String,
//                idParentDirectory: String?,
//                directoryName: String = "",
//                directories: List<CachedFavourite>,
//                authors: List<String>,
//                books: List<String>,
//                movements: List<String>,
//                themes: List<String>,
//                quotes: List<String>,
//                pictures: List<String>,
//                presentations: List<String>,
//                urls: List<String>) {
//        super.init()
//        self.idDirectory = idDirectory
//        self.idParentDirectory = idParentDirectory
//        self.directoryName = directoryName
//        self.directories = directories
//        self.authors = authors
//        self.books = books
//        self.movements = movements
//        self.themes = themes
//        self.quotes = quotes
//        self.pictures = pictures
//        self.presentations = presentations
//        self.urls = urls
//    }
//    
//    public init(idDirectory: String,
//                idParentDirectory: String?,
//                directoryName: String = "",
//                directories: [CachedFavourite] = [],
//                idAuthors: [String] = [],
//                idBooks: [String] = [],
//                idMovements: [String] = [],
//                idThemes: [String] = [],
//                idQuotes: [String] = [],
//                idPictures: [String] = [],
//                idPresentations: [String] = [],
//                idUrls: [String] = []) {
//        super.init()
//        self.idDirectory = idDirectory
//        self.idParentDirectory = idParentDirectory
//        self.directoryName = directoryName
//        self.directories = directories.toList()
//        self.authors = idAuthors.toList()
//        self.books = idBooks.toList()
//        self.movements = idMovements.toList()
//        self.themes = idThemes.toList()
//        self.quotes = idQuotes.toList()
//        self.pictures = idPictures.toList()
//        self.presentations = idPresentations.toList()
//        self.urls = idUrls.toList()
//        
////        if let directories = directories {
////            
////        }
////        
////        if let idAuthors = idAuthors {
////            
////        }
////        
////        if let idBooks = idBooks {
////            
////        }
////        
////        if let idMovements = idMovements {
////            
////        }
////        
////        if let idThemes = idThemes {
////            
////        }
////        
////        if let idQuotes = idQuotes {
////            
////        }
////        
////        if let idPictures = idPictures {
////            
////        }
////        
////        if let idPresentations = idPresentations {
////            
////        }
////        
////        if let idUrls = idUrls {
////            
////        }
//    }
//    
//    public override func isEqual(_ object: Any?) -> Bool {
//        guard let favourite = object as? CachedFavourite else {
//            return false
//        }
//        
//        return self.idDirectory == favourite.idDirectory &&
//            self.idParentDirectory == favourite.idParentDirectory &&
//            self.directoryName == favourite.directoryName &&
//            self.directories == favourite.directories &&
//            self.authors == favourite.authors &&
//            self.books == favourite.books &&
//            self.movements == favourite.movements &&
//            self.themes == favourite.themes &&
//            self.quotes == favourite.quotes &&
//            self.pictures == favourite.pictures &&
//            self.presentations == favourite.presentations &&
//            self.urls == favourite.urls
//    }
//}
//
//extension CachedFavourite {
//    public func asExternalModel() -> Favourite {
//        Favourite(idDirectory: self.idDirectory,
//                  idParentDirectory: self.idParentDirectory,
//                  directoryName: self.directoryName,
//                  directories: self.directories.isNotEmpty ? self.directories.toArray().map { $0.asExternalModel() } : [] //,
////                  authors: self.authors.isNotEmpty ? self.authors.toArray().map { $0.asExternalModel() } : [],
////                  books: self.books.isNotEmpty ? self.books.toArray().map { $0.asExternalModel() } : [],
////                  movements: self.movements.isNotEmpty ? self.movements.toArray().map { $0.asExternalModel() } : [],
////                  themes: self.themes.isNotEmpty ? self.themes.toArray().map { $0.asExternalModel() } : [],
////                  quotes: self.quotes.isNotEmpty ? self.quotes.toArray().map { $0.asExternalModel() } : [],
////                  pictures: self.pictures.isNotEmpty ? self.pictures.toArray().map { $0.asExternalModel() } : [],
////                  presentations: self.presentations.isNotEmpty ? self.presentations.toArray().map { $0.asExternalModel() } : [],
////                  urls: self.urls.isNotEmpty ? self.urls.toArray().map { $0.asExternalModel() } : []
//        )
//    }
//}
//
////extension Favourite {
////    public func asCached() -> CachedFavourite {
////        CachedFavourite(
////            idDirectory: self.idDirectory,
////            idParentDirectory: self.idParentDirectory,
////            directoryName: self.directoryName,
////            directories: self.directories.map { $0.asCached() }.toList(),
////            authors: self.favourites.filter({ $0.genre == .author }).map { $0.id }.toList(),
////            books: self.favourites.filter({ $0.genre == .book }).map { $0.id }.toList(),
////            movements: self.favourites.filter({ $0.genre == .movement }).map { $0.id }.toList(),
////            themes: self.favourites.filter({ $0.genre == .theme }).map { $0.id }.toList(),
////            quotes: self.favourites.filter({ $0.genre == .quote }).map { $0.id }.toList(),
////            pictures: self.favourites.filter({ $0.genre == .picture }).map { $0.id }.toList(),
////            presentations: self.favourites.filter({ $0.genre == .biography }).map { $0.id }.toList(),
////            urls: self.favourites.filter({ $0.genre == .url }).map { $0.id }.toList()
////        )
////    }
////}
