//
//  ThemesView.swift
//  themes
//
//  Created by Damien Gironnet on 05/04/2023.
//

import Foundation
import SwiftUI
import common
import designsystem
import ui
import model
import navigation
import Factory
import domain

///
/// Structure representing the View for the themes screen
///
public struct ThemesView: View, OlaTab {
    
    @Injected(\.mainRouter) var mainRouter
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var viewModel: ThemesViewModel
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    @State var tmpSize: CGSize = .zero
    
    private let frame: Frame
    
    public static let title: String = "themes".localizedString(identifier: Locale.current.identifier, bundle: Bundle.themes)
            
    public init(frame: Frame) {
        self.frame = frame
        self.viewModel = ThemesViewModel()
    }
    
    var themeCard: (UserTheme, @escaping (FollowableTopic) -> Void) -> ThemeCard = { mainTheme, onThemeClick in
        ThemeCard(userTheme: mainTheme, onThemeClick: onThemeClick)
    }
        
    public var body: some View {
        let themesState = viewModel.themesUiState
        
        if case .Loading = themesState {
            Color.clear.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.feeds()
                }
            }
        }
        
        if case .Success(let feed) = themesState {
            if isTablet || orientation.isLandscape {
                VerticalStaggeredGrid<[UserTheme], ThemeCard>(
                    columns: Columns(
                        columns: feed.map { theme in
                            ColumnElement(
                                uid: theme.uid,
                                content:
                                    themeCard(theme, { followableTopic in
                                        Task {
                                            LoadingWheel.isShowing(true)
                                            
                                            mainRouter.visibleScreen = .splash

                                            DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
                                                self.mainRouter.visibleScreen = .content(followableTopic: followableTopic, returnToPrevious: false)
                                            }
                                        }
                                    })) },
                        numberOfColumns: isTablet && orientation.isLandscape ? 3 : 2),
                    computationTimes: 1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading,
                         isTablet ? Offset.shared.value :
                            (orientation.isPortrait ?
                             (geometry.safeAreaInsets.leading) : 12.0))
                .padding(.trailing, 48.0)
                .padding(.bottom, isTablet ? 0.0 : 16)
                .padding(.top, 20)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) { value in
                    guard value.width != 0 && value.height != 0 else { return }
                    tmpSize = value
                    
                    DispatchQueue.main.async {
                        if tmpSize == value && frame.bounds.size != value {
                            frame.bounds.size = value
                            frame.objectWillChange.send()
                            if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                        }
                    }
                }
            } else {
                LazyVStack(spacing: .zero) {
                    ForEach(feed.indices, id:\.self) { index in
                        themeCard(feed[index], { followableTopic in
                            Task {
                                LoadingWheel.isShowing(true)
                                
                                mainRouter.visibleScreen = .splash

                                DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
                                    self.mainRouter.visibleScreen = .content(followableTopic: followableTopic, returnToPrevious: false)
                                }
                            }
                        })
                    }
                }
                .padding(.leading,
                         isTablet ? Offset.shared.value :
                            (orientation.isPortrait ?
                             (geometry.safeAreaInsets.leading) : Offset.shared.value))
                .padding(.trailing, geometry.safeAreaInsets.trailing)
                .padding(.top, 20)
                .frame(width: UIScreen.main.bounds.width)
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) { value in
                    guard value.width != 0 && value.height != 0 else { return }
                    tmpSize = value
                    
                    DispatchQueue.main.async {
                        if tmpSize == value && frame.bounds.size != value {
                            if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                            frame.bounds.size = value
                            frame.objectWillChange.send()
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
