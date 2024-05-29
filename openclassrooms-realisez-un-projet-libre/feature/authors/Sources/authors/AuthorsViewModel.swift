//
//  AuthorsViewModel.swift
//  authors
//
//  Created by Damien Gironnet on 08/04/2023.
//

import SwiftUI
import Foundation
import domain
import model
import remote
import data
import ui
import Combine
import Factory
import navigation

///
/// ObservableObject representing the viewmodel for authors package
///
public class AuthorsViewModel: ObservableObject {
    
    @LazyInjected(\.mainRouter) var mainRouter
    @LazyInjected(\.getAuthorsUseCase) var getAuthors
    @LazyInjected(\.getAuthorByIdUseCase) var getAuthorById
    @LazyInjected(\.getFaithsUseCase) var getFaiths
    @LazyInjected(\.getCenturiesUseCase) private var getCenturies
    
    @Published internal var authorsFeedUiState: AuthorsFeedUiState = .Loading
        
    public init() {}
    
    public init(authorRepository: AuthorRepository,
                userDataRepository: UserDataRepository,
                movementRepository: MovementRepository,
                centuryRepository: CenturyRepository) {
        self.getAuthors = GetAuthorsUseCase(authorRepository: authorRepository)
        self.getAuthorById = GetAuthorByIdUseCase(authorRepository: authorRepository, userDataRepository: userDataRepository)
        self.getFaiths = GetFaithsUseCase(movementRepository: movementRepository)
        self.getCenturies = GetCenturiesUseCase(centuryRepository: centuryRepository)
    }
    
    internal func navigate(to followableTopic: FollowableTopic) {
        Task {
            mainRouter.visibleScreen = .splash

            DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
                self.mainRouter.visibleScreen = .content(followableTopic: followableTopic, returnToPrevious: false)
            }
        }
    }
    
    internal func feeds(onComplete: @escaping () -> Void) {
        Task {
            Publishers.Zip3(getAuthors().assertNoFailure(), getCenturies().assertNoFailure(), getFaiths().assertNoFailure())
            .sink(receiveValue: { authors, centuries, faiths in
                var mainFaiths = faiths.compactMap { $0.movements.flatMap { $0 } }.flatMap { $0 }
                let subFaiths = mainFaiths.compactMap { $0.movements.flatMap { $0 } }.flatMap { $0 }
                
                for subFaith in subFaiths {
                    if mainFaiths.map({ $0.name }).contains(subFaith.name) {
                        if let index = mainFaiths.firstIndex(where: { $0.name == subFaith.name }) {
                            mainFaiths.remove(at: index)
                        }
                    }
                }
                
                self.authorsFeedUiState = .Success(feed: (
                    authors: authors.reduce(into: []) { result, author in
                        let final = author
                        final.urls = nil
                        final.century = nil
                        
                        result.append(final)
                    },
                    centuries: centuries
                        .filter({ century in century.topics != nil &&
                            century.topics!.contains(where: { topic in
                                topic.language.prefix(2) == Locale.current.identifier.prefix(2) })
                        }),
                    faiths: (mainFaiths + subFaiths).filter({ $0.authors != nil })))
                
                onComplete()
            })
        }
    }
}

public class AuthorsUiState: ObservableObject {
    @Published public var state: AuthorsState

    public init(state: AuthorsState) {
        self.state = state
    }
}

public enum AuthorsState {
    case Loading
    case InProgress
    case Success(feed: [UserAuthor])
}

internal enum AuthorsFeedUiState {
    case Loading
    case InProgress
    case Success(feed: (authors: [UserAuthor], centuries: [Century], faiths: [UserFaith]))
}
