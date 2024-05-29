//
//  TestBookmarkRepository.swift
//  testing
//
//  Created by Damien Gironnet on 13/12/2023.
//

import Foundation
import data
import remote
import model
import Combine

///
/// Implementation of AuthorRepository Protocol for Testing
///
public class TestBookmarkRepository: BookmarkRepository {
    
    public var groups: [BookmarkGroup]
    
    public init() { self.groups = [] }
    
    public init(groups: [BookmarkGroup]) {
        self.groups = groups
    }
    
    public func findAllBookmarks() -> AnyPublisher<[model.Bookmark], Error> {
        Future { promise in
            guard self.groups.flatMap({ $0.bookmarks }).isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(self.groups.flatMap({ $0.bookmarks })))
        }.eraseToAnyPublisher()
    }
    
    public func findAllBookmarkGroups() -> AnyPublisher<[model.BookmarkGroup], Error> {
        Future { promise in
            guard self.groups.isNotEmpty else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
            
            promise(.success(self.groups))
        }.eraseToAnyPublisher()
    }
    
    public func updateResourceBookmarked(bookmark: model.Bookmark, bookmarked: Bool) async throws {
        if let index = groups.firstIndex(where: { $0.id == bookmark.idBookmarkGroup }),
           let bookmarkIndex = groups[index].bookmarks.firstIndex(where: { $0.id == bookmark.id }), !bookmarked {
            groups[index].bookmarks.remove(at: bookmarkIndex)
        } else if let index = groups.firstIndex(where: { $0.id == bookmark.idBookmarkGroup }) {
            groups[index].bookmarks.append(bookmark)
        }
    }
    
    public func createOrUpdate(group:BookmarkGroup) async throws {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index] = group
        } else { groups.append(group) }
    }
    
    public func remove(group: BookmarkGroup) async throws {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups.remove(at: index)
        }
    }
    
    public func update(bookmark: Bookmark) async throws {
        if let index = groups.firstIndex(where: { $0.id == bookmark.idBookmarkGroup }),
           let bookmarkIndex = groups[index].bookmarks.firstIndex(where: { $0.id == bookmark.id }){
            groups[index].bookmarks[bookmarkIndex] = bookmark
        }
    }
    
    public func syncWith(synchronizer: data.Synchronizer) async throws -> Bool { true }
}
