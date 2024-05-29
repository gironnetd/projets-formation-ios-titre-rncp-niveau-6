//
//  FaithsView.swift
//  faiths
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
/// Structure representing the View for the faiths screen
///
public struct FaithsView: View, OlaTab {
    
    @Injected(\.mainRouter) var mainRouter
    
    @ObservedObject private var viewModel: FaithsViewModel
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.locale) private var locale
    
    @State var tmpSize: CGSize = .zero
    
    private let frame: Frame
    
    public static let title: String = "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.faiths)
            
    public init(frame: Frame) {
        self.frame = frame
        self.viewModel = FaithsViewModel()
    }
    
    var faithCard: (UserFaith, @escaping (FollowableTopic) -> Void) -> FaithCard = { userFaith, onFaithClick in
        FaithCard(userFaith: userFaith, onFaithClick: onFaithClick)
    }
    
    public var body: some View {
        let faithsState = viewModel.faithsUiState
        
        if case .Loading = faithsState {
            Color.clear.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.feeds()
                }
            }
        }
        
        if case .Success(let feed) = faithsState {
            if isTablet || orientation.isLandscape {
                VerticalStaggeredGrid<[UserFaith], FaithCard>(
                    columns: Columns(
                        columns: feed.map { faith in
                            ColumnElement(
                                uid: faith.uid,
                                content:
                                    faithCard(faith, { followableTopic in
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
                            (orientation.isPortrait ? (geometry.safeAreaInsets.leading) : 12.0))
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
                        faithCard(feed[index], { followableTopic in
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
                            frame.bounds.size = value
                            frame.objectWillChange.send()
                            if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
