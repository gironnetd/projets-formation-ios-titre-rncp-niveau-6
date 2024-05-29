//
//  Orientation.swift
//  common
//
//  Created by Damien Gironnet on 21/02/2023.
//

import Foundation
import SwiftUI

///
/// Class for the Orientation ObservableObject
///
public class Orientation: ObservableObject {
    @Published public var current: UIDeviceOrientation = .portrait
    @Published public var previous: UIDeviceOrientation = .unknown
    
    public static var shared: Orientation = Orientation()
    
    private init() {
        if isPreview {
            current = UIDevice.current.orientation != .unknown ? UIDevice.current.orientation :
            (UIApplication.shared.currentKeyWindow != nil ? (UIApplication.shared.currentKeyWindow!.windowScene!.interfaceOrientation.isPortrait ? (UIDeviceOrientation.portrait) : UIDeviceOrientation.landscapeLeft) : .unknown)
        } else {
            let scene = UIApplication.shared.windows.first!.windowScene
            current = (scene?.interfaceOrientation.isPortrait)! ? .portrait : .landscapeLeft
        }
    }
}
