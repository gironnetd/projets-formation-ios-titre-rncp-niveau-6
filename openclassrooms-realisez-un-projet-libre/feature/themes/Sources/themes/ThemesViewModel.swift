//
//  ThemesViewModel.swift
//  themes
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import domain
import model
import remote
import data
import Combine
import Factory

///
/// ObservableObject representing the viewmodel for themes package
///
internal class ThemesViewModel: ObservableObject {
   
    @LazyInjected(\.getThemesUseCase) var getThemes
    @LazyInjected(\.getThemeByIdUseCase) var getThemeById
    
    internal var themesUiState: ThemesState = .Loading
    
    var cancellables: Set<AnyCancellable> = Set()
    
    init() { }
    
    init(themeRepository: ThemeRepository) {
        self.getThemes = GetThemesUseCase(themeRepository: themeRepository)
    }
    
    internal func feeds() {
        getThemes().assertNoFailure().sink(receiveValue: { themes in
            self.themesUiState = .Success(feed: themes)
            self.objectWillChange.send()
        }).store(in: &cancellables)
    }
}

internal enum ThemesState {
    case Loading
    case Success(feed: [UserTheme])
}
