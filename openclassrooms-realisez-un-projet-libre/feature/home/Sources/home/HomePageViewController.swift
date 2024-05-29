//
//  PageViewController.swift
//  designsystem
//
//  Created by Damien Gironnet on 11/06/2023.
//

import SwiftUI
import UIKit
import designsystem
import foryou
import authors
import books
import faiths
import themes
import ui
import model

///
/// Enum aiming to return Home screen views
///
enum HomeViews: String, CaseIterable, Views {
    case foryou, authors, books, faith, theme
    
    @ViewBuilder
    func view(pageView: HomePageViewController) -> some View {
        switch self {
        case .foryou:
            ForyouView(frame: pageView.homePage.pages[0].frame)
        case .authors:
            AuthorsView(frame: pageView.homePage.pages[1].frame, proxy: pageView.proxy)
        case .books:
            BooksView(frame: pageView.homePage.pages[2].frame, proxy: pageView.proxy)
        case .faith:
            FaithsView(frame: pageView.homePage.pages[3].frame)
        case .theme:
            ThemesView(frame: pageView.homePage.pages[4].frame)
        }
    }
}

///
/// Class used to wrap Authors screen with their title
///
class HomePage: Pages<HomeViews> {
    
    override var index: (currentIndex: Int, previousIndex: Int) {
        willSet {
            if pages[newValue.currentIndex].frame.bounds.size.height == UIScreen.main.bounds.height {
                LoadingWheel.isShowing(true)
            }
        }
    }
    
    init(currentIndex: Int, previousIndex: Int, pages: [Page<HomeViews>]) {
        super.init(currentIndex: currentIndex, previousIndex: previousIndex)
        self.pages = pages
        self.pages.forEach { $0.frame.bounds.size.height = UIScreen.main.bounds.height }
    }
}

internal class HomeCoordinator {
    var coordinator: HomePageViewController.Coordinator?
}

///
/// UIViewControllerRepresentable for Home PageViewController
///
public struct HomePageViewController: UIViewControllerRepresentable {
    @ObservedObject fileprivate var homePage: HomePage
    @ObservedObject var frame: Frame
    @ObservedObject internal var proxy: Proxy
    
    var homeCoordinator: HomeCoordinator
    
    init(homePage: HomePage,
         frame: Frame,
         proxy: Proxy,
         homeCoordinator: HomeCoordinator) {
        self.homePage = homePage
        self.homeCoordinator = homeCoordinator
        self.frame = frame
        self.proxy = proxy
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
        
        for page in homePage.pages {
            page.objectWillChange.sink { (value) in
                switch page.view {
                case .foryou:
                    if homePage.index.currentIndex == 0 /*&& UIScreen.main.bounds.width != frame.bounds.size.width*/ {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: tabRowHeight + page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                case .authors:
                    if homePage.index.currentIndex == 1 /*&& UIScreen.main.bounds.width != frame.bounds.size.width*/ {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: tabRowHeight + page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                case .books:
                    if homePage.index.currentIndex == 2 /*&& UIScreen.main.bounds.width != frame.bounds.size.width*/ {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: tabRowHeight + page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                case .faith:
                    if homePage.index.currentIndex == 3 /*&& UIScreen.main.bounds.width != frame.bounds.size.width*/ {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: tabRowHeight + page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                case .theme:
                    if homePage.index.currentIndex == 4 /*&& UIScreen.main.bounds.width != frame.bounds.size.width*/ {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: tabRowHeight + page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                }
            }.store(in: &homePage.cancellables)
        }
        
        if let initialViewController = context.coordinator.viewControllers.first {
            pageView.setViewControllers(
                [initialViewController.uiViewController!],
                direction: .forward,
                animated: true,
                completion: { completed in
                    if completed {
                        for (index, viewController) in context.coordinator.viewControllers.enumerated() {
                            if let page = homePage.pages.first(where: { $0.title == viewController.title }),
                               context.coordinator.viewControllers[index].uiViewController == nil {
                                context.coordinator.viewControllers[index].uiViewController = UiHostingController(rootView: page.view.view(pageView: self))
                            }
                        }
                    }
                })
        }
        
        return pageView
    }
    
    public func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
//        DispatchQueue.main.async {
            if let currentViewController = context.coordinator.viewControllers.first(where: { $0.title == homePage.pages[homePage.index.currentIndex].title }), currentViewController.uiViewController == nil {
                let viewController = UiHostingController(
                    rootView: homePage.pages[homePage.index.currentIndex].view.view(pageView: self))
                
                context.coordinator.viewControllers[homePage.index.currentIndex].uiViewController = viewController
            }
            
        uiViewController.setViewControllers(
            [context.coordinator.viewControllers[homePage.index.currentIndex].uiViewController!],
            direction: homePage.index.currentIndex >= homePage.index.previousIndex ? .forward : .reverse,
            animated: true,
            completion: { completed in
                if completed {
                    if frame.bounds.size.height != tabRowHeight + homePage.pages[homePage.index.currentIndex].frame.bounds.size.height &&
                        homePage.pages[homePage.index.currentIndex].frame.bounds.size != .zero {
                        
                        frame.bounds.size = CGSize(
                            width: homePage.pages[homePage.index.currentIndex].frame.bounds.size.width,
                            height: tabRowHeight + homePage.pages[homePage.index.currentIndex].frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                }
            })
//        }
    }
    
    public func makeCoordinator() -> Coordinator {
        if let coordinator = homeCoordinator.coordinator {
            return coordinator
        } else {
            homeCoordinator.coordinator = Coordinator(self)
            return homeCoordinator.coordinator!
        }
    }
    
    public class Coordinator: OlaCoordinator {
        var parent: HomePageViewController
        
        public init(_ pageView: HomePageViewController) {
            parent = pageView
            super.init()
            
            parent.homePage.pages.forEach { viewControllers.append((title: $0.title, nil)) }
            
            viewControllers[0] = (title: parent.homePage.pages[0].title, UiHostingController(rootView: parent.homePage.pages[0].view.view(pageView: parent)))
        }
        
        override public func updateIndex(_ index: Int) {
            super.updateIndex(index)
            parent.homePage.index = (currentIndex: index, previousIndex: parent.homePage.index.currentIndex)
            
            if (parent.homePage.index.currentIndex == 1 || parent.homePage.index.currentIndex == 2) && parent.homePage.pages[parent.homePage.index.currentIndex].frame.bounds.size.height == UIScreen.main.bounds.height {
                LoadingWheel.isShowing(true)
            }
            
            parent.frame.bounds.size = CGSize(
                width: parent.homePage.pages[parent.homePage.index.currentIndex].frame.bounds.size.width,
                height: tabRowHeight + parent.homePage.pages[parent.homePage.index.currentIndex].frame.bounds.size.height)
            
            parent.frame.objectWillChange.send()
        }
    }
}
