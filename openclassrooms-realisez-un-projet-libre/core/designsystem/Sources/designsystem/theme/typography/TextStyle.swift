//
//  TextStyle.swift
//  designsystem
//
//  Created by damien on 20/12/2022.
//

import Foundation
import SwiftUI

///
/// Custom Configuration for Text style
///
public struct TextStyleConfiguration {
    
    public struct Text {
        
        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required `body` property.
        public typealias Body = SwiftUI.Text
    }
    
    let text: TextStyleConfiguration.Text.Body
}

///
/// Protocol defining properties and method for Text style
///
public protocol TextStyle {
    associatedtype Body: View
    
    typealias Configuration = TextStyleConfiguration
    
    var customFont: Typography.CustomFont { get set }
    var fontColor: UIColor { get set }
    var fontSize: TypeScaleTokens.Size { get set }
    var scaledMetric: CGFloat { get set }
    var lineHeight: TypeScaleTokens.LineHeight { get set }
    var letterSpacing: TypeScaleTokens.Tracking { get set }
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

///
/// Extension to implement TextStyle methods
///
extension TextStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.text
            .kerning(letterSpacing.rawValue)
            .font(Font(customFont.uiFont))
            .lineSpacing(lineHeight.rawValue - customFont.uiFont.lineHeight)
            .padding(.vertical, (lineHeight.rawValue - customFont.uiFont.lineHeight) / 2)
    }
}

///
/// Extension for SwiftUI Text
///
public extension Text {
    func textStyle<S>(_ style: S) -> some View where S: TextStyle {
        let configuration = TextStyleConfiguration(text: self)
        return style.makeBody(configuration: configuration)
    }
}
