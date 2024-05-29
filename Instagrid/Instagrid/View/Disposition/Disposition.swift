//
//  Disposition.swift
//  Instagrid
//
//  Created by damien on 04/06/2022.
//

import Foundation
import UIKit

@IBDesignable
class Disposition: UIView {

    lazy var photos: [Photo] = []
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet weak var firstPhoto: Photo! {
        didSet {
            photos.append(firstPhoto)
        }
    }
    
    @IBOutlet weak var secondPhoto: Photo! {
        didSet {
            photos.append(secondPhoto)
        }
    }
    
    @IBOutlet weak var thirdPhoto: Photo! {
        didSet {
            photos.append(thirdPhoto)
        }
    }
    
    @IBOutlet weak var fourthPhoto: Photo! {
        didSet {
            photos.append(fourthPhoto)
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
        let bundle = Bundle(for: Disposition.self)
        bundle.loadNibNamed("\(type(of: self))", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
   }
}
