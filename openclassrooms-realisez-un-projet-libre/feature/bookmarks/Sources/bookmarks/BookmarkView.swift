//
//  BookmarkView.swift
//  bookmarks
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

///
/// Structure representing the View for the bookmarks screen
///
public struct BookmarkView: View, OlaTab {
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.geometry) private var geometry
    @Environment(\.orientation) private var orientation
    
    @ObservedObject var viewModel: BookmarksViewModel = BookmarksViewModel.shared
    @ObservedObject fileprivate var bookmarkPage: BookmarkPage
    @ObservedObject fileprivate var frame: Frame
    @ObservedObject private var proxy: Proxy
    
    @State var tmpSize: CGSize = .zero
    
    public static let title: String = "bookmarks".localizedString(identifier: Locale.current.identifier, bundle: Bundle.bookmarks)
    private let coordinator: BookmarkCoordinator
    
    var tabView: BookmarkPageViewController {
        BookmarkPageViewController(
            frame: frame,
            bookmarkPage: bookmarkPage,
            bookmarkCoordinator: coordinator)
    }
    
    public init(frame: Frame, proxy: Proxy) {
        self.frame = frame
        self.bookmarkPage = BookmarkPage(
            currentIndex: 0,
            previousIndex: 0,
            pages: [Page(title: "bookmarks", view: BookmarkViews.bookmarks)])
        self.coordinator = BookmarkCoordinator()
        self.proxy = proxy
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            tabView.frame(
                    minWidth: UIScreen.main.bounds.width,
                    maxWidth: UIScreen.main.bounds.width,
                    minHeight: bookmarkPage.pages[bookmarkPage.index.currentIndex].frame.bounds.height,
                    maxHeight: .infinity,
                    alignment: .top)
                .overlay(
                    GeometryReader { _ -> Color in
                        if let proxy = self.proxy.value {
                            if bookmarkPage.pages[bookmarkPage.index.currentIndex].frame.bounds.size != .zero &&
                                bookmarkPage.pages[bookmarkPage.index.currentIndex].frame.bounds.size.width == UIScreen.main.bounds.width &&
                                bookmarkPage.pages[bookmarkPage.index.currentIndex].frame.bounds.size.height < geometry.bounds.height - geometry.safeAreaInsets.top - tabRowHeight - proxy.frame(in: .named("vstack")).minY - (orientation.isPortrait ? (!isTablet ? geometry.safeAreaInsets.bottom : 0.0) : 0.0) {
                                
                                bookmarkPage.pages[bookmarkPage.index.currentIndex].frame.bounds.size =
                                CGSize(width: geometry.bounds.width,
                                       height: geometry.bounds.height - geometry.safeAreaInsets.top - tabRowHeight - proxy.frame(in: .named("vstack")).minY - (orientation.isPortrait ? (!isTablet ? geometry.safeAreaInsets.bottom : 0.0) : 0.0))
                                
                                self.frame.bounds.size = CGSize(
                                    width: geometry.bounds.width,
                                    height: tabRowHeight + bookmarkPage.pages[bookmarkPage.index.currentIndex].frame.bounds.size.height)
                                
                                self.frame.objectWillChange.send()
                            }
                        }
                        
                        return Color.clear
                    })
                .edgesIgnoringSafeArea(.horizontal)
                .onChange(of: viewModel.user.providerID) { providerId in
                    if providerId.isEmpty {
                        bookmarkPage.pages.removeAll(where: { $0.title == "resources" })
                        coordinator.coordinator!.viewControllers.removeAll(where: { $0.title == "resources" })
                        bookmarkPage.index = (currentIndex: 0, previousIndex: 0)
                    }
                }
        }
        .frame(
            minWidth: UIScreen.main.bounds.width,
            maxWidth: UIScreen.main.bounds.width,
            minHeight: bookmarkPage.pages[bookmarkPage.index.currentIndex].frame.bounds.height,
            maxHeight: .infinity,
            alignment: .top)
        .edgesIgnoringSafeArea(.all)
    }
}
