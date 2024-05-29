//
//  EnvironmentValues+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 12/02/2023.
//

import Foundation
import SwiftUI

///
/// Extension for EnvironmentValues
///
public extension EnvironmentValues {
    
    ///
    /// Variable allowing to know if the context is in Preview mode or not
    ///
    var geometry: (bounds: CGRect, safeAreaInsets: EdgeInsets) {
        self[GeometryReaderKey.self]
    }
    
    ///
    /// Variable allowing to know if the context is in Preview mode or not
    ///
    var orientation: UIDeviceOrientation {
        self[OrientationKey.self]
    }
}
