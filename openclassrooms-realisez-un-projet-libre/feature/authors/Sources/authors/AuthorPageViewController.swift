//
//  AuthorPageViewController.swift
//  author
//
//  Created by Damien Gironnet on 26/06/2023.
//

import SwiftUI
import UIKit
import ui
import designsystem
import domain
import navigation
import Factory
import analytics
import model
import common

///
/// Enum aiming to return Authors screen views
///
enum AuthorViews: String, CaseIterable, Views {
    case byFaiths, byCenturies, allAuthors, authors
    
    @ViewBuilder
    func view(pageView: AuthorPageViewController) -> some View {
        switch self {
        case .byCenturies:
            if case .Success(let feed) = pageView.viewModel.authorsFeedUiState {
                CenturyGrid(
                    centuries: feed.centuries.map { $0.century },
                    filters: pageView.centuriesFilters,
                    onClick: { century, isFollowed in
                        if isFollowed {
                            let analyticsHelper = LocalAnalyticsHelper
                            analyticsHelper.logCenturyFilterClick(century)
                            
                            pageView.filterTab.titles.removeAll(where: {
                                $0.title != "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) &&
                                $0.title != "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)  &&
                                $0.title != "all".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
                            })
                            
                            pageView.authorCoordinator.coordinator!.viewControllers.removeAll(where: {
                                $0.title == AuthorViews.authors.rawValue
                            })
                            
                            pageView.authorPage.pages.removeAll(where: {
                                $0.title == AuthorViews.authors.rawValue
                            })
                            
                            pageView.filterTab.titles[pageView.filterTab.titles.firstIndex(where: { $0.title == "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) })!].isActive = false
                            
                            pageView.faithsFilters.tags.forEach { $0.tag.followed.value = false }
                            
                            if let index = pageView.filterTab.titles.firstIndex(where: { $0.title == "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) }) {
                                
                                pageView.filterTab.titles[pageView.filterTab.titles.firstIndex(where: { $0.title == "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) })!].isActive = true
                                
                                pageView.filterTab.titles.insert((century, false, .century), at: index + 1)
                                
                                pageView.authorPage.isIncluded = { author in
                                    author.followableTopics
                                        .map { topic in topic.topic.name }
                                        .contains(century)
                                }
                                
                                let page = Page(
                                    title: AuthorViews.authors.rawValue,
                                    view: AuthorViews.authors)
                                
                                page.objectWillChange.sink { (_) in
                                    if pageView.authorPage.index.currentIndex == index + 1 &&
                                        page.frame.bounds.size != .zero &&
                                        UIScreen.main.bounds.width != pageView.frame.bounds.size.width {
                                        pageView.frame.bounds.size = CGSize(
                                            width: page.frame.bounds.size.width,
                                            height: tabRowHeight + page.frame.bounds.size.height)
                                        pageView.frame.objectWillChange.send()
                                    }
                                }.store(in: &pageView.authorPage.cancellables)
                                
                                pageView.authorPage.pages.insert(page, at: index + 1)
                            
                                pageView.authorCoordinator.coordinator!.viewControllers.insert(
                                    (title: page.title, uiViewController: nil), at: index + 1)
                                
                                pageView.authorPage.index = (currentIndex: index + 1, previousIndex: index)
                            }
                        } else {
                            pageView.filterTab.titles[pageView.filterTab.titles.firstIndex(where: { $0.title == "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) })!].isActive = false
                            
                            pageView.filterTab.titles.removeAll(where: {
                                $0.title != "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) &&
                                $0.title != "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)  &&
                                $0.title != "all".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
                            })
                        }
                    },
                    frame: pageView.authorPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds))
            }
        case .byFaiths:
            if case .Success(let feed) = pageView.viewModel.authorsFeedUiState {
                OlaGrid(
                    texts: feed.faiths.map { $0.name },
                    filters: pageView.faithsFilters,
                    onClick: { faith, isFollowed in
                        if isFollowed {
                            let analyticsHelper = LocalAnalyticsHelper
                            analyticsHelper.logFaithFilterClick(faith)
                            
                            pageView.filterTab.titles.removeAll(where: {
                                $0.title != "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) &&
                                $0.title != "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)  &&
                                $0.title != "all".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
                            })
                            
                            pageView.authorCoordinator.coordinator!.viewControllers.removeAll(where: {
                                $0.title == AuthorViews.authors.rawValue
                            })
                            
                            pageView.authorPage.pages.removeAll(where: {
                                $0.title == AuthorViews.authors.rawValue
                            })
                            
                            pageView.filterTab.titles[pageView.filterTab.titles.firstIndex(where: { $0.title == "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) })!].isActive = false
                            
                            pageView.centuriesFilters.tags.forEach { $0.tag.followed.value = false }
                            
                            if let index = pageView.filterTab.titles.firstIndex(where: { $0.title == "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) }) {
                                
                                pageView.filterTab.titles[pageView.filterTab.titles.firstIndex(where: { $0.title == "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) })!].isActive = true
                                
                                pageView.filterTab.titles.insert((faith, false, .faith), at: index + 1)
                                
                                pageView.authorPage.isIncluded = { author in
                                    author.followableTopics
                                        .map { topic in topic.topic.name }
                                        .contains(faith)
                                }
                                
                                let page = Page(
                                    title: AuthorViews.authors.rawValue,
                                    view: AuthorViews.authors)
                                
                                page.objectWillChange.sink { (_) in
                                    if pageView.authorPage.index.currentIndex == index + 1 &&
                                        page.frame.bounds.size != .zero &&
                                        UIScreen.main.bounds.width != pageView.frame.bounds.size.width {
                                        pageView.frame.bounds.size = CGSize(
                                            width: page.frame.bounds.size.width,
                                            height: tabRowHeight + page.frame.bounds.size.height)
                                        pageView.frame.objectWillChange.send()
                                    }
                                }.store(in: &pageView.authorPage.cancellables)
                                
                                pageView.authorPage.pages.insert(page, at: index + 1)
                                
                                pageView.authorCoordinator.coordinator!.viewControllers.insert(
                                    (title: page.title, uiViewController: nil), at: index + 1)
                                
                                pageView.authorPage.index = (currentIndex: index + 1, previousIndex: index)
                            }
                        } else {
                            pageView.filterTab.titles[pageView.filterTab.titles.firstIndex(where: { $0.title == "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) })!].isActive = false
                            
                            pageView.filterTab.titles.removeAll(where: {
                                $0.title != "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) &&
                                $0.title != "centuries".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)  &&
                                $0.title != "all".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
                            })
                        }
                    },
                    frame: pageView.authorPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds))
            }
        case .allAuthors:
            if case .Success(let feed) = pageView.viewModel.authorsFeedUiState {
                UserResourceGrid<[UserAuthor], AuthorCard>(
                    elements: feed.authors,
                    onToggleBookmark: { _ in },
                    frame: pageView.authorPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds)) { author in
                        AuthorCard(author: author,
                                   onToggleBookmark: { },
                                   onClick: { followableTopic in
                            LoadingWheel.isShowing(true)
                            pageView.viewModel.navigate(to: followableTopic)
                        })
                    }
            }
        case .authors:
            if case .Success(let feed) = pageView.viewModel.authorsFeedUiState {
                UserResourceGrid<[UserAuthor], AuthorCard>(
                    elements: feed.authors.filter(pageView.authorPage.isIncluded),
                    onToggleBookmark: { _ in },
                    frame: pageView.authorPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds)) { author in
                        AuthorCard(author: author,
                                   onToggleBookmark: { },
                                   onClick: { followableTopic in
                            LoadingWheel.isShowing(true)
                            pageView.viewModel.navigate(to: followableTopic)
                        })
                    }
            }
        }
    }
}

public class PageViewController: ObservableObject {
    @Published var uiViewController: UIPageViewController?
}

///
/// Class used to wrap Authors screen with their title
///
class AuthorPage: Pages<AuthorViews> {
    var isIncluded: (UserAuthor) -> Bool = { _ in true }
    
    init(currentIndex: Int, previousIndex: Int, pages: [Page<AuthorViews>]) {
        super.init(currentIndex: currentIndex, previousIndex: previousIndex)
        self.pages = pages
    }
}

internal class AuthorCoordinator {
    var coordinator: AuthorPageViewController.Coordinator?
}

///
/// UIViewControllerRepresentable for Authors PageViewController
///
public struct AuthorPageViewController: UIViewControllerRepresentable {
    
    @ObservedObject public var filterTab: FilterTab
    @ObservedObject public var viewModel: AuthorsViewModel
    @ObservedObject fileprivate var frame: Frame
    @ObservedObject fileprivate var authorPage: AuthorPage
    @ObservedObject var pageView: PageViewController
    @ObservedObject public var faithsFilters: Filter
    @ObservedObject public var centuriesFilters: Filter
    
    internal var authorCoordinator: AuthorCoordinator
    
    init(
        authorPage: AuthorPage,
        pageView: PageViewController,
        frame: Frame,
        filterTab: FilterTab,
        authorCoordinator: AuthorCoordinator,
        viewModel: AuthorsViewModel)
    {
        self.authorPage = authorPage
        self.frame = frame
        self.filterTab = filterTab
        self.viewModel = viewModel
        self.authorCoordinator = authorCoordinator
        self.faithsFilters = Filter()
        self.centuriesFilters = Filter()
        self.pageView = pageView
    }
    
    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageView = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        pageView.delegate = context.coordinator
        pageView.dataSource = context.coordinator
        
        let scrollView = pageView.view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
        scrollView.delegate = context.coordinator
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        
        self.pageView.uiViewController = pageView
        
        return pageView
    }
    
    public func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        if case .Loading = viewModel.authorsFeedUiState {
            viewModel.authorsFeedUiState = .InProgress
            viewModel.feeds {
                DispatchQueue.main.async {
                    authorPage.pages.forEach {
                        context.coordinator.viewControllers.append(
                            (title: $0.title,
                             UiHostingController(rootView: $0.view.view(pageView: self))))
                    }
                    
                    for page in authorPage.pages {
                        page.objectWillChange.sink { (value) in
                            switch page.view {
                            case .byFaiths:
                                if authorPage.index.currentIndex == 0 && UIScreen.main.bounds.width != frame.bounds.size.width {
                                    frame.bounds.size = CGSize(
                                        width: page.frame.bounds.size.width,
                                        height: tabRowHeight + page.frame.bounds.size.height)
                                    frame.objectWillChange.send()
                                }
                            case .byCenturies:
                                if let index = authorPage.pages.firstIndex(where: { $0.title == AuthorViews.byCenturies.rawValue }),
                                    authorPage.index.currentIndex == index && UIScreen.main.bounds.width != frame.bounds.size.width {
                                    frame.bounds.size = CGSize(
                                        width: page.frame.bounds.size.width,
                                        height: tabRowHeight + page.frame.bounds.size.height)
                                    frame.objectWillChange.send()
                                }
                            case .allAuthors:
                                if authorPage.index.currentIndex == authorPage.pages.count - 1 /*&& UIScreen.main.bounds.width != frame.bounds.size.width*/ {
                                    frame.bounds.size = CGSize(
                                        width: page.frame.bounds.size.width,
                                        height: tabRowHeight + page.frame.bounds.size.height)
                                    frame.objectWillChange.send()
                                }
                            default:
                                break
                            }
                        }.store(in: &authorPage.cancellables)
                    }
                }
            }
        }
        
        if case .Success = viewModel.authorsFeedUiState {
            DispatchQueue.main.async {
                if self.authorPage.pages.count > filterTab.titles.count {
                    DispatchQueue.main.async {
                        withAnimation {
                            authorCoordinator.coordinator!.viewControllers.removeAll(where: {
                                $0.title == AuthorViews.authors.rawValue
                            })
                            
                            authorPage.pages.removeAll(where: { $0.title == AuthorViews.authors.rawValue })
                            
                            if let currentViewController = context.coordinator.viewControllers[authorPage.index.currentIndex].uiViewController {
                                uiViewController.setViewControllers([currentViewController],
                                    direction: authorPage.index.currentIndex > authorPage.index.previousIndex ? .forward : .reverse,
                                    animated: false)
                            }
                        }
                    }
                }
                
                if let currentViewController = context.coordinator.viewControllers.first(where: { $0.title == authorPage.pages[authorPage.index.currentIndex].title }), currentViewController.uiViewController == nil {
                    let viewController = UiHostingController(
                        rootView: authorPage.pages[authorPage.index.currentIndex].view.view(pageView: self))
                    
                    context.coordinator.viewControllers[authorPage.index.currentIndex].uiViewController = viewController
                }
                
                if let currentViewController = context.coordinator.viewControllers[authorPage.index.currentIndex].uiViewController {
                    uiViewController.setViewControllers([currentViewController],
                        direction: authorPage.index.currentIndex >= authorPage.index.previousIndex ? .forward : .reverse,
                        animated: true,
                        completion: { completed in
                            if completed {
                                if frame.bounds.size.height != tabRowHeight + authorPage.pages[authorPage.index.currentIndex].frame.bounds.size.height &&
                                    authorPage.pages[authorPage.index.currentIndex].frame.bounds.size != .zero {
                                    
                                    frame.bounds.size = CGSize(
                                        width: authorPage.pages[authorPage.index.currentIndex].frame.bounds.size.width,
                                        height: tabRowHeight + authorPage.pages[authorPage.index.currentIndex].frame.bounds.size.height)
                                    
                                    frame.objectWillChange.send()
                                }
                            }
                        })
                }
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        if let coordinator = authorCoordinator.coordinator {
            return coordinator
        } else {
            authorCoordinator.coordinator = Coordinator(self)
            return authorCoordinator.coordinator!
        }
    }
    
    public class Coordinator: OlaCoordinator {
        var parent: AuthorPageViewController
        
        public init(_ pageViewController: AuthorPageViewController) {
            parent = pageViewController
            super.init()
        }
        
        override public func updateIndex(_ index: Int) {
            super.updateIndex(index)
            parent.authorPage.index = (currentIndex: index, previousIndex: parent.authorPage.index.currentIndex)
            
            parent.frame.bounds.size = CGSize(
                width: parent.authorPage.pages[parent.authorPage.index.currentIndex].frame.bounds.size.width,
                height: tabRowHeight + parent.authorPage.pages[parent.authorPage.index.currentIndex].frame.bounds.size.height)
            
            parent.frame.objectWillChange.send()
        }
    }
}
