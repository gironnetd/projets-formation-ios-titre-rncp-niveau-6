//
//  UIEdgeInsets+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 28/05/2023.
//

import Foundation
import SwiftUI

///
/// Extension for UIEdgeInsets
///
internal extension UIEdgeInsets {
    
    ///
    /// EdgeInsets for the application
    ///
    var olaInsets: EdgeInsets {
        EdgeInsets(top: top, leading: (left != 0.0 ? left : 16.0), bottom: bottom, trailing: (right != 0.0 ? right : 16.0))
    }
}
