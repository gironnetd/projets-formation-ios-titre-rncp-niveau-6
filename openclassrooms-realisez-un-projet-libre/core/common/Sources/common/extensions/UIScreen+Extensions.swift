//
//  UIScreen+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 20/02/2023.
//

import Foundation
import SwiftUI

///
/// Variable returning a Boolean to know if the Device is a Table or not
///
public var isTablet: Bool {
    UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
        UIScreen.main.traitCollection.verticalSizeClass == .regular
}

///
/// Extension for the UIScreen Class
///
public extension UIScreen {
    
    ///
    /// Static variable returning the inches of the screen
    ///
    static var inches: Double {
//        let ppi: Double = {
//            switch Ppi.get() {
//            case .success(let ppi):
//                return ppi
//            case .unknown(let bestGuessPpi, _):
//                return bestGuessPpi
//            }
//        }()
//        
//        let screenBounds = UIScreen.main.bounds
//        let screenScale = UIScreen.main.scale
//        _ = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)
//        
//        let width = (screenBounds.size.width * screenScale)
//        let height = (screenBounds.size.height * screenScale)
//        
//        let horizontal = width / ppi, vertical = height / ppi
//        let diagonal = sqrt(pow(horizontal, 2) + pow(vertical, 2))
//                
//        return Double(round(10.0 * diagonal) / 10)
        
        let scale = UIScreen.main.scale
        let ppi = scale * ((UIDevice.current.userInterfaceIdiom == .pad) ? 132 : 163);
        
        let width = UIScreen.main.bounds.size.width * scale
        let height = UIScreen.main.bounds.size.height * scale
        
        let horizontal = width / ppi, vertical = height / ppi;
        
        let diagonal = sqrt(pow(horizontal, 2) + pow(vertical, 2))
//        let screenSize = String(format: "%0.1f", diagonal)
        return diagonal
    }
}
