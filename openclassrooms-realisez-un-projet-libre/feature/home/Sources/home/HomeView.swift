//
//  HomeView.swift
//  home
//
//  Created by Damien Gironnet on 05/04/2023.
//

import Foundation
import SwiftUI
import common
import designsystem
import foryou
import authors
import faiths
import themes
import books
import ui
import model

///
/// Structure representing the View for the home screen
///
public struct HomeView: View, OlaTab {
    
    @Environment(\.geometry) private var geometry
    @Environment(\.orientation) private var orientation
    
    @ObservedObject private var homePage: HomePage
    @ObservedObject var frame: Frame
    @ObservedObject private var proxy: Proxy

    public static let title: String = "home".localizedString(identifier: Locale.current.identifier, bundle: Bundle.home)
    
    @State private var titles: [String] = [ForyouView.title, AuthorsView.title, BooksView.title, FaithsView.title, ThemesView.title]

    private let coordinator: HomeCoordinator

    @Namespace private var menuItemTransition
    
    public init(frame: Frame, proxy: Proxy) {
        self.homePage = HomePage(
            currentIndex: 0,
            previousIndex: 0,
            pages: HomeViews.allCases.map { Page(title: $0.rawValue, view: $0) })
        self.coordinator = HomeCoordinator()
        self.frame = frame
        self.proxy = proxy
    }
    
    var tabView: some View {
        HomePageViewController(
            homePage: homePage,
            frame: frame,
            proxy: proxy,
            homeCoordinator: coordinator)
    }
    
    var tabBar: some View {
        OlaTabRow(
            fixed: (isTablet) ? true : false,
            centerAnchor: true,
            geometryWidth: UIScreen.main.bounds.width,
            selectedTabIndex: $homePage.index.currentIndex,
            tabs: titles.enumerated().map { (index, title) in
                OlaTabRowItem(
                    selected: homePage.index.currentIndex == index,
                    onClick: { homePage.index.currentIndex = index },
                    content: {
                        HomeTab(index: index,
                                selectedTabIndex: $homePage.index.currentIndex,
                                title: title,
                                namespace: menuItemTransition)
                                .offset(x: geometry.safeAreaInsets.leading)
                                .padding(.trailing, index == titles.endIndex - 1 ? geometry.safeAreaInsets.trailing * 2 : 0.0)
                    })
            })
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            tabBar.frame(height: tabRowHeight).zIndex(1)
            
            tabView
                .frame(
                    minWidth: UIScreen.main.bounds.width,
                    maxWidth: UIScreen.main.bounds.width,
                    minHeight: homePage.pages[homePage.index.currentIndex].frame.bounds.height,
                    maxHeight: .infinity,
                    alignment: .top)
            .edgesIgnoringSafeArea(.horizontal)
        }
        .frame(
            minWidth: UIScreen.main.bounds.width,
            maxWidth: UIScreen.main.bounds.width,
            minHeight: homePage.pages[homePage.index.currentIndex].frame.bounds.height,
            maxHeight: .infinity,
            alignment: .top)
        .edgesIgnoringSafeArea(.all)
    }
}
