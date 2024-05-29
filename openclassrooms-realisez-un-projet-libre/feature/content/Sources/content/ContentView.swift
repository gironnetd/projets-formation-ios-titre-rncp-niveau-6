//
//  ContentView.swift
//  content
//
//  Created by Damien Gironnet on 01/08/2023.
//

import SwiftUI
import ui
import common
import designsystem
import Factory
import domain
import model
import navigation
import bookmarks

///
/// Structure representing the View for the content view
///
public struct ContentView: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject var sheetUiState: SheetUiState = SheetUiState.shared
    @ObservedObject private var viewModel: ContentViewModel
    @ObservedObject private var contentPage: ContentPage
    @ObservedObject var coordinator: ContentCoordinator
    @ObservedObject var pageController: PageViewController
    @ObservedObject var frame: Frame
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
            
    @State private var hideTabBar: Bool = false
    @State private var bottomTabBarSize: CGSize = .zero
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    
    private let scrollViewCoordinateSpace: String = "contentScrollView"
    private let followableTopic: FollowableTopic
        
    public init(followableTopic: FollowableTopic) {
        self.followableTopic = followableTopic
        viewModel = ContentViewModel()
        coordinator = ContentCoordinator()
        pageController = PageViewController()
        contentPage = ContentPage(currentIndex: 0, previousIndex: 0)
        frame = Frame(bounds: UIScreen.main.bounds)
    }
    
    private var tabView: some View {
        ContentPageViewController(
            contentPage: contentPage,
            followableTopic: followableTopic,
            viewModel: viewModel,
            contentCoordinator: coordinator,
            pageViewController: pageController,
            frame: frame)
    }
    
    @ViewBuilder
    private var tabBar: some View {
        ZStack {
            (
                colorScheme == .light ?
                (orientation.isLandscape || isTablet ?
                 PaletteTokens.White.opacity(0.0).brightness(0.0) : PaletteTokens.White.brightness(0.0)) :
                (orientation.isLandscape || isTablet ?
                 localColorScheme.primaryContainer.opacity(0.0).brightness(-0.1) : localColorScheme.primaryContainer.brightness(-0.06))
            )
            .frame(minWidth: !isTablet && orientation.isPortrait ? UIScreen.main.bounds.width : nil,
                    maxWidth: !isTablet && orientation.isPortrait ? UIScreen.main.bounds.width : nil)
            
            OlaTabRow(
                fixed: true,
                isVertical: isTablet || orientation.isLandscape,
                geometryWidth: geometry.bounds.size.width,
                selectedTabIndex: $contentPage.index.currentIndex,
                tabs: contentPage.icons.enumerated().map { (index, icons) in
                    OlaTabRowItem(
                        selected: contentPage.index.currentIndex == (index - 1),
                        onClick: {
                            if index == 0 {
                                if case .content(let followableTopic, _) =  viewModel.mainRouter.previousScreen[viewModel.mainRouter.previousScreen.count - 2] {
                                    withAnimation(.easeInOut(duration: MainNavigation.NavigationDuration)) {
                                        pageController.uiViewController!.view.alpha = 0
                                    }
                                    
                                    viewModel.navigate(to: followableTopic, returnToPrevious: true)
                                } else {
                                    withAnimation(.easeInOut(duration: MainNavigation.NavigationDuration)) {
                                        pageController.uiViewController!.view.alpha = 0
                                    }
                                    
                                    withAnimation {
                                        LoadingWheel.isShowing(true)
//                                        viewModel.mainRouter.visibleScreen = .splash
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
                                            viewModel.mainRouter.visibleScreen = .main
                                        }
                                    }
                                }
                            } else {
                                contentPage.index.currentIndex = index - 1
                            }
                        },
                        content: {
                            ContentBottomBar(index: index - 1,
                                             selectedTabIndex: $contentPage.index.currentIndex,
                                             selectedIcon: icons.selectedIcon,
                                             icon: icons.icon)
                        })
                })
            .padding(.top, isTablet ? 0.0 : UIScreen.inches > 4.7 ? 4.0 : 1.0)
            .padding(.bottom, isTablet ? 0.0 : (orientation.isPortrait ? (UIScreen.inches > 4.7 ? 24 : 12) : 0.0))
        }
        .fixedSize(horizontal: orientation.isLandscape ? true : true, vertical: orientation.isLandscape ? false : true)
        .modifier(SizeModifier())
        .onPreferenceChange(SizePreferenceKey.self) { value in
            DispatchQueue.main.async {
                guard value.width != 0 && value.height != 0 else { return }
                
                DispatchQueue.main.async { self.bottomTabBarSize = value }
            }
        }
        .edgesIgnoringSafeArea(isTablet || orientation.isLandscape ? .leading : [])
        .offset(y: orientation.isLandscape || isTablet || !hideTabBar ? 0 : bottomTabBarSize.height )
    }
    
    public var body: some View {
        ScrollViewReader { reader in
            ZStack(alignment: orientation.isLandscape || isTablet ? .leading : .bottom) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: .zero) {
                        dove.id("dove").padding(.top, orientation.isPortrait || isTablet ? geometry.safeAreaInsets.top : 16.0)

                        CardTitle(title: followableTopic.topic.name, alignment: .center)
                            .padding(.vertical, 10)
                                                
                        if let userResource = viewModel.userResource {
                            if userResource.followableTopics.filter({
                                $0.topic.name != followableTopic.topic.name }).isNotEmpty {
                                HStack {
                                    ForEach(userResource.followableTopics.filter({
                                        $0.topic.name != followableTopic.topic.name &&
                                        $0.topic.kind != .theme &&
                                        $0.topic.kind != .century }).indices, id: \.self) { index in
                                            let followableTopic = userResource.followableTopics.filter({
                                                $0.topic.name != self.followableTopic.topic.name })[index]
                                            
                                            OlaTopicTag(
                                                followed: true,
                                                onClick: {},
                                                enabled: false,
                                                text: followableTopic.topic.name,
                                                font: TypographyTokens.HeadlineSmall.customFont.uiFont)
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: MainNavigation.NavigationDuration)) {
                                                    pageController.uiViewController!.view.alpha = 0
                                                }
                                                viewModel.navigate(to: followableTopic, returnToPrevious: false)
                                            }
                                        }
                                }.padding(.bottom, 30)
                            }
                        }
                        
                        tabView.frame(minWidth: UIScreen.main.bounds.width,
                                      maxWidth: UIScreen.main.bounds.width,
                                      minHeight: frame.bounds.height +
                                       (!isTablet && !orientation.isLandscape ? bottomTabBarSize.height : 0.0),
                                      maxHeight: frame.bounds.height +
                                       (!isTablet && !orientation.isLandscape ? bottomTabBarSize.height : 0.0)
                        )
                        .edgesIgnoringSafeArea(.horizontal)
                        .overlay(
                            GeometryReader { proxy -> Color in
                                if frame.bounds.size.height < geometry.bounds.height - geometry.safeAreaInsets.top - proxy.frame(in: .named("vstack")).minY - (orientation.isPortrait ? geometry.safeAreaInsets.bottom : 0.0) {
                                    
                                    frame.bounds.size.height =
                                    geometry.bounds.height - geometry.safeAreaInsets.top - proxy.frame(in: .named("vstack")).minY - (orientation.isPortrait ? geometry.safeAreaInsets.bottom : 0.0)
                                }
                                
                                return Color.clear
                            })
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
                            }
                            
                            return Color.clear
                        }
                    )
                }
                .coordinateSpace(name: scrollViewCoordinateSpace)
                
                tabBar
                
                Sheet(isShowing: $sheetUiState.isShowing) {
                    switch sheetUiState.currentSheet {
                    case .bookmarks (let userResource):
                        SaveUserResourceView(userResource)
                            .frame(minHeight: UIScreen.main.bounds.height / 3,
                                   maxHeight: UIScreen.main.bounds.height / 2,
                                   alignment: .top)
                    case .createBoomark:
                        CreateOrEditBookmarkGroupView(onCompleted: {
                            withAnimation {
                                sheetUiState.isShowing = false
                            }
                            
                            if let previousSheet = sheetUiState.previousSheet {
                                sheetUiState.currentSheet = previousSheet
                            }
                        })
                        .frame(minHeight: UIScreen.main.bounds.height / (isTablet ? 2 : 3), alignment: .top)
                    default:
                        EmptyView()
                    }
                }.edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}
