//
//  ContentPageViewController.swift
//  content
//
//  Created by Damien Gironnet on 07/08/2023.
//

import SwiftUI
import UIKit
import ui
import designsystem
import domain
import navigation
import model
import common
import analytics

///
/// Enum aiming to return Content screen pages
///
public enum ContentViews: String, Views {
    case quotes, biography, pictures
    
    @ViewBuilder
    public func view(pageView: ContentPageViewController) -> some View {
        switch self {
        case .quotes:
            if case .Success(let quotes) = pageView.viewModel.quotesUiState.value.state {
                switch pageView.viewModel.userResource {
                case _ as UserAuthor, _ as UserBook, _ as UserTheme:
                    UserResourceGrid<[UserQuote], QuoteCard>(
                        elements: quotes,
                        onToggleBookmark: { _ in },
                        frame: pageView.contentPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                        Frame(bounds: UIScreen.main.bounds)) { quote in
                            QuoteCard(
                                quote: quote,
                                onToggleBookmark: pageView.onToggleBookmark,
                                onTopicClick: { followableTopic in
                                    LoadingWheel.isShowing(true)
                                    withAnimation(.easeInOut(duration: MainNavigation.NavigationDuration)) {
                                        pageView.pageViewController.uiViewController!.view.alpha = 0
                                    }
                                    pageView.viewModel.navigate(to: followableTopic, returnToPrevious: false)
                                })
                        }
                case _ as UserFaith:
                    VStack(alignment: .center) {
                        OlaTopicTag(
                            followed: true,
                            onClick: {},
                            enabled: false,
                            text: "authors_and_books".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem),
                            font: TypographyTokens.HeadlineSmall.customFont.uiFont
                        )
                        .padding(.bottom, 20)
                        
                        OlaGrid(
                            texts: Array(Set(quotes.map({ $0.followableTopics.first!.topic.name }))),
                            onClick: { authorBook, isFollowed in
                                if let followableTopic = quotes.first(where: { $0.followableTopics.contains(where: { $0.topic.name == authorBook })})?.followableTopics.first(where: { $0.topic.name == authorBook }) {
                                    let analyticsHelper = LocalAnalyticsHelper
                                    analyticsHelper.logAuthorBookFilterClick(authorBook)
                                    
                                    LoadingWheel.isShowing(true)
                                    withAnimation(.easeInOut(duration: MainNavigation.NavigationDuration)) {
                                        pageView.pageViewController.uiViewController!.view.alpha = 0
                                    }
                                    
                                    pageView.viewModel.navigate(to: followableTopic, returnToPrevious: false)
                                }
                            },
                            frame: pageView.contentPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                            Frame(bounds: UIScreen.main.bounds))
                    }
                default:
                    EmptyView()
                }
            }
        case .biography:
            if case .Success(let biography) = pageView.viewModel.biographyUiState.value.state {
                UserResourceGrid<[UserBiography], BiographyCard>(
                    elements: [biography],
                    onToggleBookmark: { _ in },
                    frame: pageView.contentPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds)) { biography in
                        BiographyCard(biography: biography, onToggleBookmark: pageView.onToggleBookmark)
                    }
            }
        case .pictures:
            if case .Success(let pictures) = pageView.viewModel.picturesUiState.value.state {
                UserResourceGrid<[UserPicture], PictureCard>(
                    elements: pictures,
                    onToggleBookmark: { _ in },
                    frame: pageView.contentPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds)) { picture in
                        PictureCard(picture: picture, onToggleBookmark: pageView.onToggleBookmark)
                    }
            }
        }
    }
}

public class ContentPage: Pages<ContentViews> {
    @Published internal var icons: [(selectedIcon: Image, icon: Image)] = []
}

public class PageViewController: ObservableObject {
    @Published var uiViewController: UIPageViewController?
}

public class ContentCoordinator: ObservableObject {
    @Published var coordinator: ContentPageViewController.Coordinator?
}

var contentScrollView: UIScrollView!
var panGesture : UIPanGestureRecognizer!

///
/// UIViewControllerRepresentable for Content PageViewController
///
public struct ContentPageViewController: UIViewControllerRepresentable {
    
    @ObservedObject var contentPage: ContentPage
    @ObservedObject var pageViewController: PageViewController
    @ObservedObject var contentCoordinator: ContentCoordinator
    @ObservedObject var frame: Frame
    
    private let followableTopic: FollowableTopic
    @ObservedObject fileprivate var viewModel: ContentViewModel
    
    fileprivate var onToggleBookmark: (UserResource) -> Void = { resource in
        SheetUiState.shared.currentSheet = .bookmarks(resource)
    }
    
    public init(contentPage: ContentPage,
                followableTopic: FollowableTopic,
                viewModel: ContentViewModel,
                contentCoordinator: ContentCoordinator,
                pageViewController: PageViewController,
                frame: Frame) {
        self.contentPage = contentPage
        self.followableTopic = followableTopic
        self.viewModel = viewModel
        self.contentCoordinator = contentCoordinator
        self.pageViewController = pageViewController
        self.frame = frame
    }
    
    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        pageViewController.delegate = context.coordinator
        pageViewController.dataSource = context.coordinator
        
        contentScrollView = pageViewController.view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView
        contentScrollView.delegate = context.coordinator
        contentScrollView.isPagingEnabled = true
        contentScrollView.isScrollEnabled = true
        
