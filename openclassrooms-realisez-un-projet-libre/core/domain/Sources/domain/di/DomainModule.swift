//
//  DomainModule.swift
//  domain
//
//  Created by Damien Gironnet on 31/03/2023.
//

import Foundation
import Factory

///
/// Dependency injection for Domain module
///
//public class DomainModule: SharedContainer {
//    public static let createUserWithUserAndPasswordUseCase = Factory<CreateUserWithUserAndPasswordUseCase>(scope: .shared) { CreateUserWithUserAndPasswordUseCase() }
//    public static let signInWithAuthProviderUseCase = Factory<SignInWithAuthProviderUseCase>(scope: .shared) { SignInWithAuthProviderUseCase() }
//    public static let signInWithEmailAndPasswordUseCase = Factory<SignInWithEmailAndPasswordUseCase>(scope: .shared) { SignInWithEmailAndPasswordUseCase() }
//    public static let getAuthorsUseCase = Factory<GetAuthorsUseCase>(scope: .singleton) { GetAuthorsUseCase() }
//    public static let getAuthorByIdUseCase = Factory<GetAuthorByIdUseCase>(scope: .singleton) { GetAuthorByIdUseCase() }
//    public static let getBooksUseCase = Factory<GetBooksUseCase>(scope: .singleton) { GetBooksUseCase() }
//    public static let getBookByIdUseCase = Factory<GetBookByIdUseCase>(scope: .singleton) { GetBookByIdUseCase() }
//    public static let getFaithsUseCase = Factory<GetFaithsUseCase>(scope: .singleton) { GetFaithsUseCase() }
//    public static let getFaithByIdUseCase = Factory<GetFaithByIdUseCase>(scope: .singleton) { GetFaithByIdUseCase() }
//    public static let getForyouBiographiesUseCase = Factory<GetForyouBiographiesUseCase>(scope: .singleton) { GetForyouBiographiesUseCase() }
//    public static let getForyouPicturesUseCase = Factory<GetForyouPicturesUseCase>(scope: .singleton) { GetForyouPicturesUseCase() }
//    public static let getForyouQuotesUseCase = Factory<GetForyouQuotesUseCase>(scope: .singleton) { GetForyouQuotesUseCase() }
//    public static let getThemesUseCase = Factory<GetThemesUseCase>(scope: .singleton) { GetThemesUseCase() }
//    public static let getThemeByIdUseCase = Factory<GetThemeByIdUseCase>(scope: .singleton) { GetThemeByIdUseCase() }
//    public static let getCenturiesUseCase = Factory<GetCenturiesUseCase>(scope: .singleton) { GetCenturiesUseCase() }
//    public static let getBookmarksUseCase = Factory<GetBookmarksUseCase>(scope: .singleton) { GetBookmarksUseCase() }
//}

public extension SharedContainer {
    var createUserWithUserAndPasswordUseCase: Factory<CreateUserWithUserAndPasswordUseCase> { self { CreateUserWithUserAndPasswordUseCase() }.shared }
    var signInWithAuthProviderUseCase: Factory<SignInWithAuthProviderUseCase> { self { SignInWithAuthProviderUseCase() }.shared }
    var signInWithEmailAndPasswordUseCase: Factory<SignInWithEmailAndPasswordUseCase> { self { SignInWithEmailAndPasswordUseCase() }.shared }
    var getAuthorsUseCase: Factory<GetAuthorsUseCase> { self { GetAuthorsUseCase() }.singleton }
    var getAuthorByIdUseCase: Factory<GetAuthorByIdUseCase> { self { GetAuthorByIdUseCase() }.singleton }
    var getBooksUseCase: Factory<GetBooksUseCase> { self { GetBooksUseCase() }.singleton }
    var getBookByIdUseCase: Factory<GetBookByIdUseCase> { self { GetBookByIdUseCase() }.singleton }
    var getFaithsUseCase: Factory<GetFaithsUseCase> { self { GetFaithsUseCase() }.singleton }
    var getFaithByIdUseCase: Factory<GetFaithByIdUseCase> { self { GetFaithByIdUseCase() }.singleton }
    var getForyouBiographiesUseCase: Factory<GetForyouBiographiesUseCase> { self { GetForyouBiographiesUseCase() }.singleton }
    var getForyouPicturesUseCase: Factory<GetForyouPicturesUseCase> { self { GetForyouPicturesUseCase() }.singleton }
    var getForyouQuotesUseCase: Factory<GetForyouQuotesUseCase> { self { GetForyouQuotesUseCase() }.singleton }
    var getThemesUseCase: Factory<GetThemesUseCase> { self { GetThemesUseCase() }.singleton }
    var getThemeByIdUseCase: Factory<GetThemeByIdUseCase> { self { GetThemeByIdUseCase() }.singleton }
    var getCenturiesUseCase: Factory<GetCenturiesUseCase> { self { GetCenturiesUseCase() }.singleton }
    var getBookmarksUseCase: Factory<GetBookmarksUseCase> { self { GetBookmarksUseCase() }.singleton }
}
