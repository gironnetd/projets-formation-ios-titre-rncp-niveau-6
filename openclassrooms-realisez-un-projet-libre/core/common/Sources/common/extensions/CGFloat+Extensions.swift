//
//  CGFloat+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 11/03/2023.
//

import Foundation
import SwiftUI

///
/// Extension for the CGFloat structure
///
public extension CGFloat {
    
    /// Function adjusting width depending on resolution screen
    func adjustWidth() -> CGFloat {
        self * (UIScreen.main.scale == 3.0 ? 1.0 : UIScreen.main.nativeBounds.width / 1290 * (3 / UIScreen.main.nativeScale))
        * (UIScreen.main.nativeBounds.width) / (UIScreen.main.nativeScale  == 3.0 ? 1290 : 750)
    }
    
    /// Function adjusting height depending on resolution screen
    func adjustHeight() -> CGFloat {
        self * (UIScreen.main.scale == 3.0 ? 1.0 : UIScreen.inches > 4.7 ?
                UIScreen.main.nativeBounds.width / 1290 * (
                    isTablet ? 0.85 : 3 / UIScreen.main.nativeScale) : UIScreen.main.nativeBounds.height / 1334)
        * (UIScreen.main.nativeBounds.width) / (UIScreen.main.nativeScale  == 3.0 ? 1290 : UIScreen.main.nativeBounds.width)
    }
    
    /// Function adjusting image depending on resolution screen
    func adjustImage() -> CGFloat {
        self * (UIScreen.main.scale == 3.0  ? 1.0 : UIScreen.main.nativeBounds.width / 1290 *
                (isTablet ? 0.87 : 3 / UIScreen.main.nativeScale))
        * (UIScreen.main.nativeBounds.width) / (UIScreen.main.nativeScale  == 3.0 ? 1290 : UIScreen.main.nativeBounds.width)
    }
    
    /// Function adjusting the size of the font depending on resolution screen
    func adjustFontSize() -> CGFloat {
        self * (UIScreen.main.scale == 3.0 ? 1.0 : UIScreen.main.nativeBounds.width / 1290 *
                (isTablet ? 1.55 / UIScreen.main.nativeScale : 3 / UIScreen.main.nativeScale)
        )
        * (UIScreen.main.nativeBounds.width) / (UIScreen.main.nativeScale  == 3.0 ? 1290 : UIScreen.main.nativeBounds.width)
    }
    
    /// Function adjusting the line height of the font depending on resolution screen
    func adjustFontLineHeight() -> CGFloat {
        self * (UIScreen.main.scale == 3.0 ? 1.0 : UIScreen.main.nativeBounds.width / 1290 *
                (isTablet ? 1.55 / UIScreen.main.nativeScale : 3 / UIScreen.main.nativeScale))
        * (UIScreen.main.nativeBounds.width) / (UIScreen.main.nativeScale  == 3.0 ? 1290 : UIScreen.main.nativeBounds.width)
    }
    
    /// Function adjusting the horizontal padding depending on resolution screen
    func adjustHorizontalPadding() -> CGFloat {
        self * (UIScreen.main.scale == 3.0 ? 1.0 : UIScreen.main.nativeBounds.width / 1290 *
                (isTablet ? 1.5 : 3 / UIScreen.main.nativeScale))
    }
    
    /// Function adjusting the vertical padding depending on resolution screen
    func adjustVerticalPadding() -> CGFloat {
        self * (UIScreen.main.scale == 3.0 ? 1.0 : UIScreen.main.nativeBounds.height / 2796 *
                (isTablet ? 1.2 : 3 / UIScreen.main.nativeScale))
    }
    
    /// Function adjusting the padding depending on resolution screen
    func adjustPadding() -> CGFloat {
        self * (UIScreen.main.scale == 3.0 ? 1.0 : UIScreen.main.nativeBounds.width / 1290 *
                (isTablet ? 0.85 : 3 / UIScreen.main.nativeScale))
    }
    
    /// Function adjusting the corner radius depending on resolution screen
    func adjustCornerRadius() -> CGFloat {
        self * (UIScreen.main.scale == 3.0 ? 1.0 : UIScreen.main.nativeBounds.width / 1290 *
                (isTablet ? 1.2 : 3 / UIScreen.main.nativeScale))
    }
}
