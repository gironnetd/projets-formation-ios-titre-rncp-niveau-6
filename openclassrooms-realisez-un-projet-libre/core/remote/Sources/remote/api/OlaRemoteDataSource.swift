//
//  OlaRemoteDataSource.swift
//  remote
//
//  Created by damien on 26/09/2022.
//

import Foundation
import Combine

///
/// Protocol defining methods for the Remote Data.
///
public protocol OlaRemoteDataSource {
    
    func enablOffline(enabled: Bool)
    
    /// Retrieve an User from its identifier UUID, from remote
    ///
    /// - Parameters:
    ///   - uuid: The identifier of the User
    ///
    /// - Returns: An AnyPublisher returning an ``RemoteUser`` or an Error
    func findUser(byUid uid: String) async throws -> RemoteUser
    
    /// Save or update an User to the cache
    ///
    /// - Parameters:
    ///   - user: A Void or throws an Error
    func saveOrUpdate(user: RemoteUser) async throws
    
    /// Delete a User
    ///
    /// - Parameters:
    ///   - uid: The user to delete
    func deleteUser(byUid uid: String) async throws
    
    func createOrUpdate(bookmark: RemoteBookmark) async throws
    
    func remove(bookmark: RemoteBookmark) async throws
    
    func createOrUpdate(group: RemoteBookmarkGroup) async throws
    
    func remove(group: RemoteBookmarkGroup) async throws
    
    func findBookmarksChanged(uidUser: String, after: Int) async throws -> [RemoteChangeBookmark]
    
    func findBookmarks(ids: [String]) async throws -> [RemoteBookmarkGroup]
}
