//
//  ThemeTextFieldStyle.swift
//  designsystem
//
//  Created by Damien Gironnet on 12/02/2023.
//

import SwiftUI
import common
import model
import FloatingLabelTextFieldSwiftUI

///
/// FloatingLabelTextFieldStyle for FloatingLabelTextField
///
public struct ThemeTextFieldStyle: FloatingLabelTextFieldStyle {
    
    private var localColorScheme: OlaColorScheme
    
    public init(localColorScheme: OlaColorScheme) {
        self.localColorScheme = localColorScheme
    }
    
    public func body(content: FloatingLabelTextField) -> FloatingLabelTextField {
        if #available(iOS 16, *) {
            return content
                .spaceBetweenTitleText(CGFloat(22.0).adjustHeight())
                .textAlignment(.leading)
                .lineHeight(CGFloat(1.0).adjustHeight())
                .selectedLineHeight(CGFloat(1.0).adjustHeight())
                .lineColor(localColorScheme.primary)
                .selectedLineColor(localColorScheme.primary)
                .titleColor(localColorScheme.primary)
                .selectedTitleColor(localColorScheme.primary)
                .titleFont(Font(TypographyTokens.LabelLarge.customFont.uiFont))
                .textColor(localColorScheme.onPrimaryContainer)
                .selectedTextColor(localColorScheme.onPrimaryContainer)
                .textFont(Font(TypographyTokens.LabelLarge.customFont.uiFont))
                .placeholderColor(localColorScheme.primary)
                .placeholderFont(Font(TypographyTokens.TitleSmall.customFont.uiFont))
                .errorColor(localColorScheme.error)
                .addDisableEditingAction([.all])
                .enablePlaceholderOnFocus(true)
        } else {
            return content
                .spaceBetweenTitleText(CGFloat(22.0).adjustHeight())
                .textAlignment(.leading)
                .lineHeight(0)
                .selectedLineHeight(0)
                .titleColor(localColorScheme.primary)
                .selectedTitleColor(localColorScheme.primary)
                .titleFont(Font(TypographyTokens.LabelLarge.customFont.uiFont))
                .textColor(localColorScheme.onPrimaryContainer)
                .selectedTextColor(localColorScheme.onPrimaryContainer)
                .textFont(Font(TypographyTokens.LabelLarge.customFont.uiFont))
                .placeholderColor(localColorScheme.primary)
                .placeholderFont(Font(TypographyTokens.TitleSmall.customFont.uiFont))
                .errorColor(localColorScheme.error)
                .addDisableEditingAction([.all])
                .enablePlaceholderOnFocus(true)
        }
    }
}
