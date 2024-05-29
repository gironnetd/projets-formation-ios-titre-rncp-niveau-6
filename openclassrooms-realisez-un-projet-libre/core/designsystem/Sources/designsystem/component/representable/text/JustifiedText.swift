//
//  JustifiedText.swift
//  designsystem
//
//  Created by damien on 02/01/2023.
//

import UIKit
import Foundation
import SwiftUI
import common

///
/// UIViewRepresentable used to represent justified text
///
public struct JustifiedText: UIViewRepresentable {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
    @Binding var height: CGFloat
    @Binding var textColor: Color
    private let text: String
    private let limitLine: Int
    private let textStyle: AnyTextStyle
    
    public init(_ text: String, limitLine: Int = 0, textStyle: AnyTextStyle, textColor: Binding<Color>, height: Binding<CGFloat>) {
        self.text = text
        self.limitLine = limitLine
        self.textStyle = textStyle
        self._textColor = textColor
        self._height = height
    }
    
    public func makeUIView(context: Context) -> IntrinsicHeightView<UILabelView> {
        return IntrinsicHeightView(contentView: UILabelView(text: text, limitLine: limitLine, textColor: textColor, textStyle: textStyle), height: $height)
    }
    
    public func updateUIView(_ uiView: IntrinsicHeightView<UILabelView>, context: Context) {
        uiView.contentView.label.textColor = colorScheme == .light ? localColorScheme.onPrimaryContainer.uiColor() : localColorScheme.onPrimaryContainer.uiColor()
    }
}