        return pageViewController
    }
    
    public func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        if contentPage.title.isEmpty {
            contentPage.title = followableTopic.topic.name
            context.coordinator.viewControllers.removeAll()

            viewModel.populateFeeds(from: followableTopic, onComplete: {
                DispatchQueue.main.async {
                    self.pageViewController.uiViewController = uiViewController
                    
                    contentPage.icons.append(((OlaIcons.Backward, OlaIcons.Backward)))
                    
                    if case .Success = viewModel.quotesUiState.value.state {
                        contentPage.icons.append(((OlaIcons.Quotes, OlaIcons.Quotes)))
                        contentPage.pages.append(Page(title: ContentViews.quotes.rawValue,
                                                      view: ContentViews.quotes))
                        
                        context.coordinator.viewControllers.append(
                            (title: ContentViews.quotes.rawValue,
                             UiHostingController(rootView: ContentViews.quotes.view(pageView: self))))
                    }
                    
                    if case .Success = viewModel.biographyUiState.value.state {
                        contentPage.icons.append(((OlaIcons.Biography, OlaIcons.Biography)))
                        contentPage.pages.append(Page(title: ContentViews.biography.rawValue,
                                                      view: ContentViews.biography))
                        
                        context.coordinator.viewControllers.append(
                            (title: ContentViews.biography.rawValue,
                             UiHostingController(rootView: ContentViews.biography.view(pageView: self))))
                    }
                
                    if case .Success = viewModel.picturesUiState.value.state {
                        contentPage.icons.append(((OlaIcons.Pictures, OlaIcons.Pictures)))
                        contentPage.pages.append(Page(title: ContentViews.pictures.rawValue,
                                                      view: ContentViews.pictures))
                        
                        context.coordinator.viewControllers.append(
                            (title: ContentViews.pictures.rawValue,
                             UiHostingController(rootView: ContentViews.pictures.view(pageView: self))))
                    }
                    
                    for page in contentPage.pages {
                        page.objectWillChange.sink { (_) in
                            switch page.view {
                            case .quotes:
                                if contentPage.index.currentIndex == 0  {
                                    if let _ = viewModel.userResource as? UserFaith {
                                        frame.bounds.size = CGSize(
                                            width: page.frame.bounds.size.width,
                                            height: tabRowHeight + 4 + page.frame.bounds.size.height)
                                    } else {
                                        frame.bounds.size = page.frame.bounds.size
                                    }
                                    frame.objectWillChange.send()
                                }
                            case .biography:
                                if contentPage.index.currentIndex == 1 &&
                                    UIScreen.main.bounds.width != frame.bounds.size.width {
                                    frame.bounds.size = page.frame.bounds.size
                                    frame.objectWillChange.send()
                                }
                            case .pictures:
                                if contentPage.index.currentIndex == contentPage.pages.count - 1 &&
                                    UIScreen.main.bounds.width != frame.bounds.size.width {
                                    frame.bounds.size = page.frame.bounds.size
                                    frame.objectWillChange.send()
                                }
                            }
                        }.store(in: &contentPage.cancellables)
                    }
                }
            })
        } 

        if context.coordinator.viewControllers.count > contentPage.index.currentIndex &&
            contentPage.title.isNotEmpty {
                DispatchQueue.main.async {
                        uiViewController.setViewControllers(
                            [context.coordinator.viewControllers[contentPage.index.currentIndex].uiViewController!],
                            direction: contentPage.index.currentIndex > contentPage.index.previousIndex ? .forward : .reverse,
                            animated: true,
                            completion: { completed in
                                if completed {
                                    if let _ = viewModel.userResource as? UserFaith,
                                       contentPage.pages[contentPage.index.currentIndex].view == .quotes  {
                                        frame.bounds.size = CGSize(
                                            width: contentPage.pages[contentPage.index.currentIndex].frame.bounds.size.width,
                                            height: tabRowHeight + 4 + contentPage.pages[contentPage.index.currentIndex].frame.bounds.size.height)
                                    } else {
                                        frame.bounds.size = contentPage.pages[contentPage.index.currentIndex].frame.bounds.size
                                    }
                                    
                                    withAnimation {
                                        if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                                    }
                                }
                            })
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        if let coordinator = contentCoordinator.coordinator {
            return coordinator
        } else {
            contentCoordinator.coordinator = Coordinator(self, selectedTabIndex: $contentPage.index.currentIndex)
            return contentCoordinator.coordinator!
        }
    }
    
    public class Coordinator: OlaCoordinator {
        var parent: ContentPageViewController
        var id: String = UUID().uuidString
        @Binding var selectedTabIndex: Int
        var startOffset = CGFloat(0)
        var direction = -2
        
        public init(_ pageViewController: ContentPageViewController, selectedTabIndex: Binding<Int>) {
            parent = pageViewController
            self._selectedTabIndex = selectedTabIndex
            super.init()
        }
        
        override public func updateIndex(_ index: Int) {
            super.updateIndex(index)
            parent.contentPage.index = (currentIndex: index, previousIndex: parent.contentPage.index.currentIndex)
        }
        
        public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            direction = parent.contentPage.index.currentIndex
        }
        
        public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            parent.frame.bounds.size = parent.contentPage.pages[parent.contentPage.index.currentIndex].frame.bounds.size
        }
    }
}

