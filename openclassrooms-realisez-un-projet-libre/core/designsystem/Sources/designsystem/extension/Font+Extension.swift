//
//  Font+Extension.swift
//  designsystem
//
//  Created by damien on 29/12/2022.
//

import Foundation
import SwiftUI

///
/// Extension for SwiftUI Font
///
public extension Font {
  init(_ uiFont: UIFont) {
      self = Font(uiFont as CTFont)
  }
}
