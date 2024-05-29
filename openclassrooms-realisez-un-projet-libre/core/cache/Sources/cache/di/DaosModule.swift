//
//  DaosModule.swift
//  cache
//
//  Created by Damien Gironnet on 30/03/2023.
//

import Foundation
import common
import Factory
import RealmSwift

///
/// Dependency injection for Cache module
///
//public class DaosModule: SharedContainer {
//    public static let authorDao = Factory<AuthorDao>(scope: .singleton) { DefaultAuthorDao() }
//    public static let bookDao = Factory<BookDao>(scope: .singleton) { DefaultBookDao() }
//    public static let centuryDao = Factory<CenturyDao>(scope: .singleton) { DefaultCenturyDao() }
//    public static let movementDao = Factory<MovementDao>(scope: .singleton) { DefaultMovementDao() }
//    public static let pictureDao = Factory<PictureDao>(scope: .singleton) { DefaultPictureDao() }
//    public static let presentationDao = Factory<PresentationDao>(scope: .singleton) { DefaultPresentationDao() }
//    public static let quoteDao = Factory<QuoteDao>(scope: .singleton) { DefaultQuoteDao() }
//    public static let themeDao = Factory<ThemeDao>(scope: .singleton) { DefaultThemeDao() }
//    public static let urlDao = Factory<UrlDao>(scope: .singleton) { DefaultUrlDao() }
//    public static let userDao = Factory<UserDao>(scope: .singleton) { DefaultUserDao() }
//    public static let bookmarkDao = Factory<BookmarkDao>(scope: .singleton) { DefaultBookmarkDao() }
//}

public extension SharedContainer {
    var authorDao: Factory<AuthorDao> { self { DefaultAuthorDao() }.singleton }
    var bookDao: Factory<BookDao> { self { DefaultBookDao() }.singleton }
    var centuryDao: Factory<CenturyDao> { self { DefaultCenturyDao() }.singleton }
    var movementDao: Factory<MovementDao> { self { DefaultMovementDao() }.singleton }
    var pictureDao: Factory<PictureDao> { self { DefaultPictureDao() }.singleton }
    var presentationDao: Factory<PresentationDao> { self { DefaultPresentationDao() }.singleton }
    var quoteDao: Factory<QuoteDao> { self { DefaultQuoteDao() }.singleton }
    var themeDao: Factory<ThemeDao> { self { DefaultThemeDao() }.singleton }
    var urlDao: Factory<UrlDao> { self { DefaultUrlDao() }.singleton }
    var userDao: Factory<UserDao> { self { DefaultUserDao() }.singleton }
    var bookmarkDao: Factory<BookmarkDao> { self { DefaultBookmarkDao() }.singleton }

}
