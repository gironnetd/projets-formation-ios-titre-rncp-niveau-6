//
//  OlaApplication.swift
//  mobile
//
//  Created by damien on 06/12/2022.
//

import SwiftUI
import authentication
import designsystem
import navigation
import common
import model
import data
import RealmSwift
import cache
import ui
import main
import content
import domain
import bookmarks
import work
import remote
import Factory
import Combine

struct OlaApplication: View {
    
    @EnvironmentObject private var mainRouter: MainRouter
    @EnvironmentObject private var orientation: Orientation
    
    @Environment(\.geometry) private var geometry
    
    internal var user: model.User!
    
    var cancellables: Set<AnyCancellable> = Set()
    
    @ObservedObject private var viewModel: MainViewModel = MainViewModel()
    
    private let authenticationView: AuthenticationView = AuthenticationView()
    private var mainView: MainView = MainView()
    
    private class ContentViews { var views: [(topic: FollowableTopic, view: ContentView)] = [] }
    
    private let contentViews: ContentViews = ContentViews()
    private let loadingWheel: OlaLoadingWheel = OlaLoadingWheel()
    
    public init() { LoadingWheel.isShowing(true) }
    
    var body: some View {
        ZStack(alignment: .top) {
            switch mainRouter.visibleScreen {
            case .splash:
                dove.frame(alignment: .top)
                    .padding(.top, orientation.current.isPortrait || isTablet ? geometry.safeAreaInsets.top : 16.0)
            case .main:
                mainView
            case .content(let followableTopic, _):
                if contentViews.views.contains(where: { $0.topic == followableTopic }) {
                    if let index = contentViews.views.firstIndex(where: { $0.topic == followableTopic }) {
                        contentViews.views[index].view
                    }
                } else {
                    let view = ContentView(followableTopic: followableTopic)
                    
                    view.onAppear {
                        contentViews.views.append((followableTopic, view))
                    }
                }
            }
            
            loadingWheel
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        }
        .onChange(of: viewModel.user.providerID) { providerId in
            if providerId.isEmpty { contentViews.views.removeAll() }
        }.frame(width: UIScreen.main.bounds.width)
    }
}
