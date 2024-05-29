//
//  MainRouter.swift
//  navigation
//
//  Created by damien on 06/12/2022.
//

import Foundation
//import ui

///
/// ObservableObject representing the Router of application
///
public class MainRouter: ObservableObject {

    public var visibleScreen: MainNavigation {
        willSet {
            if case .main = newValue  {
                if previousScreen.count == 2 {
                    previousScreen.removeLast()
                }
            }
            
            if case .content(_, let returnToPrevious) = newValue {
                if !returnToPrevious {
                    previousScreen.append(newValue)
                } else {
                    previousScreen.removeLast()
                }
            }
            
            objectWillChange.send()
        }
    }
    
    @Published public var previousScreen: [MainNavigation] = [.main]
        
    public init() {
        self.visibleScreen = .splash
        
        DispatchQueue.main.asyncAfter(deadline: .now() + MainNavigation.NavigationDuration) {
            self.visibleScreen = .main
        }
    }
}
