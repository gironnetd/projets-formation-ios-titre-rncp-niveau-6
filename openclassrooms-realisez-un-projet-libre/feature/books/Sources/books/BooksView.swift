//
//  BooksView.swift
//  books
//
//  Created by Damien Gironnet on 05/04/2023.
//

import Foundation
import SwiftUI
import common
import designsystem
import ui
import Factory
import domain

///
/// Structure representing the View for the books screen
///
public struct BooksView: View, OlaTab {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.geometry) private var geometry
    @Environment(\.orientation) private var orientation

    @ObservedObject internal var filterTab: FilterTab
    @ObservedObject internal var viewModel: BooksViewModel
    @ObservedObject private var bookPage: BookPage
    @ObservedObject var frame: Frame
    @ObservedObject var pageController: PageViewController
    @ObservedObject private var proxy: Proxy

    private let coordinator: BookCoordinator
    
    public static let title: String = "books".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
    
    @Namespace public var menuItemTransition
    
    private let titles: [String] = [
        "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem),
        "all".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)]
    
    public init(frame: Frame, proxy: Proxy) {
        self.filterTab = FilterTab(titles: titles.map { ($0, false, nil) })
        self.viewModel = BooksViewModel()
        self.bookPage = BookPage(
            currentIndex: 1,
            previousIndex: 1,
            pages: BookViews.allCases.filter { $0 != .books }
                .map { Page(title: $0.rawValue, view: $0) })
        self.frame = frame
        self.proxy = proxy
        self.coordinator = BookCoordinator()
        self.pageController = PageViewController()
    }
    
    var tabView: some View {
        BookPageViewController(
            bookPage: bookPage,
            pageView: pageController,
            frame: frame,
            filterTab: filterTab,
            bookCoordinator: coordinator,
            viewModel: viewModel)
    }
        
    var tab: OlaTabRow<some View> {
        OlaTabRow(
            fixed: false,
            geometryWidth: (geometry.bounds.size.width - (isTablet ? CGFloat(72.0) : 0.0)),
            selectedTabIndex: $bookPage.index.currentIndex,
            tabs: filterTab.titles.map { $0.title }.enumerated().map { (index, title) in
                OlaTabRowItem(
                    selected: bookPage.index.currentIndex == index,
                    onClick: { bookPage.index.currentIndex = index },
                    content: {
                        BooksTab(
                            index: index,
                            selectedTabIndex: $bookPage.index.currentIndex,
                            isActive: (title == filterTab.titles[0].title && filterTab.titles[0].isActive),
                            title: title,
                            selectedBackgroundColor: (titles.contains(title) ? (colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary10) : (colorScheme == .light ? localColorScheme.Primary80 : localColorScheme.Primary20)),
                            namespace: menuItemTransition)
                    })
            })
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            tab.fixedSize(horizontal: filterTab.titles.count == 2, vertical: true)
               .frame(height: tabRowHeight)
            
            tabView
                .frame(
                    minWidth: UIScreen.main.bounds.width,
                    maxWidth: UIScreen.main.bounds.width,
                    minHeight: bookPage.pages[bookPage.index.currentIndex].frame.bounds.height,
                    maxHeight: .infinity,
                    alignment: .top)
                .overlay(
                    GeometryReader { _ -> Color in
                        if let proxy = self.proxy.value {
                            if bookPage.pages[bookPage.index.currentIndex].frame.bounds.size != .zero &&
                                bookPage.pages[bookPage.index.currentIndex].frame.bounds.size.width == UIScreen.main.bounds.width &&
                                bookPage.pages[bookPage.index.currentIndex].frame.bounds.size.height < geometry.bounds.height - geometry.safeAreaInsets.top - tabRowHeight * 2 - proxy.frame(in: .named("vstack")).minY - (orientation.isPortrait ? (!isTablet ? geometry.safeAreaInsets.bottom: geometry.safeAreaInsets.bottom) : 0.0) {
                                
                                bookPage.pages[bookPage.index.currentIndex].frame.bounds.size =
                                CGSize(width: geometry.bounds.width,
                                       height: geometry.bounds.height - geometry.safeAreaInsets.top - tabRowHeight * 2 - proxy.frame(in: .named("vstack")).minY - (orientation.isPortrait ? (!isTablet ? geometry.safeAreaInsets.bottom : geometry.safeAreaInsets.bottom) : 0.0))
                                
                                self.frame.bounds.size = CGSize(
                                    width: geometry.bounds.width,
                                    height: tabRowHeight + bookPage.pages[bookPage.index.currentIndex].frame.bounds.size.height)
                                
                                self.frame.objectWillChange.send()
                            }
                        }
                        
                        return Color.clear
                    })
                .edgesIgnoringSafeArea(.horizontal)
        }
        .frame(
            minWidth: UIScreen.main.bounds.width,
            maxWidth: UIScreen.main.bounds.width,
            minHeight: tabRowHeight + bookPage.pages[bookPage.index.currentIndex].frame.bounds.height,
            maxHeight: .infinity,
            alignment: .top)
        .edgesIgnoringSafeArea(.all)
    }
}
