//
//  UIApplication+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 28/05/2023.
//

import Foundation
import SwiftUI

///
/// Extension for UIApplication Class
///
public extension UIApplication {
    
    ///
    /// Variable retruning the key window
    ///
    var currentKeyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}
