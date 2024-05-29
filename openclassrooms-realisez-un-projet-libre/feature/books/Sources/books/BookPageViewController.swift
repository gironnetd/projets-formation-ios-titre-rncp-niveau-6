//
//  BookPageViewController.swift
//  book
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
import model
import analytics

///
/// Enum aiming to return Books screen views
///
enum BookViews: String, CaseIterable, Views {
    case byFaiths, allBooks, books
    
    @ViewBuilder
    func view(pageView: BookPageViewController) -> some View {
        switch self {
        case .byFaiths:
            if case .Success(let feed) = pageView.viewModel.booksFeedUiState {
                OlaGrid(
                    texts: feed.faiths.map { $0.name },
                    filters: pageView.faithsFilters,
                    onClick: { faith, isFollowed in
                        if isFollowed {
                            let analyticsHelper = LocalAnalyticsHelper
                            analyticsHelper.logFaithFilterClick(faith)
                            
                            pageView.filterTab.titles.removeAll(where: {
                                $0.title != "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)  &&
                                $0.title != "all".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
                            })
                            
                            pageView.bookCoordinator.coordinator!.viewControllers.removeAll(where: {
                                $0.title == BookViews.books.rawValue
                            })
                            
                            pageView.bookPage.pages.removeAll(where: {
                                $0.title == BookViews.books.rawValue
                            })
                            
                            if let index = pageView.filterTab.titles.firstIndex(where: { $0.title == "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) }) {
                                
                                pageView.filterTab.titles[pageView.filterTab.titles.firstIndex(where: { $0.title == "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) })!].isActive = true
                                
                                pageView.filterTab.titles.insert(
                                    (faith, false, .faith), at: index + 1)
                                
                                pageView.bookPage.isIncluded = { book in
                                    book.followableTopics
                                        .map { topic in topic.topic.name }
                                        .contains(faith)
                                }
                                
                                let page = Page(
                                    title: BookViews.books.rawValue,
                                    view: BookViews.books)
                                
                                page.objectWillChange.sink { (_) in
                                    if pageView.bookPage.index.currentIndex == index + 1 &&
                                        page.frame.bounds.size != .zero &&
                                        UIScreen.main.bounds.width != pageView.frame.bounds.size.width {
                                        pageView.frame.bounds.size = CGSize(
                                            width: page.frame.bounds.size.width,
                                            height: tabRowHeight + page.frame.bounds.size.height)
                                        pageView.frame.objectWillChange.send()
                                    }
                                }.store(in: &pageView.bookPage.cancellables)
                                
                                pageView.bookPage.pages.insert(page, at: index + 1)
                                
                                let viewController = (title: page.title,
                                                      uiViewController: UiHostingController(rootView: page.view.view(pageView: pageView)))
                                
                                pageView.bookCoordinator.coordinator!.viewControllers.insert(
                                    viewController, at: index + 1)
                                
                                pageView.bookPage.index = (currentIndex: index + 1, previousIndex: index)
                            }
                        } else {
                            pageView.filterTab.titles[pageView.filterTab.titles.firstIndex(where: { $0.title == "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) })!].isActive = false
                            
                            pageView.filterTab.titles.removeAll(where: {
                                $0.title != "faiths".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)  &&
                                $0.title != "all".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
                            })
                        }
                    },
                    frame: pageView.bookPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds))
            }
        case .allBooks:
            if case .Success(let feed) = pageView.viewModel.booksFeedUiState {
                UserResourceGrid<[UserBook], BookCard>(
                    elements: feed.books,
                    onToggleBookmark: { _ in },
                    frame: pageView.bookPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds)) { book in
                        BookCard(book: book,
                                 onToggleBookmark: {},
                                 onClick: { followableTopic in
                            LoadingWheel.isShowing(true)
                            pageView.viewModel.navigate(to: followableTopic)
                        })
                    }
            }
        case .books:
            if case .Success(let feed) = pageView.viewModel.booksFeedUiState {
                UserResourceGrid<[UserBook], BookCard>(
                    elements: feed.books.filter(pageView.bookPage.isIncluded),
                    onToggleBookmark: { _ in },
                    frame: pageView.bookPage.pages.first(where: { $0.title == self.rawValue })?.frame ??
                    Frame(bounds: UIScreen.main.bounds)) { book in
                        BookCard(book: book,
                                 onToggleBookmark: {},
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
/// Class used to wrap Book views with their title
///
class BookPage: Pages<BookViews> {
    var isIncluded: (UserBook) -> Bool = { _ in true }
    
    init(currentIndex: Int, previousIndex: Int, pages: [Page<BookViews>]) {
        super.init(currentIndex: currentIndex, previousIndex: previousIndex)
        self.pages = pages
    }
}

internal class BookCoordinator {
    var coordinator: BookPageViewController.Coordinator?
}

///
/// UIViewControllerRepresentable for Books PageViewController
///
public struct BookPageViewController: UIViewControllerRepresentable {
        
    @ObservedObject public var filterTab: FilterTab
    @ObservedObject internal var viewModel: BooksViewModel
    @ObservedObject fileprivate var frame: Frame
    @ObservedObject fileprivate var bookPage: BookPage
    @ObservedObject var pageView: PageViewController
    @ObservedObject public var faithsFilters: Filter
    
    internal var bookCoordinator: BookCoordinator
    
    init(
        bookPage: BookPage,
        pageView: PageViewController,
        frame: Frame,
        filterTab: FilterTab,
        bookCoordinator: BookCoordinator,
        viewModel: BooksViewModel)
    {
        self.bookPage = bookPage
        self.frame = frame
        self.filterTab = filterTab
        self.viewModel = viewModel
        self.bookCoordinator = bookCoordinator
        self.faithsFilters = Filter()
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
        if case .Loading = viewModel.booksFeedUiState {
            viewModel.booksFeedUiState = .InProgress
            viewModel.feeds {
                DispatchQueue.main.async {
                    bookPage.pages.forEach {
                        context.coordinator.viewControllers.append(
                            (title: $0.title,
                             UiHostingController(rootView: $0.view.view(pageView: self))))
                    }
                    
                    for page in bookPage.pages {
                        page.objectWillChange.sink { (value) in
                            switch page.view {
                            case .byFaiths:
                                if bookPage.index.currentIndex == 0 && UIScreen.main.bounds.width != frame.bounds.size.width {
                                    frame.bounds.size = CGSize(
                                        width: page.frame.bounds.size.width,
                                        height: tabRowHeight + page.frame.bounds.size.height)
                                    frame.objectWillChange.send()
                                }
                            case .allBooks:
                                if bookPage.index.currentIndex == bookPage.pages.count - 1 
                                    /*&& UIScreen.main.bounds.width != frame.bounds.size.width*/ {
                                    frame.bounds.size = CGSize(
                                        width: page.frame.bounds.size.width,
                                        height: tabRowHeight + page.frame.bounds.size.height)
                                    frame.objectWillChange.send()
                                }
                            default:
                                break
                            }
                        }.store(in: &bookPage.cancellables)
                    }
                }
            }
        }
        
        if case .Success = viewModel.booksFeedUiState {
            DispatchQueue.main.async {
                if self.bookPage.pages.count > filterTab.titles.count {
                    DispatchQueue.main.async {
                        withAnimation {
                            bookCoordinator.coordinator!.viewControllers.removeAll(where: {
                                $0.title == BookViews.books.rawValue
                            })
                            
                            bookPage.pages.removeAll(where: { $0.title == BookViews.books.rawValue })
                            
                            if let currentViewController = context.coordinator.viewControllers[bookPage.index.currentIndex].uiViewController {
                                uiViewController.setViewControllers([currentViewController],
                                    direction: bookPage.index.currentIndex > bookPage.index.previousIndex ? .forward : .reverse,
                                    animated: false)
                            }
                        }
                    }
                }
                
                if let currentViewController = context.coordinator.viewControllers.first(where: { $0.title == bookPage.pages[bookPage.index.currentIndex].title }), currentViewController.uiViewController == nil {
                    let viewController = UiHostingController(
                        rootView: bookPage.pages[bookPage.index.currentIndex].view.view(pageView: self))
                    
                    context.coordinator.viewControllers[bookPage.index.currentIndex].uiViewController = viewController
                }
                
                if let currentViewController = context.coordinator.viewControllers[bookPage.index.currentIndex].uiViewController {
                    uiViewController.setViewControllers([currentViewController],
                        direction: bookPage.index.currentIndex >= bookPage.index.previousIndex ? .forward : .reverse,
                        animated: true,
                        completion: { completed in
                            if completed {
                                if frame.bounds.size.height != tabRowHeight + bookPage.pages[bookPage.index.currentIndex].frame.bounds.size.height &&
                                    bookPage.pages[bookPage.index.currentIndex].frame.bounds.size != .zero {
                                    
                                    frame.bounds.size = CGSize(
                                        width: bookPage.pages[bookPage.index.currentIndex].frame.bounds.size.width,
                                        height: tabRowHeight + bookPage.pages[bookPage.index.currentIndex].frame.bounds.size.height)
                                    
                                    frame.objectWillChange.send()
                                }
                            }
                        })
                }
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        if let coordinator = bookCoordinator.coordinator {
            return coordinator
        } else {
            bookCoordinator.coordinator = Coordinator(self)
            return bookCoordinator.coordinator!
        }
    }

    public class Coordinator: OlaCoordinator {
        var parent: BookPageViewController
        
        public init(_ pageView: BookPageViewController) {
            parent = pageView
            super.init()
        }
        
        override public func updateIndex(_ index: Int) {
            super.updateIndex(index)
            parent.bookPage.index = (currentIndex: index, previousIndex: parent.bookPage.index.currentIndex)
            
            parent.frame.bounds.size = CGSize(
                width: parent.bookPage.pages[parent.bookPage.index.currentIndex].frame.bounds.size.width,
                height: tabRowHeight + parent.bookPage.pages[parent.bookPage.index.currentIndex].frame.bounds.size.height)
            
            parent.frame.objectWillChange.send()
        }
    }
}
