//
//  CachedBookmark.swift
//  cache
//
//  Created by Damien Gironnet on 19/10/2023.
//

import Foundation
import RealmSwift
import model

public enum CachedBookmarkGroupLocation: String, PersistableEnum {
    case remote, device, shared
}

public class CachedBookmarkGroup: Object {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var idParent: String?
    @Persisted public var location: CachedBookmarkGroupLocation
    @Persisted public var directoryName: String
    @Persisted public var shortDescription: String?
    @Persisted public var groups: List<CachedBookmarkGroup>
    @Persisted public var bookmarks: List<CachedBookmark>
    
    public override init() {}
    
    public init(id: String,
                idParent: String? = nil,
                location: CachedBookmarkGroupLocation,
                directoryName: String,
                shortDescription: String? = nil,
                groups: List<CachedBookmarkGroup>,
                bookmarks: List<CachedBookmark>) {
        super.init()
        self.id = id
        self.idParent = idParent
        self.location = location
        self.directoryName = directoryName
        self.shortDescription = shortDescription
        self.groups = groups
        self.bookmarks = bookmarks
    }
}

extension CachedBookmarkGroup {
    public func asExternalModel() -> BookmarkGroup {
        BookmarkGroup(
            id: self.id,
            idParent: self.idParent,
            location: BookmarkGroupLocation(rawValue: self.location.rawValue) ?? .device,
            directoryName: self.directoryName,
            shortDescription: self.shortDescription ?? "",
            groups: self.groups.map { $0.asExternalModel() },
            bookmarks: self.bookmarks.map { $0.asExternalModel() })
    }
}

extension BookmarkGroup {
    public func asCached() -> CachedBookmarkGroup {
        CachedBookmarkGroup(
            id: self.id,
            idParent: self.idParent,
            location: CachedBookmarkGroupLocation(rawValue: self.location.rawValue) ?? .device,
            directoryName: self.directoryName,
            shortDescription: self.shortDescription,
            groups: self.groups.map { $0.asCached() }.toList(),
            bookmarks: self.bookmarks.map { $0.asCached() }.toList())
    }
}
