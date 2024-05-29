//
//  ForyouViewModel.swift
//  foryou
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import SwiftUI
import domain
import model
import remote
import Combine
import Factory
import ui
import cache
import data
import preferences
import navigation
import designsystem

///
/// ObservableObject representing the viewmodel for foryou package
///
internal class ForyouViewModel: ObservableObject {
    
    @LazyInjected(\.mainRouter) var mainRouter
    @LazyInjected(\.getForyouQuotesUseCase) private var getForyouQuotes
    @LazyInjected(\.getForyouPicturesUseCase) private var getForyouPictures
    @LazyInjected(\.getForyouBiographiesUseCase) private var getForyouBiographies
    @LazyInjected(\.getAuthorByIdUseCase) var getAuthorById
    @LazyInjected(\.getBookByIdUseCase) var getBookById
    @LazyInjected(\.getFaithByIdUseCase) var getFaithById
    @LazyInjected(\.getThemeByIdUseCase) var getThemeById
    @LazyInjected(\.olaPreferences) private var olaPreferences
    
    @Published internal var quotesUiState: CurrentValueSubject<QuotesUiState, Error> = CurrentValueSubject(.init(state: .Loading))
    @Published internal var picturesUiState: CurrentValueSubject<PicturesUiState, Error> = CurrentValueSubject(.init(state: .Loading))
    @Published internal var biographiesUiState: CurrentValueSubject<BiographiesUiState, Error> = CurrentValueSubject(.init(state: .Loading))
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    internal init() { updateForyou() }
    
    public func updateForyou() {
        getForyouQuotes().assertNoFailure().sink(receiveValue: { quotes in
            self.quotesUiState.value.state = .Success(feed: quotes)
            self.objectWillChange.send()
        }).store(in: &cancellables)

        getForyouPictures().assertNoFailure().sink(receiveValue: { pictures in
            self.picturesUiState.value.state = .Success(feed: pictures)
            self.objectWillChange.send()
        }).store(in: &cancellables)
//            .map { .Success(feed: $0) }.assign(to: &picturesUiState.$state)
        getForyouBiographies().assertNoFailure().sink(receiveValue: { biographies in
            self.biographiesUiState.value.state = .Success(feed: biographies)
            self.objectWillChange.send()
        }).store(in: &cancellables)
//            .map { .Success(feed: $0) }.assign(to: &biographiesUiState.$state)
    }
    
    public init(quoteRepository: QuoteRepository,
                pictureRepository: PictureRepository,
                presentationRepository: PresentationRepository) {
        self.getForyouQuotes = GetForyouQuotesUseCase(quoteRepository: quoteRepository)
        self.getForyouPictures = GetForyouPicturesUseCase(pictureRepository: pictureRepository)
        self.getForyouBiographies = GetForyouBiographiesUseCase(presentationRepository: presentationRepository)
    }
    
    internal func onToggleBookmark(resource: UserResource) -> Void {
        SheetUiState.shared.currentSheet = SheetView.bookmarks(resource)
    }
    
    internal func onTopicClick(followableTopic: FollowableTopic) -> Void {
        LoadingWheel.isShowing(true)
        
        withAnimation {
            mainRouter.visibleScreen = .splash
            
            DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
                self.mainRouter.visibleScreen = .content(followableTopic: followableTopic, returnToPrevious: false)
            }
        }
    }
    
    public func hasDateChanged() {
        if olaPreferences.hasDateChanged {
            olaPreferences.updateDate()
        }
    }
}

