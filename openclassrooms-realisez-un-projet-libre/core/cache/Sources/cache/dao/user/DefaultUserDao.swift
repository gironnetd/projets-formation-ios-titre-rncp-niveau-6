//
//  DefaultUserDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import Combine
import Factory

///
/// Implementation for the ``CachedUser`` Dao Protocol
///
public class DefaultUserDao: UserDao {
    
    @LazyInjected(\.queue) private var queue
    @LazyInjected(\.realm) internal var realm
    
    public var user: CurrentValueSubject<CachedUser, Error>!
    
    internal init() {
        do {
            let user = try self.queue.sync(execute: { () -> CachedUser in
                guard let currentUser = self.realm.thaw().objects(CachedUser.self).first else {
                    throw Realm.Error(Realm.Error.fail)
                }
                
                return currentUser
            })
                
            self.user = CurrentValueSubject(user.freeze())
        } catch {}
    }
    
    public func findCurrentUser() -> Future<CachedUser, Error> {
        return Future { promise  in
            do {
                let user = try self.queue.sync(execute: { () -> CachedUser in
                    guard let currentUser = self.realm.thaw().objects(CachedUser.self).first else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    return currentUser
                })
                
                promise(.success(user.freeze()))
            } catch {
                promise(.failure(Realm.Error(Realm.Error.fail)))
            }
        }
    }
    
    /// Save or update current user to the cache
    ///
    /// - Parameters:
    ///   - currentUser: A ``CachedUser`
    public func saveOrUpdate(currentUser: CachedUser) async throws {
        try queue.sync {
            do {
                try realm.thaw().write {
                    guard let user = self.realm.thaw().objects(CachedUser.self).first else {
                        throw Realm.Error(Realm.Error.fail)
                    }
                    
                    user.providerID = currentUser.providerID
                    user.displayName = currentUser.displayName
                    user.email = currentUser.email
                    user.photo = currentUser.photo
                    user.uidUser = currentUser.uidUser
                    
                    realm.thaw().add(user, update: .modified)
                    try realm.thaw().commitWrite()
                }
            } catch (let error) {
                throw error
            }
        }
    }
    
    /// Delete current user to the cache
    public func deleteCurrentUser() async throws {
        do {
            try queue.sync {
                do {
                    try realm.thaw().write {
                        guard let currentUser = self.realm.thaw().objects(CachedUser.self).first else {
                            throw Realm.Error(Realm.Error.fail)
                        }
                        
                        currentUser.providerID = ""
                        currentUser.displayName = nil
                        currentUser.email = nil
                        currentUser.photo = nil
                        currentUser.uidUser = nil
                        
                        let remotedBookmarks = self.realm.thaw().objects(CachedBookmarkGroup.self).toArray().filter({ $0.location == .remote })
                        
                        if remotedBookmarks.isNotEmpty {
                            for remotedBookmark in remotedBookmarks {
                                remotedBookmark.bookmarks.forEach { self.realm.thaw().delete($0) }
                                self.realm.thaw().delete(remotedBookmark)
                            }
                        }
                        
                        realm.thaw().add(currentUser, update: .modified)
                        try realm.thaw().commitWrite()
                    }
                } catch (let error) {
                    throw error
                }
            }
        } catch {
            throw error
        }
    }
    
//    public func createOrUpdate(group: CachedBookmarkGroup) async throws {
//        try queue.sync {
//            do {
//                try realm.thaw().write {
//                    if let toUpdate = self.realm.thaw().objects(CachedBookmarkGroup.self).first(where: { $0.id == group.id }) {
//                        toUpdate.directoryName = group.directoryName
//                        toUpdate.shortDescription = group.shortDescription
//                        toUpdate.location = group.location
//                        
//                        realm.thaw().add(toUpdate, update: .modified)
//                    } else {
//                        realm.thaw().add(group, update: .modified)
//                    }
//                    
//                    try realm.thaw().commitWrite()
//                }
//            } catch {
//                throw error
//            }
//        }
//    }
//    
//    public func remove(group: CachedBookmarkGroup) async throws {
//        try queue.sync {
//            do {
//                try self.realm.thaw().write { [self] in
//                    guard let toDelete = self.realm.thaw().objects(CachedBookmarkGroup.self).first(where: { $0.id == group.id }) else {
//                        throw Realm.Error(Realm.Error.fail)
//                    }
//                    
//                    self.realm.thaw().delete(toDelete)
//                    try self.realm.thaw().commitWrite()
//                }
//            } catch {
//                throw error
//            }
//        }
//    }
//    
//    public func updateResourceBookmarked(bookmark: CachedBookmark, bookmarked: Bool) async throws {
//        try queue.sync {
//            do {
//                try realm.thaw().write { [self] in
//                    guard let group = self.realm.thaw().objects(CachedBookmarkGroup.self).first(where: { $0.id == bookmark.idBookmarkGroup }) else {
//                        throw Realm.Error(Realm.Error.fail)
//                    }
//                    
//                    if bookmarked {
//                        if let toAppend = self.realm.thaw().objects(CachedBookmark.self).first(where: { $0.id == bookmark.id }){
//                            group.bookmarks.append(toAppend)
//                        } else {
//                            group.bookmarks.append(bookmark)
//                        }
//                    } else {
//                        guard let index = group.bookmarks.firstIndex(where: { $0.id/*Resource*/ == bookmark.id/*Resource*/ }) else {
//                            throw Realm.Error(Realm.Error.fail)
//                        }
//                        
//                        group.bookmarks.remove(at: index)
//                    }
//                    
//                    try realm.thaw().commitWrite()
//                }
//            } catch {
//                throw error
//            }
//        }
//    }
//    
//    public func update(bookmark: CachedBookmark) async throws {
//        try queue.sync {
//            do {
//                try realm.thaw().write {
//                    guard let cachedResource = self.realm.thaw().objects(CachedBookmark.self).first(where: { $0.id == bookmark.id })
//                    else {
//                        throw Realm.Error(Realm.Error.fail)
//                    }
//                    
//                    cachedResource.note = bookmark.note
//                    
//                    realm.thaw().add(cachedResource, update: .modified)
//                    
//                    try realm.thaw().commitWrite()
//                }
//            } catch {
//                throw error
//            }
//        }
//    }
}
