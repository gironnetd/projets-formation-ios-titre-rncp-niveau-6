//
//  MainView.swift
//  main
//
//  Created by damien on 12/09/2022.
//

import SwiftUI
import designsystem
import common
import home
import bookmarks
import settings
import Factory
import cache
import ui
import Combine
import navigation
import model
import authentication

///
/// Structure representing the View for the main view
///
public struct MainView: View {
    
    @Injected(\.mainRouter) var mainRouter
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @ObservedObject var sheetUiState: SheetUiState = SheetUiState.shared

    @EnvironmentObject private var orientation: Orientation
    
    @ObservedObject private var mainPage: MainPage
    @ObservedObject var frame: Frame
    
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    private let coordinator: MainCoordinator

    @State private var hideTabBar: Bool = false
    @State private var bottomTabBarSize: CGSize = .zero
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    
    private let scrollViewCoordinateSpace: String = "scrollView"
    private static var scrollViewPosition: CGFloat = 0.0
    
    private let icons: [(selectedIcon: Image, icon: Image)] = [
        (OlaIcons.HomeBorder, OlaIcons.HomeBorder),
        (OlaIcons.BookmarksBorder, OlaIcons.BookmarksBorder),
        (OlaIcons.Settings, OlaIcons.Settings)
    ]
    
    public init() {
        self.mainPage = MainPage(
            currentIndex: 0,
            previousIndex: 0,
            pages: MainViews.allCases.map { Page(title: $0.rawValue, view: $0) })
        self.coordinator = MainCoordinator()
        self.frame = Frame(bounds: UIScreen.main.bounds)
        self.proxy = Proxy()
    }
    
    var tabBar: some View {
        ZStack {
            (
                colorScheme == .light ?
                (orientation.current.isLandscape || isTablet ?
                 PaletteTokens.White.opacity(0.0).brightness(0.0) : PaletteTokens.White.brightness(0.0)) :
                (orientation.current.isLandscape || isTablet ?
                 localColorScheme.primaryContainer.opacity(0.0).brightness(-0.1) : localColorScheme.primaryContainer.brightness(-0.06))
            )
            .frame(minWidth: !isTablet && orientation.current.isPortrait ? UIScreen.main.bounds.width : nil,
                    maxWidth: !isTablet && orientation.current.isPortrait ? UIScreen.main.bounds.width : nil)

            OlaTabRow(
                fixed: true,
                isVertical: isTablet || orientation.current.isLandscape,
                geometryWidth: geometry.bounds.size.width,
                selectedTabIndex: $mainPage.index.currentIndex,
                tabs: icons.enumerated().map { (index, icons) in
                    OlaTabRowItem(
                        selected: mainPage.index.currentIndex == index,
                        onClick: { mainPage.index.currentIndex = index },
                        content: {
                            MainBottomTab(index: index,
                                          selectedTabIndex: $mainPage.index.currentIndex,
                                          selectedIcon: icons.selectedIcon,
                                          icon: icons.icon)
                        })
                })
            .padding(.top, isTablet ? 0.0 : UIScreen.inches > 4.7 ? 4.0 : 1.0)
            .padding(.bottom, isTablet ? 0.0 : (orientation.current.isPortrait ? (UIScreen.inches > 4.7 ? 24 : 12) : 0.0))
        }
        .fixedSize(horizontal: orientation.current.isLandscape ? true : true, vertical: orientation.current.isLandscape ? false : true)
        .modifier(SizeModifier())
        .onPreferenceChange(SizePreferenceKey.self) { value in
            DispatchQueue.main.async {
                guard value.width != 0 && value.height != 0 else { return }
                
                DispatchQueue.main.async { self.bottomTabBarSize = value }
            }
        }
        .edgesIgnoringSafeArea(isTablet || orientation.current.isLandscape ? .leading : [])
        .offset(y: orientation.current.isLandscape || isTablet || !hideTabBar ? 0 : bottomTabBarSize.height)
    }
    
    private let proxy: Proxy
    
    var tabView: some View {
        MainPageViewController(
            mainPage: mainPage,
            frame: frame,
            proxy: self.proxy,
            mainCoordinator: coordinator)
    }
        
