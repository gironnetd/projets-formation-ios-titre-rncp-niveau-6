//
//  OlaCoordinator.swift
//  designsystem
//
//  Created by Damien Gironnet on 20/07/2023.
//

import Foundation
import UIKit

///
/// Class used to represent Coordinator for PageViewController in application
///
open class OlaCoordinator: NSObject {
    
    public var viewControllers: [(title: String, uiViewController: UIViewController?)] = []
            
    open func updateIndex(_ index: Int) {}
}

extension OlaCoordinator: UIPageViewControllerDataSource {
    
    open func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let index = viewControllers.map({ $0.uiViewController }).firstIndex(of: viewController) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        
        return viewControllers.map { $0.uiViewController }[index - 1]
    }
    
    open func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let index = viewControllers.map({ $0.uiViewController }).firstIndex(of: viewController) else {
            return nil
        }
        
        if index + 1 == viewControllers.count {
            return nil
        }
        
        return viewControllers.map { $0.uiViewController }[index + 1]
    }
        
    open func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool)
    {
        if completed,
           let visibleViewController = pageViewController.viewControllers?.first,
           let index = viewControllers.map({ $0.uiViewController }).firstIndex(of: visibleViewController) {
            updateIndex(index)
        }
    }
}

extension OlaCoordinator: UIPageViewControllerDelegate {}

extension OlaCoordinator: UIScrollViewDelegate {}

extension OlaCoordinator: UIGestureRecognizerDelegate {}
