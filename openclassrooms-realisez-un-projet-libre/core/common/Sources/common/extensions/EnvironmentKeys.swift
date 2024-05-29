//
//  EnvironmentKey+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 28/05/2023.
//

import Foundation
import SwiftUI

///
/// Structure for the GeometryReader EnvironmentKey
///
public struct GeometryReaderKey: EnvironmentKey {
    
    ///
    /// Variable representing the defaultValue for the EnvironmentKey
    ///
    public static var defaultValue: (bounds: CGRect, safeAreaInsets: EdgeInsets) {
        (UIApplication.shared.currentKeyWindow?.bounds ?? CGRect(),
         UIApplication.shared.currentKeyWindow?.safeAreaInsets.olaInsets ?? EdgeInsets())
    }
}

///
/// Structure for the OrientationKey EnvironmentKey
///
public struct OrientationKey: EnvironmentKey {
    
    ///
    /// Variable representing the defaultValue for the EnvironmentKey
    ///
    public static var defaultValue: UIDeviceOrientation {
        let scene = UIApplication.shared.windows.first!.windowScene
        return (scene?.interfaceOrientation.isPortrait)! ? UIDeviceOrientation.portrait : .landscapeLeft
    }
}

