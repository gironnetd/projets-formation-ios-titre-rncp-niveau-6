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

public extension RemoteBookmarkGroup {
    func asCached() -> CachedBookmarkGroup {
        CachedBookmarkGroup(
            id: self.id,
            idParent: self.idParent,
            location: .remote,
            directoryName: self.directoryName,
            shortDescription: self.shortDescription,
            groups: self.groups!.map { $0.asCached() }.toList(),
            bookmarks: self.bookmarks != nil ? self.bookmarks!.map { $0.asCached() }.toList() : List<CachedBookmark>())
    }
}

public extension BookmarkGroup {
    func toRemote(uidUser: String) -> RemoteBookmarkGroup {
        RemoteBookmarkGroup(
            id: self.id,
            uidUser: uidUser,
            idParent: self.idParent,
            directoryName: self.directoryName,
            shortDescription: self.shortDescription,
            groups: self.groups.map { $0.toRemote(uidUser: uidUser) },
            bookmarks: self.bookmarks.map { $0.toRemote() })
    }
}

