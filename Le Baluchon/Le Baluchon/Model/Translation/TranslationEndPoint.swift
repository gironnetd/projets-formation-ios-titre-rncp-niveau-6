//
//  TranslationEndPoint.swift
//  Le Baluchon
//
//  Created by damien on 13/07/2022.
//

import Foundation

//
// MARK: - Translation EndPoint
//
enum TranslationEndPoint: String, EndPoint {
   case translate = ""
   case detect = "/detect"
   case languages = "/languages"
}
