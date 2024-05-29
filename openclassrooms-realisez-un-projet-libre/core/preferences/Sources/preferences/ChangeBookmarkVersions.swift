//
//  ChangeBookmarkVersions.swift
//  preferences
//
//  Created by Damien Gironnet on 08/11/2023.
//

import Foundation

public struct ChangeBookmarkVersions {
    public var bookmarkVersion: Int
    
    public init(_ bookmarkVersion: Int = -1) {
        self.bookmarkVersion = bookmarkVersion
    }
}
