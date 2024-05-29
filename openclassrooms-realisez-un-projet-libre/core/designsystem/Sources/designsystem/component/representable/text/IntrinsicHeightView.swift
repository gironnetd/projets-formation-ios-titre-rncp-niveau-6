//
//  IntrinsicHeightView.swift
//  designsystem
//
//  Created by Damien Gironnet on 12/02/2023.
//

import UIKit
import Foundation
import SwiftUI
import common

///
/// Class used to calculate height of View extended UIView
///
public class IntrinsicHeightView<ContentView: UIView>: UIView {
    
    @Binding var height: CGFloat
    var contentView: ContentView
    
    init(contentView: ContentView, height: Binding<CGFloat>) {
        self._height = height
        self.contentView = contentView
        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview(contentView)
    }
    
    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var contentHeight: CGFloat = .zero {
        willSet {
                self.height = newValue
                invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: self.contentHeight)
    }
    
    public override var frame: CGRect {
        willSet {
            contentView.frame = self.bounds
            contentView.layoutIfNeeded()
            
            let targetSize = CGSize(width: frame.width, height: UIView.layoutFittingCompressedSize.height)
            
            contentHeight = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            ).height
        }
    }
}
