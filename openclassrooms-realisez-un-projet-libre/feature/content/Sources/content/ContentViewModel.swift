//
//  ContentViewModel.swift
//  content
//
//  Created by Damien Gironnet on 01/08/2023.
//

import Foundation
import SwiftUI
import Factory
import navigation
import model
import ui
import domain
import data
import designsystem
import Combine

///
/// ObservableObject representing the viewmodel for content package
///
public class ContentViewModel: ObservableObject {
    
    @LazyInjected(\.mainRouter) var mainRouter
    @LazyInjected(\.getAuthorByIdUseCase) var getAuthorById
    @LazyInjected(\.getBookByIdUseCase) var getBookById
    @LazyInjected(\.getFaithByIdUseCase) var getFaithById
    @LazyInjected(\.getThemeByIdUseCase) var getThemeById
    
    @Published internal var quotesUiState: CurrentValueSubject<QuotesUiState, Never> = CurrentValueSubject(.init(state: .Loading))
    @Published internal var picturesUiState: CurrentValueSubject<PicturesUiState, Never> = CurrentValueSubject(.init(state: .Loading))
    @Published internal var biographyUiState: CurrentValueSubject<BiographyUiState, Never> = CurrentValueSubject(.init(state: .Loading))
    
    @Published internal var userResource: UserResource!
    
    @Published internal var feedsHasBeenSucceeded: Bool = false
    
    var cancellables: Set<AnyCancellable> = Set()

    internal init() {}
    
    internal func navigate(to followableTopic: FollowableTopic, returnToPrevious: Bool) {
        withAnimation {
            mainRouter.visibleScreen = .splash
            
            DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
                self.mainRouter.visibleScreen = .content(followableTopic: followableTopic, returnToPrevious: returnToPrevious)
            }
        }
    }
    
    internal func populateFeeds(from followableTopic: FollowableTopic, onComplete: @escaping () -> Void) {
        switch followableTopic.topic.kind {
        case .author:
            authorFeed(
                idAuthor: followableTopic.topic.idResource,
                onComplete: {
                    onComplete()
                    self.feedsHasBeenSucceeded = true
                })
        case .book:
            bookFeed(
                idBook: followableTopic.topic.idResource,
                onComplete: {
                    onComplete()
                    self.feedsHasBeenSucceeded = true
                })
        case .movement:
            faithFeed(
                idFaith: followableTopic.topic.idResource,
                onComplete: {
                    onComplete()
                    self.feedsHasBeenSucceeded = true
                })
        case .theme:
            themeFeed(
                idTheme: followableTopic.topic.idResource,
                onComplete: {
                    onComplete()
                    self.feedsHasBeenSucceeded = true
                })
        default:
            break
        }
    }

    internal func authorFeed(idAuthor: String, onComplete: @escaping () -> Void) {
        getAuthorById(idAuthor)
            .assertNoFailure()
            .sink(receiveValue: { [self] author in
                userResource = author
                quotesUiState.value.state = .Success(feed: author.quotes.reduce(into: [UserQuote]()) { result, quote in
                    let final = quote
                    final.followableTopics.removeAll(where: { followableTopic in
                        followableTopic.topic.kind == .century ||
                        followableTopic.topic.kind == .movement ||
                        followableTopic.topic.kind == .author
                    })
                    result.append(final)
                })
                
                if let biography = author.presentation {
                    biographyUiState.value.state = .Success(feed: biography)
                }
                
                if let pictures = author.pictures {
                    picturesUiState.value.state = .Success(feed: pictures)
                }
                
                                onComplete()
//                if !self.feedsHasBeenSucceeded { onComplete() }
            }).store(in: &cancellables)
    }
    
    internal func bookFeed(idBook: String, onComplete: @escaping () -> Void) {
        getBookById(idBook)
            .assertNoFailure()
            .sink(receiveValue: { [self] book in
                userResource = book
                quotesUiState.value.state = .Success(feed: book.quotes.reduce(into: [UserQuote]()) { result, quote in
                    let final = quote
                    final.followableTopics.removeAll(where: { followableTopic in
                        followableTopic.topic.kind == .century ||
                        followableTopic.topic.kind == .movement ||
                        followableTopic.topic.kind == .book
                    })
                    result.append(final)
                })
                
                if let biography = book.presentation {
                    biographyUiState.value.state = .Success(feed: biography)
                }
                
                if let pictures = book.pictures {
                    picturesUiState.value.state = .Success(feed: pictures)
                }
                
                                onComplete()
//                if !self.feedsHasBeenSucceeded { onComplete() }
            }).store(in: &cancellables)
    }
    
    internal func faithFeed(idFaith: String, onComplete: @escaping () -> Void) {
        getFaithById(idFaith)
            .assertNoFailure()
            .sink(receiveValue: { [self] faith in
                userResource = faith
                var quotes: [UserQuote] = []
                
                if faith.authors != nil || faith.books != nil {
                    if let authors = faith.authors {
                        for author in authors {
                            quotes.append(contentsOf: author.quotes)
                        }
                    }
                    
                    if let books = faith.books {
                        for book in books {
                            quotes.append(contentsOf: book.quotes)
                        }
                    }
                }
                
                quotesUiState.value.state = .Success(feed: quotes.reduce(into: [UserQuote]()) { result, quote in
                    let final = quote
                    final.followableTopics.removeAll(where: { followableTopic in
                        followableTopic.topic.kind == .century ||
                        followableTopic.topic.kind == .movement
                    })
                    result.append(final)
                })
                
                if let biography = faith.presentation {
                    biographyUiState.value.state = .Success(feed: biography)
                }
                
                if let pictures = faith.pictures {
                    picturesUiState.value.state = .Success(feed: pictures)
                }
                
                onComplete()
//                if !self.feedsHasBeenSucceeded { onComplete() }
            }).store(in: &cancellables)
    }
    
    internal func themeFeed(idTheme: String, onComplete: @escaping () -> Void) {
        getThemeById(idTheme)
            .assertNoFailure()
            .sink(receiveValue: { [self] theme in
                userResource = theme
                quotesUiState.value.state = .Success(feed: theme.quotes.reduce(into: [UserQuote]()) { result, quote in
                    let final = quote
                    final.followableTopics.removeAll(where: { followableTopic in
                        followableTopic.topic.kind == .century ||
                        followableTopic.topic.kind == .theme
                    })
                    result.append(final)
                })
                
                if let pictures = theme.pictures {
                    picturesUiState.value.state = .Success(feed: pictures)
                }
                
                onComplete()
//                if !self.feedsHasBeenSucceeded { onComplete() }
            }).store(in: &cancellables)
    }
}
