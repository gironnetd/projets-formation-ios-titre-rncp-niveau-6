//
//  TestBookmarkDao.swift
//  dataTests
//
//  Created by Damien Gironnet on 13/12/2023.
//

import Foundation
import Combine
import cache

class TestBookmarkDao: BookmarkDao {
    
    internal var groups: [CachedBookmarkGroup] = []
    
    func findAllBookmarks() -> Future<[cache.CachedBookmark], Error> {
        Future { promise in
            guard self.groups.flatMap({ $0.bookmarks }).isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.groups.flatMap({ $0.bookmarks })))
        }
    }
    
    func findAllBookmarkGroups() -> Future<[cache.CachedBookmarkGroup], Error> {
        Future { promise in
            guard self.groups.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            promise(.success(self.groups))
        }
    }
    
    func updateResourceBookmarked(bookmark: CachedBookmark, bookmarked: Bool) async throws {
        if let index = groups.firstIndex(where: { $0.id == bookmark.idBookmarkGroup }),
           let bookmarkIndex = groups[index].bookmarks.firstIndex(where: { $0.id == bookmark.id }), !bookmarked {
            groups[index].bookmarks.remove(at: bookmarkIndex)
        } else if let index = groups.firstIndex(where: { $0.id == bookmark.idBookmarkGroup }) {
            groups[index].bookmarks.append(bookmark)
        }
    }
    
    func createOrUpdate(group: CachedBookmarkGroup) async throws {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index] = group
        } else { groups.append(group) }
    }
    
    func remove(group: CachedBookmarkGroup) async throws {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups.remove(at: index)
        }
    }
    
    func update(bookmark: CachedBookmark) async throws {
        if let index = groups.firstIndex(where: { $0.id == bookmark.idBookmarkGroup }),
           let bookmarkIndex = groups[index].bookmarks.firstIndex(where: { $0.id == bookmark.id }){
            groups[index].bookmarks[bookmarkIndex] = bookmark
        }
    }
    
    func deleteBookmarkGroups(ids: [String]) async throws {
        ids.forEach { id in
            if let index = groups.firstIndex(where: { $0.id == id }) {
                groups.remove(at: index)
            }
        }
    }
    
    func upsertBookmarkGroups(groups: [CachedBookmarkGroup]) async throws {
        self.groups.append(contentsOf: groups)
    }
}
