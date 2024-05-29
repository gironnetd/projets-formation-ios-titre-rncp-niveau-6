//
//  Url.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Url fetched from an external layer data source
///
public struct Url: Equatable {
    
    public var idUrl: String
    public var idSource: String
    public var title: String?
    public var url: String
    public var presentation: String?
    
    public init(idUrl: String,
                idSource: String,
                title: String? = nil,
                url: String,
                presentation: String? = nil) {
        self.idUrl = idUrl
        self.idSource = idSource
        self.title = title
        self.url = url
        self.presentation = presentation
    }
}
