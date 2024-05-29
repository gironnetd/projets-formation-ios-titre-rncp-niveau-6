//
//  AuthorsScreen.swift
//  authors
//
//  Created by Damien Gironnet on 05/04/2023.
//

import Foundation
import SwiftUI
import common
import designsystem
import ui
import domain

///
/// Structure representing the View for the authors screen
///
public struct AuthorsView: View, OlaTab {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.geometry) private var geometry
    @Environment(\.orientation) private var orientation

    @ObservedObject public var filterTab: FilterTab
    @ObservedObject public var viewModel: AuthorsViewModel
    @ObservedObject private var authorPage: AuthorPage
    @ObservedObject var frame: Frame
    @ObservedObject var pageController: PageViewController
    @ObservedObject private var proxy: Proxy
    
    private let coordinator: AuthorCoordinator
    public static let title: String = "authors".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
    
    @Namespace public var menuItemTransition
        
    private let titles: [String] = [
        "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem),
        "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem),
        "all".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)]
    
    public init(frame: Frame, proxy: Proxy) {
        self.frame = frame
        self.filterTab = FilterTab(titles: titles.map { ($0, false, nil) })
        self.viewModel = AuthorsViewModel()
        self.authorPage = AuthorPage(
            currentIndex: 2,
            previousIndex: 2,
            pages: AuthorViews.allCases.filter { $0 != .authors }
                .map { Page(title: $0.rawValue, view: $0) })
        self.coordinator = AuthorCoordinator()
        self.frame = frame
        self.proxy = proxy
        self.pageController = PageViewController()
    }
    
    var tab: OlaTabRow<some View> {
        OlaTabRow(
            fixed: false,
            geometryWidth: (geometry.bounds.size.width - (isTablet ? CGFloat(72.0) : 0.0)),
            selectedTabIndex: $authorPage.index.currentIndex,
            tabs: filterTab.titles.map { $0.title }.enumerated().map { (index, title) in
                OlaTabRowItem(
                    selected: authorPage.index.currentIndex == index,
                    onClick: { authorPage.index.currentIndex = index },
                    content: {
                        AuthorsTab(
                            index: index,
                            selectedTabIndex: $authorPage.index.currentIndex,
                            isActive: (title == filterTab.titles[0].title && filterTab.titles[0].isActive) ||
                            (title == filterTab.titles[1].title && filterTab.titles[1].isActive),
                            title: title,
                            selectedBackgroundColor: (titles.contains(title) ? (colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary10) : (colorScheme == .light ? localColorScheme.Primary80 : localColorScheme.Primary20)),
                            namespace: menuItemTransition)
                    })
            })
    }
    
    var tabView: some View {
        AuthorPageViewController(
            authorPage: authorPage,
            pageView: pageController,
            frame: frame,
            filterTab: filterTab,
            authorCoordinator: coordinator,
            viewModel: viewModel)
    }
        
    public var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            tab.fixedSize(horizontal: filterTab.titles.count == 3, vertical: true)
               .frame(height: tabRowHeight)
                
            tabView
                .frame(
                    minWidth: UIScreen.main.bounds.width,
                    maxWidth: UIScreen.main.bounds.width,
                    minHeight: authorPage.pages[authorPage.index.currentIndex].frame.bounds.height,
                    maxHeight: .infinity,
                    alignment: .top)
                .overlay(
                    GeometryReader { _ -> Color in
                        if let proxy = self.proxy.value {
                            if authorPage.pages[authorPage.index.currentIndex].frame.bounds.size != .zero &&
                                authorPage.pages[authorPage.index.currentIndex].frame.bounds.size.width == UIScreen.main.bounds.width &&
                                authorPage.pages[authorPage.index.currentIndex].frame.bounds.size.height < geometry.bounds.height - geometry.safeAreaInsets.top - tabRowHeight * 2 - proxy.frame(in: .named("vstack")).minY - (orientation.isPortrait ? (!isTablet ? geometry.safeAreaInsets.bottom : 0.0) : 0.0) {
                                
                                authorPage.pages[authorPage.index.currentIndex].frame.bounds.size =
                                CGSize(width: geometry.bounds.width,
                                       height: geometry.bounds.height - geometry.safeAreaInsets.top - tabRowHeight * 2 - proxy.frame(in: .named("vstack")).minY - (orientation.isPortrait ? (!isTablet ? geometry.safeAreaInsets.bottom : 0.0) : 0.0))
                                
                                self.frame.bounds.size = CGSize(
                                    width: geometry.bounds.width,
                                    height: tabRowHeight + authorPage.pages[authorPage.index.currentIndex].frame.bounds.size.height)
                                
                                self.frame.objectWillChange.send()
                            }
                        }
                        
                        return Color.clear
                    })
            .edgesIgnoringSafeArea(.all)
        }
        .frame(
            minWidth: UIScreen.main.bounds.width,
            maxWidth: UIScreen.main.bounds.width,
            minHeight: tabRowHeight + authorPage.pages[authorPage.index.currentIndex].frame.bounds.height,
            maxHeight: .infinity,
            alignment: .top)
        .edgesIgnoringSafeArea(.all)
    }
}

internal struct AuthorsView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometryProxy in
            let proxy = Proxy()
            let _ = proxy.value = geometryProxy
            OlaTheme(darkTheme: .systemDefault) {
                AuthorsView(frame: Frame(bounds: UIScreen.main.bounds), proxy: proxy)
                    .OlaBackground()
            }
        }
        .preferredColorScheme(.light)
        .environment(\.locale, .init(identifier: "fr"))
    }
}
