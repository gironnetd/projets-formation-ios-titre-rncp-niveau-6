//
//  UIImage+Extensions.swift
//  common
//
//  Created by Damien Gironnet on 02/09/2023.
//

import Foundation
import UIKit

public func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
    let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
    let cropped:UIImage = UIImage(cgImage:imageRef)
    return cropped
}

public extension CGImage {
    var isDark: Bool {
        get {
            guard let imageData = self.dataProvider?.data else { return false }
            guard let ptr = CFDataGetBytePtr(imageData) else { return false }
            let length = CFDataGetLength(imageData)
            let threshold = Int(Double(self.width))
            var darkPixels = 0
            for i in stride(from: 0, to: length, by: 4) {
                let r = ptr[i]
                let g = ptr[i + 1]
                let b = ptr[i + 2]
                let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                if luminance < 170 {
                    darkPixels += 1
                    if darkPixels > threshold {
                        return true
                    }
                }
            }
            return false
        }
    }
}

public extension UIImage {
    var isDark: Bool {
        get {
            return self.cgImage!.isDark
        }
    }
}
