//
//  Century.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Century fetched from an external layer data source
///
public struct Century: Equatable {
    
    public var idCentury: String
    public var century: String
    public var presentations: [String : String]?
    public var topics: [Topic]?
    
    public init(idCentury: String,
                century: String,
                presentations: [String : String]? = nil,
                topics: [Topic]? = nil) {
        self.idCentury = idCentury
        self.century = century
        self.presentations = presentations
        self.topics = topics
    }
}
