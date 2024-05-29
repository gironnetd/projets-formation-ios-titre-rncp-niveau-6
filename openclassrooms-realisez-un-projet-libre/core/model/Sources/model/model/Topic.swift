//
//  Topic.swift
//  model
//
//  Created by Damien Gironnet on 16/04/2023.
//

import Foundation

///
/// Representation for a Topic fetched from an external layer data source
///
public struct Topic: Equatable {
    
    public let id: String
    public let language: String
    public let name: String
    public let shortDescription: String?
    public let longDescription: String?
    public let idResource: String
    public let kind: ResourceKind
    
    public init(id: String,
                language: String,
                name: String,
                shortDescription: String? = nil,
                longDescription: String? = nil,
                idResource: String,
                kind: ResourceKind) {
        self.id = id
        self.language = language
        self.idResource = idResource
        self.name = name
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.kind = kind
    }
}
