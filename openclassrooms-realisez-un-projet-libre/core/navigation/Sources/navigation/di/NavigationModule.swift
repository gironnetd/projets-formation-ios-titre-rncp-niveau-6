//
//  NavigationModule.swift
//  navigation
//
//  Created by Damien Gironnet on 01/03/2023.
//

import Foundation
import Factory
import UIKit

///
/// Dependency injection for Navigation module
///
//public class NavigationModule: SharedContainer {
//    public static let mainViewController = Factory(scope: .singleton) { UIViewController() }
//    public static let mainRouter = Factory(scope: .singleton) { MainRouter() }
//}

public extension SharedContainer {
    var mainViewController: Factory<UIViewController> { self { UIViewController() }.singleton }
    var mainRouter: Factory<MainRouter> { self { MainRouter() }.singleton }
}
