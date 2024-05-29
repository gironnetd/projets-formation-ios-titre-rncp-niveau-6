//
//  DeviceRotationViewModifier.swift
//  common
//
//  Created by damien on 22/01/2023.
//

import Foundation
import SwiftUI

public struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    public func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                
                switch scene.interfaceOrientation {
                case .portrait: action(UIDeviceOrientation.portrait)
                case .landscapeLeft: action(UIDeviceOrientation.landscapeLeft)
                case .portraitUpsideDown: action(UIDeviceOrientation.portraitUpsideDown)
                case .landscapeRight: action(UIDeviceOrientation.landscapeRight)
                default :
                    if scene.interfaceOrientation.isPortrait {
                        action(UIDeviceOrientation.portrait)
                    } else {
                        action(UIDeviceOrientation.landscapeLeft)
                    }
                }
            }
    }
}

public extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
