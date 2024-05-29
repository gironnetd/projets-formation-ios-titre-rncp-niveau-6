//
//  MainPageViewController.swift
//  main
//
//  Created by Damien Gironnet on 11/06/2023.
//

import SwiftUI
import UIKit
import Combine
import home
import bookmarks
import settings
import designsystem
import model

///
/// Enum aiming to return Main screen views
///
public enum MainViews: String, CaseIterable, Views {
    
    case home, bookmark, settings
    
    @ViewBuilder
    func view(pageView: MainPageViewController) -> some View {
        switch self {
        case .home:
            HomeView(frame: pageView.mainPage.pages[0].frame, proxy: pageView.proxy)
        case .bookmark:
            BookmarkView(frame: pageView.mainPage.pages[1].frame, proxy: pageView.proxy)
        case .settings:
            SettingsView(frame: pageView.mainPage.pages[2].frame)
        }
    }
}

///
/// Class used to wrap Authors screen with their title
///
class MainPage: Pages<MainViews> {
    private var proxy: GeometryProxy?
    
    init(currentIndex: Int, previousIndex: Int, pages: [Page<MainViews>]) {
        super.init(currentIndex: currentIndex, previousIndex: previousIndex)
        self.pages = pages
        self.pages.forEach { $0.frame.bounds.size.height = UIScreen.main.bounds.height }
    }
}

internal class MainCoordinator {
    var coordinator: MainPageViewController.Coordinator?
}

///
/// UIViewControllerRepresentable for Main PageViewController
///
public struct MainPageViewController: UIViewControllerRepresentable {
    @ObservedObject fileprivate var mainPage: MainPage
    @ObservedObject var frame: Frame
    @ObservedObject internal var proxy: Proxy
    
    private let mainCoordinator: MainCoordinator
        
    init(mainPage: MainPage,
         frame: Frame,
         proxy: Proxy,
         mainCoordinator: MainCoordinator) {
        self.mainPage = mainPage
        self.mainCoordinator = mainCoordinator
        self.frame = frame
        self.proxy = proxy
    }
    
    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageView = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        pageView.delegate = context.coordinator
        pageView.dataSource = nil
        
        for page in mainPage.pages {
            page.objectWillChange.sink { (value) in
                switch page.view {
                case .home:
                    if mainPage.index.currentIndex == 0 {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                case .bookmark:
                    if mainPage.index.currentIndex == 1 {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                case .settings:
                    if mainPage.index.currentIndex == 2 {
                        frame.bounds.size = CGSize(
                            width: page.frame.bounds.size.width,
                            height: page.frame.bounds.size.height)
                        frame.objectWillChange.send()
                    }
                }
            }.store(in: &mainPage.cancellables)
        }
        
        if let initialViewController = context.coordinator.viewControllers.first {
            pageView.setViewControllers(
                [initialViewController.uiViewController!],
                direction: .forward,
                animated: false)
        }
        
        return pageView
    }
    
    public func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.setViewControllers(
                [context.coordinator.viewControllers[mainPage.index.currentIndex].uiViewController!],
                direction: mainPage.index.currentIndex >= mainPage.index.previousIndex ? .forward : .reverse,
                animated: false,
                completion: { completed in
                    if completed {
                        if frame.bounds.size.height != mainPage.pages[mainPage.index.currentIndex].frame.bounds.size.height &&
                            mainPage.pages[mainPage.index.currentIndex].frame.bounds.size != .zero {
                            
                            frame.bounds.size = mainPage.pages[mainPage.index.currentIndex].frame.bounds.size
                            
                            frame.bounds.size = CGSize(
                                width: mainPage.pages[mainPage.index.currentIndex].frame.bounds.size.width,
                                height: mainPage.pages[mainPage.index.currentIndex].frame.bounds.size.height)
                            
                            frame.objectWillChange.send()
                        }
                    }
                })
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        if let coordinator = mainCoordinator.coordinator {
            return coordinator
        } else {
            mainCoordinator.coordinator = Coordinator(self)
            return mainCoordinator.coordinator!
        }
    }
    
    public class Coordinator: OlaCoordinator {
        var parent: MainPageViewController
        
        public init(_ pageView: MainPageViewController) {
            parent = pageView
            super.init()
            
            parent.mainPage.pages.forEach {
                viewControllers.append(
                    (title: $0.title,
                     UiHostingController(rootView: $0.view.view(pageView: parent))))
            }
        }
        
        override public func updateIndex(_ index: Int) {
            super.updateIndex(index)
            parent.mainPage.index = (currentIndex: index, previousIndex: parent.mainPage.index.currentIndex)
            
            parent.frame.bounds.size = CGSize(
                width: parent.mainPage.pages[parent.mainPage.index.currentIndex].frame.bounds.size.width,
                height: parent.mainPage.pages[parent.mainPage.index.currentIndex].frame.bounds.size.height)
            
            parent.frame.objectWillChange.send()
        }
    }
}
