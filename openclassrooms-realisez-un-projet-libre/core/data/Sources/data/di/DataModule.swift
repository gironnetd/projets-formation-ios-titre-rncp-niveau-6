//
//  DataModule.swift
//  data
//
//  Created by Damien Gironnet on 30/03/2023.
//

import Foundation
import Factory

///
/// Dependency injection for Data module
///
//public class DataModule: SharedContainer {
//    public static let networkMonitor = Factory<NetworkMonitor>(scope: .singleton) { ConnectivityManagerNetworkMonitor() }
//    public static let authorRepository = Factory<AuthorRepository>(scope: .singleton) { DefaultAuthorRepository() }
//    public static let bookRepository = Factory<BookRepository>(scope: .singleton) { DefaultBookRepository() }
//    public static let centuryRepository = Factory<CenturyRepository>(scope: .singleton) { DefaultCenturyRepository() }
//    public static let movementRepository = Factory<MovementRepository>(scope: .singleton) { DefaultMovementRepository() }
//    public static let pictureRepository = Factory<PictureRepository>(scope: .singleton) { DefaultPictureRepository() }
//    public static let presentationRepository = Factory<PresentationRepository>(scope: .singleton) { DefaultPresentationRepository() }
//    public static let quoteRepository = Factory<QuoteRepository>(scope: .singleton) { DefaultQuoteRepository() }
//    public static let themeRepository = Factory<ThemeRepository>(scope: .singleton) { DefaultThemeRepository() }
//    public static let urlRepository = Factory<UrlRepository>(scope: .singleton) { DefaultUrlRepository() }
//    public static let userRepository = Factory<UserRepository>(scope: .singleton) { DefaultUserRepository() }
//    public static let bookmarkRepository = Factory<BookmarkRepository>(scope: .singleton) { DefaultBookmarkRepository() }
//    public static let userDataRepository = Factory<UserDataRepository>(scope: .singleton) { DefaultUserDataRepository() }
//}

public extension SharedContainer {
    var networkMonitor: Factory<NetworkMonitor> { self { ConnectivityManagerNetworkMonitor() }.singleton }
    var authorRepository: Factory<AuthorRepository> { self { DefaultAuthorRepository() }.singleton }
    var bookRepository: Factory<BookRepository> { self { DefaultBookRepository() }.singleton }
    var centuryRepository: Factory<CenturyRepository> { self { DefaultCenturyRepository() }.singleton }
    var movementRepository: Factory<MovementRepository> { self { DefaultMovementRepository() }.singleton }
    var pictureRepository: Factory<PictureRepository> { self { DefaultPictureRepository() }.singleton }
    var presentationRepository: Factory<PresentationRepository> { self { DefaultPresentationRepository() }.singleton }
    var quoteRepository: Factory<QuoteRepository> { self { DefaultQuoteRepository() }.singleton }
    var themeRepository: Factory<ThemeRepository> { self { DefaultThemeRepository() }.singleton }
    var urlRepository: Factory<UrlRepository> { self { DefaultUrlRepository() }.singleton }
    var userRepository: Factory<UserRepository> { self { DefaultUserRepository() }.singleton }
    var bookmarkRepository: Factory<BookmarkRepository> { self { DefaultBookmarkRepository() }.singleton }
    var userDataRepository: Factory<UserDataRepository> { self { DefaultUserDataRepository() }.singleton }

}
