//
//  BookmarksViewModel.swift
//  bookmarks
//
//  Created by Damien Gironnet on 16/10/2023.
//

import Foundation
import SwiftUI
import data
import Factory
import model
import Combine
import ui
import designsystem
import navigation
import domain

public class BookmarksViewModel: ObservableObject {
    
    @LazyInjected(\.mainRouter) var mainRouter
    @LazyInjected(\.quoteRepository) var quoteRepository
    @LazyInjected(\.pictureRepository) var pictureRepository
    @LazyInjected(\.presentationRepository) var biographyRepository
    @LazyInjected(\.userRepository) var userRepository
    @LazyInjected(\.userDataRepository) var userDataRepository
    @LazyInjected(\.bookmarkRepository) var bookmarkRepository
    @LazyInjected(\.getBookmarksUseCase) var getBookmarks
    
    @Published internal var user: model.User!
    @Published var bookmarksUiState: BookmarkGroupsUiState = .init(state: .Loading)
    @Published var resourcesUiState: BookmarkedUserResourcesUiState = .init(state: .Loading)
    @Published var quotesUiState: BookmarkedQuotesUiState = .init(state: .Loading)
    @Published var picturesUiState: BookmarkedPicturesUiState = .init(state: .Loading)
    @Published var biographiesUiState: BookmarkedBiographiesUiState = .init(state: .Loading)
    
    public static let shared: BookmarksViewModel = BookmarksViewModel()
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    private init() {
        userRepository.user.assertNoFailure().sink { [self] in user = $0 }.store(in: &cancellables)
        bookmarksUiState.objectWillChange.sink { (_) in self.objectWillChange.send() }.store(in: &cancellables)
        updateBookmarkGroups()
    }
    
    func updateBookmarkGroups() {
        bookmarkRepository.findAllBookmarkGroups().map { groups in
            .Success(feed: groups)
        }.assertNoFailure().assign(to: &bookmarksUiState.$state)
    }
    
    func bookmarksFeed(group: BookmarkGroup) {
        getBookmarks(group.bookmarks).map { resources in
            var orderedResources: [BookmarkableUserResource] = []
            
            for bookmark in group.bookmarks.sorted(by: { $0.dateCreation < $1.dateCreation}) {
                switch bookmark.kind {
                case .quote:
                    if let quote = resources.first(where: { $0.id == bookmark.idResource }),
                       let bookmark = group.bookmarks.first(where: { $0.idResource == quote.id }) {
                        orderedResources.append(
                            BookmarkableUserResource(
                                resource: quote,
                                bookmark: bookmark))
                    }
                case .picture:
                    if let picture = resources.first(where: { $0.id == bookmark.idResource }),
                       let bookmark = group.bookmarks.first(where: { $0.idResource == picture.id }) {
                        orderedResources.append(
                            BookmarkableUserResource(
                                resource: picture,
                                bookmark: bookmark))
                    }
                case .biography:
                    if let presentation = resources.first(where: { $0.id == bookmark.idResource }),
                       let bookmark = group.bookmarks.first(where: { $0.idResource == presentation.id }) {
                        orderedResources.append(
                            BookmarkableUserResource(
                                resource: presentation,
                                bookmark: bookmark))
                    }
                default:
                    break
                }
            }
            
            return .Success(feed: orderedResources.reversed())
        }
        .assertNoFailure()
        .assign(to: &resourcesUiState.$state)
    }
    
    internal func onToggleBookmark(resource: UserResource) -> Void { SheetUiState.shared.currentSheet = .bookmarks(resource) }
    
    internal func onTopicClick(followableTopic: FollowableTopic) -> Void {
        LoadingWheel.isShowing(true)
        
        withAnimation {
            mainRouter.visibleScreen = .splash
            
            DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
                self.mainRouter.visibleScreen = .content(followableTopic: followableTopic, returnToPrevious: false)
            }
        }
    }
    
    internal func updateUserResourceBookmarked(bookmark: Bookmark, bookmarked: Bool) {
        Task {
            try await bookmarkRepository.updateResourceBookmarked(bookmark: bookmark, bookmarked: bookmarked)
        }
    }
    
    internal func createOrUpdate(group: BookmarkGroup) async throws {
        try await bookmarkRepository.createOrUpdate(group: group)
        try await userDataRepository.updateResourceBookmarked(idResource: group.id, bookmarked: true)
        updateBookmarkGroups()
    }
    
    internal func remove(group: BookmarkGroup) {
        Task {
            try await bookmarkRepository.remove(group: group)
            try await userDataRepository.updateResourceBookmarked(idResource: group.id, bookmarked: false)
            updateBookmarkGroups()
        }
    }
    
    internal func edit(bookmark: BookmarkGroup) { SheetUiState.shared.currentSheet = .editBookmark(bookmark) }
    
    internal func update(bookmark: Bookmark) {
        Task { try await bookmarkRepository.update(bookmark: bookmark) }
    }
}
