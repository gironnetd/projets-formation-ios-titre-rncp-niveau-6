//
//  Resource.swift
//  model
//
//  Created by Damien Gironnet on 19/10/2023.
//

import Foundation

///
/// Representation for a ResourceTopic fetched from an external layer data source
///
public class Bookmark: Equatable, Hashable, ObservableObject  {
    public static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
        lhs.id == rhs.id &&
        lhs.idBookmarkGroup == rhs.idBookmarkGroup &&
        lhs.note == rhs.note &&
        lhs.idResource == rhs.idResource
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(idBookmarkGroup)
        hasher.combine(note)
        hasher.combine(idResource)
    }
    
    public let id: String
    public var idBookmarkGroup: String
    @Published public var note: String
    public var idResource: String
    public var kind: ResourceKind
    public var dateCreation: Date
    
    public init(id: String, idBookmarkGroup: String, note: String = "", idResource: String, kind: ResourceKind, dateCreation: Date) {
        self.id = id
        self.idBookmarkGroup = idBookmarkGroup
        self.note = note
        self.idResource = idResource
        self.kind = kind
        self.dateCreation = dateCreation
    }
}
