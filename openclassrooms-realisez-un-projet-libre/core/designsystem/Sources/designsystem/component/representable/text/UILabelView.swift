//
//  UILabelView.swift
//  designsystem
//
//  Created by Damien Gironnet on 12/02/2023.
//

import UIKit
import Foundation
import SwiftUI

///
/// Class representing justified UILabel
///
public class UILabelView: UIView {
    
    public var label: UILabel!
    private let text: String
    private let textStyle: AnyTextStyle
    
    required init(text: String, limitLine: Int = 0, textColor: Color, textStyle: AnyTextStyle) {
        self.text = text
        self.textStyle = textStyle
        super.init(frame: CGRect.zero)
        
        backgroundColor = .clear
        label = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.minimumLineHeight = self.textStyle.lineHeight.rawValue * self.textStyle.scaledMetric
        paragraphStyle.maximumLineHeight = self.textStyle.lineHeight.rawValue * self.textStyle.scaledMetric
        
        let attributedString = NSMutableAttributedString(string: self.text)
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: self.textStyle.customFont.uiFont, range: NSMakeRange(0, attributedString.length))
        
        label.attributedText = attributedString
        
        label.numberOfLines = limitLine
        label.textAlignment = .justified
        
        label.textColor = textColor.uiColor()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.preferredMaxLayoutWidth = self.frame.size.width
        
        addSubview(label)
        
        addConstraints([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        label.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
