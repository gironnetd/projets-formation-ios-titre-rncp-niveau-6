//
//  SwipeLabel.swift
//  Instagrid
//
//  Created by damien on 07/06/2022.
//

import UIKit

@IBDesignable
class SwipeLabel: UILabel {
    
    @IBInspectable var fontSize: CGFloat = 26.0
    @IBInspectable var fontFamily: String = "Delm-Medium"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
    }
    
    private func commonInit() {
        let attrString = NSMutableAttributedString(attributedString: self.attributedText!)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
