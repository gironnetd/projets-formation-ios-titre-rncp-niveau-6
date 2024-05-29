//
//  Bookmark.swift
//  data
//
//  Created by Damien Gironnet on 19/10/2023.
//

import Foundation
import cache
import remote
import model
import RealmSwift
import FirebaseFirestore

public extension RemoteBookmark {
    func asCached() -> CachedBookmark {
        CachedBookmark(id: self.id,
                       idBookmarkGroup: self.idBookmarkGroup,
                       note: self.note,
                       idResource: self.idResource,
                       kind: CachedResourceKind(rawValue: self.kind) ?? CachedResourceKind.unknown,
                       dateCreation: self.dateCreation.dateValue())
    }
}

public extension Bookmark {
    func toRemote() -> RemoteBookmark {
        RemoteBookmark(id: self.id,
                       idBookmarkGroup: self.idBookmarkGroup,
                       note: self.note,
                       idResource: self.idResource,
                       kind: self.kind.rawValue,
                       dateCreation: Timestamp(date: self.dateCreation))
    }
}