    public var body: some View {
        ScrollViewReader { reader in
            ZStack(alignment: orientation.current.isLandscape || isTablet ? .leading : .bottom) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: .zero) {
                        dove.id("dove").padding(.top, orientation.current.isPortrait || isTablet ? geometry.safeAreaInsets.top : 16.0)
                            //.frame(width: 0, height: 0)
                            //.hidden()

                        tabView.frame(width: UIScreen.main.bounds.width,
                                      height: self.frame.bounds.height +
                                      (!isTablet && !orientation.current.isLandscape ? bottomTabBarSize.height : 0.0))
                        //.padding(.top, orientation.current.isPortrait || isTablet ? geometry.safeAreaInsets.top : 16.0)
                        .ignoresSafeArea()
                        .overlay(
                            GeometryReader { proxy -> Color in
                                if self.proxy.value == nil { let _ = self.proxy.value = proxy }
                                return Color.clear
                            })
                        .onAppear {
                            reader.scrollTo(
                                "vstack",
                                anchor: .init(
                                    x: 0.5,
                                    y: MainView.scrollViewPosition))
                        }
                    }
                    .id("vstack")
                    .coordinateSpace(name: "vstack")
                    .frame(width: UIScreen.main.bounds.width)
                    .overlay(
                        GeometryReader { proxy -> Color in
                            let minY = proxy.frame(in: .named(scrollViewCoordinateSpace)).minY
                            let durationOffset: CGFloat = 35

                            DispatchQueue.main.async {
                                if minY < offset {
                                    if offset < 0 && -minY > (lastOffset + durationOffset) {
                                        withAnimation(.easeOut.speed(1.5)) {
                                            hideTabBar = true
                                        }
                                        lastOffset = -offset

                                    }
                                }
                                
                                if minY > offset && -minY < (lastOffset - durationOffset) {
                                    withAnimation(.easeOut.speed(1.5)) {
                                        hideTabBar = false
                                    }
                                    lastOffset = -offset
                                }
                                
                                self.offset = minY

                                if self.frame.bounds.size != .zero && proxy.frame(in: .global).minY < geometry.safeAreaInsets.top {
                                    MainView.scrollViewPosition = abs((proxy.frame(in: .global).minY) / (proxy.frame(in: .global).height - geometry.bounds.size.height))
                                }
                            }

                            return Color.clear
                        }
                    )
                }
                .coordinateSpace(name: scrollViewCoordinateSpace)
                
                tabBar
                
                Sheet(isShowing: $sheetUiState.isShowing) {
                    switch sheetUiState.currentSheet {
                    case .authentication:
                        AuthenticationView()
                    case .bookmarks (let userResource):
                        SaveUserResourceView(userResource)
                            .frame(minHeight: isTablet || orientation.current.isPortrait ?
                                    UIScreen.main.bounds.height / 2 : UIScreen.main.bounds.height / 1.15,
                                   maxHeight: isTablet || orientation.current.isPortrait ?
                                   UIScreen.main.bounds.height / 2 : UIScreen.main.bounds.height / 1.15,
                                   alignment: .top)
                    case .createBoomark:
                        CreateOrEditBookmarkGroupView(onCompleted: {
                            withAnimation { sheetUiState.isShowing = false }
                            
                            if let previousSheet = sheetUiState.previousSheet {
                                sheetUiState.currentSheet = previousSheet
                            }
                        })
                        .frame(minHeight: UIScreen.main.bounds.height / (isTablet ? 2 : 3), alignment: .top)
                    case .editBookmark(let group):
                        CreateOrEditBookmarkGroupView(
                            group: group,
                            onCompleted: { withAnimation { sheetUiState.isShowing = false } })
                        .frame(minHeight: UIScreen.main.bounds.height / (isTablet ? 2 : 3), alignment: .top)
                    case .addOrEditNote(let bookmark):
                        AddOrEditNoteView(
                            bookmark: bookmark,
                            onCompleted: {  withAnimation { sheetUiState.isShowing = false } })
                        .frame(minHeight: UIScreen.main.bounds.height / (isTablet ? 2 : 3))
                    }
                }.edgesIgnoringSafeArea(.bottom)
            }
            .onDisappear { proxy.value = nil }
        }
        .onAppear { if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) } }
    }
}

internal struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            GeometryReader { _ in
                OlaTheme(darkTheme: .systemDefault) {
                    MainView().OlaBackground()
                }
                
                .environment(\.locale, .init(identifier: "fr"))
                .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
        }
    }
}
