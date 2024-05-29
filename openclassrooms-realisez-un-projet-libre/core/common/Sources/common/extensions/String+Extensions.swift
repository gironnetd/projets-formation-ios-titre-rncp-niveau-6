//
//  String+Extensions.swift
//  common
//
//  Created by damien on 07/12/2022.
//

import Foundation
import SwiftUI

///
/// Extension for the String Structure
///
public extension String {
    
    /// Function allowing to localize String for several Bundle across the packages of application
    ///
    /// - Returns: A localized String
    func localizedString(identifier: String, bundle: Bundle) -> String {
        if isPreview {
            guard let path = bundle.path(forResource: identifier, ofType: "lproj"),
                  let localizedBundle = Bundle(path: path) else {
                return NSLocalizedString(self, bundle: bundle, comment: "")
            }
            return NSLocalizedString(self, bundle: localizedBundle, comment: "")
        }
        return bundle.localizedString(forKey: self, value: nil, table: "Localizable")
    }
    
    /// Property to check if String is not empty
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
