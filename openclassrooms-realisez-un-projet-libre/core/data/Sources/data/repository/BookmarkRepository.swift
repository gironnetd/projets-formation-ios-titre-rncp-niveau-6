//
//  BookmarkRepository.swift
//  data
//
//  Created by Damien Gironnet on 14/11/2023.
//

import Foundation
import Combine
import model
import remote

public protocol BookmarkRepository: Syncable {
    
    /// Retrieve all authors, from the cache
    ///
    /// - Returns: An Array of ``Bookmark`` or throws an Error
    func findAllBookmarks() -> AnyPublisher<[Bookmark], Error>
    
    /// Retrieve all authors, from the cache
    ///
    /// - Returns: An Array of ``BookmarkGroup`` or throws an Error
    func findAllBookmarkGroups() -> AnyPublisher<[BookmarkGroup], Error>
    
    func updateResourceBookmarked(bookmark: Bookmark, bookmarked: Bool) async throws
    
    func createOrUpdate(group: BookmarkGroup) async throws
    
    func remove(group: BookmarkGroup) async throws
    
    func update(bookmark: Bookmark) async throws
}
