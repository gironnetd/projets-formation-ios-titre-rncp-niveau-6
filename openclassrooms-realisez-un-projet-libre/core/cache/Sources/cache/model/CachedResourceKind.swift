//
//  CachedBookmarkResource.swift
//  cache
//
//  Created by Damien Gironnet on 19/10/2023.
//

import Foundation
import RealmSwift

public enum CachedResourceKind: String, PersistableEnum {
    case author, book, movement, theme, quote, century, picture, biography, url, unknown
}
