//
//  Arrangement.swift
//  Instagrid
//
//  Created by damien on 01/06/2022.
//

import UIKit

@IBDesignable
class Arrangement: UIButton {

    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var arrangement: UIImageView!
    @IBOutlet private weak var arrangementSelected: UIImageView! {
        didSet {
            arrangementSelected.isHidden = !isArrangementSelected
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: Arrangement.self)
        bundle.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBInspectable
    var image: UIImage {
        get {return self.arrangement.image ?? UIImage(named: "Layout 1")! }
        set { self.arrangement.image = newValue }
    }
    
    @IBInspectable
    var isArrangementSelected: Bool {
        get {
            return !arrangementSelected.isHidden
        }
        set {
            if let arrangementSelected = arrangementSelected {
                arrangementSelected.isHidden = !newValue
                setNeedsDisplay()
            }
        }
    }
}
