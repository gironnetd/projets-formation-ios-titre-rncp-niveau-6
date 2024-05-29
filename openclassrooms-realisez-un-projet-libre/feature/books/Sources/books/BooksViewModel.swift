//
//  BooksViewModel.swift
//  books
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import SwiftUI
import domain
import model
import remote
import Combine
import ui
import data
import Factory
import navigation

///
/// ObservableObject representing the viewmodel for books package
///
internal class BooksViewModel: ObservableObject {
    
    @LazyInjected(\.mainRouter) var mainRouter
    @LazyInjected(\.getBooksUseCase) var getBooks
    @LazyInjected(\.getBookByIdUseCase) var getBookById
    @LazyInjected(\.getFaithsUseCase) var getFaiths
    
    @Published internal var booksUiState: BooksUiState = BooksUiState(state: .Loading)
    @Published internal var faithsUiState: FaithsUiState = FaithsUiState(state: .Loading)
    @Published internal var booksFeedUiState: BooksFeedUiState = .Loading
    
    internal init() {}
    
    init(bookRepository: BookRepository, movementRepository: MovementRepository) {
        self.getBooks = GetBooksUseCase(bookRepository: bookRepository)
        self.getBookById = GetBookByIdUseCase(bookRepository: bookRepository)
        self.getFaiths = GetFaithsUseCase(movementRepository: movementRepository)
    }
    
    internal func navigate(to followableTopic: FollowableTopic) {
        mainRouter.visibleScreen = .splash

        DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
            self.mainRouter.visibleScreen = .content(followableTopic: followableTopic, returnToPrevious: false)
        }
    }
    
    internal func feeds(onComplete: @escaping () -> Void) {
        Task {
            Publishers.Zip(getBooks().assertNoFailure(), getFaiths().assertNoFailure())
            .sink(receiveValue: { books, faiths in
                var mainFaiths = faiths.compactMap { $0.movements.flatMap { $0 } }.flatMap { $0 }
                let subFaiths = mainFaiths.compactMap { $0.movements.flatMap { $0 } }.flatMap { $0 }
                
                for subFaith in subFaiths {
                    if mainFaiths.map({ $0.name }).contains(subFaith.name) {
                        if let index = mainFaiths.firstIndex(where: { $0.name == subFaith.name }) {
                            mainFaiths.remove(at: index)
                        }
                    }
                }
                
                self.booksFeedUiState = .Success(feed: (books: books,
                    faiths: (mainFaiths + subFaiths).filter({ $0.books != nil })))
                
                onComplete()
            })
        }
    }
}

public class BooksUiState: ObservableObject {
    @Published public var state: BooksState

    public init(state: BooksState) {
        self.state = state
    }
}

public enum BooksState {
    case Loading
    case InProgress
    case Success(feed: [UserBook])
}

internal enum BooksFeedUiState {
    case Loading
    case InProgress
    case Success(feed: (books: [UserBook], faiths: [UserFaith]))
}
