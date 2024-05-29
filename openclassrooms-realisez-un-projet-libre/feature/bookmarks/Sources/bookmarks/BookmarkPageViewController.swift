//
//  BookmarkPageViewController.swift
//  bookmarks
//
//  Created by Damien Gironnet on 22/10/2023.
//

import Foundation
import SwiftUI
import UIKit
import designsystem
import model
import common

enum BookmarkViews: Views {
    case bookmarks, resources(BookmarkGroup)
    
    @ViewBuilder
    func view(pageView: BookmarkPageViewController) -> some View {
        switch self {
        case .bookmarks:
            BookmarkGroupView(
                frame: pageView.bookmarkPage.pages[0].frame,
                onBookmarkClick: pageView.onBookmarkClick)
        case .resources(let bookmarkGroup):
            BookmarksView(bookmarkGroup, frame: pageView.bookmarkPage.pages.first(where: { $0.title == "resources" })!.frame)
        }
    }
}

///
/// Class used to wrap Bookmarks screen with their title
///
class BookmarkPage: Pages<BookmarkViews> {
    
    init(currentIndex: Int, previousIndex: Int, pages: [Page<BookmarkViews>]) {
        super.init(currentIndex: currentIndex, previousIndex: previousIndex)
        self.pages = pages
    }
}

public class BookmarkCoordinator {
    var coordinator: BookmarkPageViewController.Coordinator?
}

fileprivate var scrollView: UIScrollView!

internal var uiViewController: UIPageViewController!

///
/// UIViewControllerRepresentable for Bookmark PageViewController
///
public struct BookmarkPageViewController: UIViewControllerRepresentable {
    
    @ObservedObject fileprivate var frame: Frame
    @ObservedObject fileprivate var bookmarkPage: BookmarkPage
    
    internal var bookmarkCoordinator: BookmarkCoordinator
    
    fileprivate func onBookmarkClick(bookmark: BookmarkGroup) {
        scrollView.isScrollEnabled = true
        let bookmarkView = BookmarkViews.resources(bookmark)
        
        let page = Page(title: "resources", view: bookmarkView)
        
        page.objectWillChange.sink { (_) in
            if bookmarkPage.index.currentIndex == 1 && ((isTablet || !isTablet && UIScreen.main.bounds.width != frame.bounds.size.width)) {
                frame.bounds.size = CGSize(
                    width: page.frame.bounds.size.width,
                    height: page.frame.bounds.size.height)
                frame.objectWillChange.send()
            }
        }.store(in: &bookmarkPage.cancellables)
        
        if bookmarkCoordinator.coordinator!.viewControllers.count == 1 {
            bookmarkPage.pages.append(page)
            bookmarkCoordinator.coordinator!.viewControllers
                .append(
                    (title: "resources",
                     UiHostingController(rootView: bookmarkView.view(pageView: self))))
        } else {
            bookmarkPage.pages[1] = page
            bookmarkCoordinator.coordinator!.viewControllers[1] =
            (title: "resources", UiHostingController(rootView: bookmarkView.view(pageView: self)))
        }
        
        bookmarkPage.index = (currentIndex: 1, previousIndex: 0)
    }

    init(frame: Frame,
         bookmarkPage: BookmarkPage,
         bookmarkCoordinator: BookmarkCoordinator) {
        self.frame = frame
        self.bookmarkPage = bookmarkPage
        self.bookmarkCoordinator = bookmarkCoordinator
    }
    
    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        pageViewController.delegate = context.coordinator
        pageViewController.dataSource = context.coordinator
        
        scrollView = pageViewController.view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView
        scrollView.delegate = context.coordinator
        scrollView.isScrollEnabled = false
        scrollView.isPagingEnabled = true
        
        for page in bookmarkPage.pages {
            page.objectWillChange.sink { (value) in
                switch page.view {
                case .bookmarks:
                    if bookmarkPage.index.currentIndex == 0 /*&& UIScreen.main.bounds.width != frame.bounds.size.width*/ {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                case .resources:
                    if bookmarkPage.index.currentIndex == 1 && UIScreen.main.bounds.width != frame.bounds.size.width {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                }
            }.store(in: &bookmarkPage.cancellables)
        }

        uiViewController = pageViewController
        
        return pageViewController
    }
    
    public func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        DispatchQueue.main.async {
            if let currentViewController = context.coordinator.viewControllers[bookmarkPage.index.currentIndex].uiViewController {
                uiViewController.setViewControllers([currentViewController],
                    direction: bookmarkPage.index.currentIndex >= bookmarkPage.index.previousIndex ? .forward : .reverse,
                    animated: true,
                    completion: { completed in
                        if completed {
                            frame.bounds.size = bookmarkPage.pages[bookmarkPage.index.currentIndex].frame.bounds.size
                            frame.objectWillChange.send()
                            
                            if bookmarkPage.index.currentIndex == 0 {
                                scrollView.isScrollEnabled = false
                            }
                            
                            if bookmarkPage.index.currentIndex == 1 {
                                scrollView.isScrollEnabled = true
                            }
                        }
                    })
            }
        }
    }
    

    public func makeCoordinator() -> Coordinator {
        if let coordinator = bookmarkCoordinator.coordinator {
            return coordinator
        } else {
            bookmarkCoordinator.coordinator = Coordinator(self)
            return bookmarkCoordinator.coordinator!
        }
    }
    
    public class Coordinator: OlaCoordinator {
        var parent: BookmarkPageViewController
        
        public init(_ pageViewController: BookmarkPageViewController) {
            parent = pageViewController
            super.init()
            
            parent.bookmarkPage.pages.forEach {
                viewControllers.append(
                    (title: $0.title,
                     UiHostingController(rootView: $0.view.view(pageView: parent))))
            }
        }
        
        public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if parent.bookmarkPage.index.currentIndex == 0 { 
                scrollView.isScrollEnabled = false
            }
            
            if parent.bookmarkPage.index.currentIndex == 1 {
                scrollView.isScrollEnabled = true
            }
        }
        
        override public func updateIndex(_ index: Int) {
            super.updateIndex(index)
            parent.bookmarkPage.index = (currentIndex: index, previousIndex: parent.bookmarkPage.index.currentIndex)
            
            parent.frame.bounds.size = parent.bookmarkPage.pages[parent.bookmarkPage.index.currentIndex].frame.bounds.size
            parent.frame.objectWillChange.send()
            
            if parent.bookmarkPage.index.currentIndex == 0 {
                scrollView.isScrollEnabled = false
            }
            
            if parent.bookmarkPage.index.currentIndex == 1 {
                scrollView.isScrollEnabled = true
            }
        }
    }
}
