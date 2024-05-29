//
//  BookmarkDao.swift
//  cache
//
//  Created by Damien Gironnet on 14/11/2023.
//

import Foundation
import Combine

public protocol BookmarkDao {
    
    /// Retrieve all authors, from the cache
    ///
    /// - Returns: An Array of ``CachedBookmark`` or throws an Error
    func findAllBookmarks() -> Future<[CachedBookmark], Error>
    
    /// Retrieve all authors, from the cache
    ///
    /// - Returns: An Array of ``CachedBookmarkGroup`` or throws an Error
    func findAllBookmarkGroups() -> Future<[CachedBookmarkGroup], Error>
    
    func updateResourceBookmarked(bookmark: CachedBookmark, bookmarked: Bool) async throws
    
    func createOrUpdate(group: CachedBookmarkGroup) async throws
    
    func remove(group: CachedBookmarkGroup) async throws
    
    func update(bookmark: CachedBookmark) async throws
    
    func deleteBookmarkGroups(ids: [String]) async throws
    
    func upsertBookmarkGroups(groups: [CachedBookmarkGroup]) async throws
}



