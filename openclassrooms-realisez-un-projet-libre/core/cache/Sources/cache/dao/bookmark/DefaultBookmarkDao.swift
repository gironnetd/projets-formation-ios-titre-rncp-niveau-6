//
//  DefaultBookmarkDao.swift
//  cache
//
//  Created by Damien Gironnet on 14/11/2023.
//

import Foundation
import RealmSwift
import Combine
import Factory

public class DefaultBookmarkDao: BookmarkDao {
    
    @LazyInjected(\.realm) internal var realm
    @LazyInjected(\.queue) private var queue
    
    public func findAllBookmarks() -> Future<[CachedBookmark], Error> {
        return Future { promise  in
            do {
                let bookmarks = try self.queue.sync(execute: { () -> [CachedBookmark] in
                    guard let bookmarks = Optional(self.realm.thaw().objects(CachedBookmark.self)) else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    return bookmarks.toArray()
                })
                
                promise(.success(bookmarks.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    public func findAllBookmarkGroups() -> Future<[CachedBookmarkGroup], Error> {
        return Future { promise  in
            do {
                let groups = try self.queue.sync(execute: { () -> [CachedBookmarkGroup] in
                    guard let groups = Optional(self.realm.thaw().objects(CachedBookmarkGroup.self)) else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    return groups.toArray()
                })
                
                promise(.success(groups.map { $0.freeze() }))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    public func createOrUpdate(group: CachedBookmarkGroup) async throws {
        try queue.sync {
            do {
                try realm.thaw().write {
                    guard let bookmarkGroups = Optional(self.realm.thaw().objects(CachedBookmarkGroup.self)) else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    if let toUpdate = bookmarkGroups.first(where: { $0.id == group.id }) {
                        toUpdate.directoryName = group.directoryName
                        toUpdate.shortDescription = group.shortDescription
                        toUpdate.location = group.location
                        
                        realm.thaw().add(toUpdate, update: .modified)
                    } else {
                        realm.thaw().add(group, update: .modified)
                    }
                    
                    try realm.thaw().commitWrite()
                }
            } catch {
                throw error
            }
        }
    }
    
    public func remove(group: CachedBookmarkGroup) async throws {
        try queue.sync {
            do {
                try self.realm.thaw().write { [self] in
                    guard let toDelete = self.realm.thaw().objects(CachedBookmarkGroup.self).first(where: { $0.id == group.id }) else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    self.realm.thaw().delete(toDelete)
                    try self.realm.thaw().commitWrite()
                }
            } catch {
                throw error
            }
        }
    }
    
    public func deleteBookmarkGroups(ids: [String]) async throws {
        try queue.sync {
            do {
                try self.realm.thaw().write { [self] in
                    let bookmarks = self.realm.thaw().objects(CachedBookmarkGroup.self)
                    bookmarks.filter({ ids.contains($0.id) }).forEach({ self.realm.thaw().delete($0) })
                    try self.realm.thaw().commitWrite()
                }
            } catch {
                throw error
            }
        }
    }
    
    public func upsertBookmarkGroups(groups: [CachedBookmarkGroup]) async throws {
        try queue.sync {
            do {
                try self.realm.thaw().write { [self] in
                    guard let cachedGroups = Optional(self.realm.thaw().objects(CachedBookmarkGroup.self)) else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    groups.forEach { group in
                        if cachedGroups.contains(where: { $0.id == group.id }) {
                              if let cachedGroup = self.realm.thaw().objects(CachedBookmarkGroup.self)
                                .first(where: { $0.id == group.id }) {
                                cachedGroup.directoryName = group.directoryName
                                cachedGroup.shortDescription = group.shortDescription
                                cachedGroup.groups = group.groups
                                
                                for bookmark in cachedGroup.bookmarks.toArray()
                                    .filter({ !group.bookmarks.map { $0.id }.contains($0.id) }) {
                                    if let index = cachedGroup.bookmarks.firstIndex(of: bookmark) {
                                        cachedGroup.bookmarks.remove(at: index)
                                    }
                                }
                                
                                cachedGroup.bookmarks.append(objectsIn: group.bookmarks
                                    .filter { !cachedGroup.bookmarks.map { $0.id }.contains($0.id) })
                                
                                for bookmark in group.bookmarks
                                    .filter({ cachedGroup.bookmarks.map { $0.id }.contains($0.id) } ) {
                                    if let index = cachedGroup.bookmarks.firstIndex(where: { $0.id == bookmark.id }),
                                       let cachedBookmark = self.realm.thaw().objects(CachedBookmark.self)
                                        .first(where: { $0.id == bookmark.id }) {
                                        cachedBookmark.note = bookmark.note
                                        cachedGroup.bookmarks.replace(index: index, object: cachedBookmark)
                                    }
                                }
                                
                                realm.thaw().add(cachedGroup, update: .modified)
                            }
                        } else {
                            realm.thaw().add(group, update: .modified)
                        }
                    }
                    try self.realm.thaw().commitWrite()
                }
            } catch {
                throw error
            }
        }
    }
    
    public func updateResourceBookmarked(bookmark: CachedBookmark, bookmarked: Bool) async throws {
        try queue.sync {
            do {
                try realm.thaw().write { [self] in
                    guard let bookmarkGroup = self.realm.thaw().objects(CachedBookmarkGroup.self).first(where: { $0.id == bookmark.idBookmarkGroup }) else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    if bookmarked { bookmarkGroup.bookmarks.append(bookmark) }
                    else {
                        guard let index = bookmarkGroup.bookmarks.firstIndex(where: { $0.id == bookmark.id }) else {
                            throw Realm.Error(Realm.Error.fail)
                        }
                        
                        bookmarkGroup.bookmarks.remove(at: index)
                        
//                        if let toDelete = self.realm.thaw().objects(CachedBookmark.self)
//                            .first(where: { toDelete in  toDelete.id == bookmark.id }) {
//                            self.realm.thaw().delete(toDelete)
//                        }
                        
                        if self.realm.thaw().objects(CachedBookmarkGroup.self).toArray().flatMap({ $0.bookmarks })
                            .allSatisfy({ $0.idResource != bookmark.idResource }) {
                            if let toDelete = self.realm.thaw().objects(CachedBookmark.self).first(where: { toDelete in  toDelete.id == bookmark.id }) {
                                self.realm.thaw().delete(toDelete)
                            }
                        }
                    }
                    
                    realm.thaw().add(bookmarkGroup, update: .modified)
                    try realm.thaw().commitWrite()
                }
            } catch {
                throw error
            }
        }
    }
    
    public func update(bookmark: CachedBookmark) async throws {
        try queue.sync {
            do {
                try realm.thaw().write {
                    guard let cachedBookmark = self.realm.thaw().objects(CachedBookmark.self).first(where: { $0.id == bookmark.id })
                    else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    cachedBookmark.note = bookmark.note
                    
                    realm.thaw().add(cachedBookmark, update: .modified)                    
                    try realm.thaw().commitWrite()
                }
            } catch {
                throw error
            }
        }
    }
}
