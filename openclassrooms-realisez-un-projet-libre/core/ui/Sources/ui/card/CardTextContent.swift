//
//  CardTextContent.swift
//  ui
//
//  Created by Damien Gironnet on 25/04/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

///
/// Structure representing card text content
///
public struct CardTextContent: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
    
    @State public var height: CGFloat = .zero
    
    private let text: String
    private let width: CGFloat
    
    public init(text: String, width: CGFloat = UIScreen.main.bounds.width - 80) {
        self.text = text
        self.width = width
    }
    
    public var body: some View {
        LabelAlignment(
            text: text,
            textAlignmentStyle: .justified, width: width,
            textStyle: TypographyTokens.BodyLarge,
            textColor: $localColorScheme.onPrimaryContainer)
    }
}

struct LabelAlignment: UIViewRepresentable {
    var text: String
    var textAlignmentStyle : TextAlignmentStyle
    var width: CGFloat
    var textStyle: AnyTextStyle
    @Binding var textColor: Color
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.minimumLineHeight = self.textStyle.lineHeight.rawValue * self.textStyle.scaledMetric
        paragraphStyle.maximumLineHeight = self.textStyle.lineHeight.rawValue * self.textStyle.scaledMetric
        
        let attributedString = NSMutableAttributedString(string: self.text)
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: self.textStyle.customFont.uiFont, range: NSMakeRange(0, attributedString.length))
        
        label.attributedText = attributedString
        
        label.numberOfLines = 0
        label.textAlignment = .justified
        
        label.textColor = textColor.uiColor()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.preferredMaxLayoutWidth = width
        
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
    
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
        
    }
}

enum TextAlignmentStyle : Int{
     case left = 0 ,center = 1 , right = 2 ,justified = 3 ,natural = 4
}
