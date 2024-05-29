//
//  CachedResource.swift
//  cache
//
//  Created by damien on 01/10/2019.
//  Copyright © 2019 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

///
/// Enum used solely for representing the caching different resource topic of the application
///
public enum CachedResourceTopic: String, PersistableEnum {
    case author, book, movement, theme, century, none
}

public enum CachedResourceCategory: String, PersistableEnum {
    case author, book, movement, theme, quote, picture, biography, url, none
}

public class CachedBookmark: Object {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var idBookmarkGroup: String
    @Persisted public var note: String?
    @Persisted public var idResource: String
    @Persisted public var kind: CachedResourceKind
    @Persisted public var dateCreation: Date
    
    public override init() {}
    
    public init(id: String,
                idBookmarkGroup: String,
                note: String? = nil,
                idResource: String,
                kind: CachedResourceKind,
                dateCreation: Date) {
        super.init()
        self.id = id
        self.idBookmarkGroup = idBookmarkGroup
        self.note = note
        self.idResource = idResource
        self.kind = kind
        self.dateCreation = dateCreation
    }
}

extension CachedBookmark {
    public func asExternalModel() -> Bookmark {
        Bookmark(
            id: self.id,
            idBookmarkGroup: self.idBookmarkGroup,
            note: self.note ?? "",
            idResource: self.idResource,
            kind: ResourceKind(rawValue: self.kind.rawValue) ?? ResourceKind.unknown,
            dateCreation: self.dateCreation)
    }
}

extension Bookmark {
    public func asCached() -> CachedBookmark {
        CachedBookmark(
            id: self.id,
            idBookmarkGroup: self.idBookmarkGroup,
            note: self.note,
            idResource: self.idResource,
            kind: CachedResourceKind(rawValue: self.kind.rawValue) ?? CachedResourceKind.unknown,
            dateCreation: self.dateCreation)
    }
}

