//
//  FirestoreRemoteDataSource.swift
//  remote
//
//  Created by damien on 26/09/2022.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Factory
import common

/**
 * Default Implementation for the Remote Data Protocol.
 */
public class FirestoreRemoteDataSource: OlaRemoteDataSource {
    
    private let firestore: Firestore
    
    public func enablOffline(enabled: Bool) {
        if enabled { firestore.disableNetwork() }
        else { firestore.enableNetwork() }
    }
    
    public init() {
        self.firestore = Firestore.firestore()
        
        if !UserDefaults.standard.bool(forKey: "isTesting") {
            let settings = FirestoreSettings()

            // Use memory-only cache
            settings.cacheSettings = MemoryCacheSettings(garbageCollectorSettings: MemoryLRUGCSettings())

            // Use persistent disk cache, with 100 MB cache size
            settings.cacheSettings = PersistentCacheSettings(sizeBytes: NSNumber(value: FirestoreCacheSizeUnlimited))
            
            self.firestore.settings = settings
            
            Firestore.enableLogging(true)
        }
    }
    
    /// Retrieve an User from its identifier UUID, from remote
    ///
    /// - Parameters:
    ///   - uuid: The identifier of the user
    ///
    /// - Returns: An AnyPublisher returning an ``RemoteUser`` or an Error
    public func findUser(byUid uid: String) async throws -> RemoteUser {
        var user = try await firestore.collection(Constants.USERS_TABLE).document(uid).getDocument().data(as: RemoteUser.self)
        
        let groups = try await firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).whereField("uidUser", isEqualTo: uid).getDocuments()
   
        if groups.documents.isNotEmpty { user.bookmarks = [] }
        
        for document in groups.documents {
            let group = try document.data(as: RemoteBookmarkGroup.self)
            
            if !group.isDelete {
                let bookmarks = try await firestore.collection(Constants.BOOKMARKS_TABLE).whereField("idBookmarkGroup", isEqualTo: group.id).getDocuments()
                
                if bookmarks.documents.isNotEmpty { group.bookmarks = [] }
                
                for document in bookmarks.documents {
                    group.bookmarks!.append(try document.data(as: RemoteBookmark.self))
                }
                
                user.bookmarks!.append(group)
            }
        }
        
        return user
    }

    /// Save or update an User to the cache
    ///
    /// - Parameters:
    ///   - user: A ``RemoteUser``
    public func saveOrUpdate(user: RemoteUser) async throws {
        let document = try await firestore.collection(Constants.USERS_TABLE).document(user.uid).getDocument()
        try await document.reference.setData(user.dictionary as [String : Any], merge: true)
    }
    
    /// Delete an User to remote
    ///
    /// - Parameters:
    ///   - uuid: The UUID of the user
    public func deleteUser(byUid uid: String) async throws {
        let document = try await firestore.collection(Constants.USERS_TABLE).document(uid).getDocument()
        
        guard let user = try? document.data(as: RemoteUser.self) else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        
        try await document.reference.delete()
        let queriesSnapshot = try await self.firestore.collection(Constants.BOOKMARK_GROUPS_TABLE)
            .whereField("uidUser", isEqualTo: user.uid).getDocuments()
        
        for queryDocumentSnapshot in queriesSnapshot.documents {
            try await queryDocumentSnapshot.reference.delete()
        }
    }
    
    public func createOrUpdate(bookmark: RemoteBookmark) async throws {
        try await firestore.collection(Constants.BOOKMARKS_TABLE).document(bookmark.id).setData(bookmark.dictionary as [String : Any], merge: true)

        if !UserDefaults.standard.bool(forKey: "isTesting") {
            try await createOrUpdate(group: try await firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).document(bookmark.idBookmarkGroup).getDocument().data(as: RemoteBookmarkGroup.self))
        }
    }
    
    public func remove(bookmark: RemoteBookmark) async throws {
        try await firestore.collection(Constants.BOOKMARKS_TABLE).document(bookmark.id).delete()
        
        try await createOrUpdate(group: try await firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).document(bookmark.idBookmarkGroup).getDocument().data(as: RemoteBookmarkGroup.self))
    }
    
    public func createOrUpdate(group: RemoteBookmarkGroup) async throws {
        let document = try await firestore.collection(Constants.BOOKMARK_GROUPS_TABLE)
            .document(group.id).getDocument()
        
        let latestChangeBookmarkVersions = try await firestore.collection(Constants.BOOKMARK_GROUPS_TABLE)
            .whereField("uidUser", isEqualTo: group.uidUser)
            .getDocuments().documents.map { try $0.data(as: RemoteBookmarkGroup.self) }
            .sorted(by: { $0.changeBookmakGroupVersion > $1.changeBookmakGroupVersion })
            .first?.changeBookmakGroupVersion
        
        do {
            if let latestChangeBookmarkVersions = latestChangeBookmarkVersions {
                group.changeBookmakGroupVersion = latestChangeBookmarkVersions + 1
            } else {
                group.changeBookmakGroupVersion = try document.data(as: RemoteBookmarkGroup.self).changeBookmakGroupVersion + 1
            }
            
            try await document.reference.setData(group.dictionary as [String : Any], merge: true)
        } catch {
            if let latestChangeBookmarkVersions = latestChangeBookmarkVersions {
                group.changeBookmakGroupVersion = latestChangeBookmarkVersions + 1
            } else {
                group.changeBookmakGroupVersion += 1
            }
            
            try await document.reference.setData(group.dictionary as [String : Any], merge: true)
        }
    }
    
    public func remove(group: RemoteBookmarkGroup) async throws {
        let document = try await firestore.collection(Constants.BOOKMARK_GROUPS_TABLE)
            .document(group.id).getDocument()
        
        let remotedGroup = try document.data(as: RemoteBookmarkGroup.self)
        remotedGroup.isDelete = true
        
        try await createOrUpdate(group: remotedGroup)
    }
    
    public func findBookmarksChanged(uidUser: String, after: Int = 0) async throws -> [RemoteChangeBookmark] {
        do {
            let documents = try await firestore.collection(Constants.BOOKMARK_GROUPS_TABLE)
                .whereField("uidUser", isEqualTo: uidUser)
                .whereField("changeBookmakGroupVersion", isGreaterThan: after)
                .order(by: "changeBookmakGroupVersion")
                .getDocuments().documents
            
            if documents.isEmpty { return [] }
                        
            if documents.isNotEmpty {
                return try documents.map({ try $0.data(as: RemoteBookmarkGroup.self) })
                    .map({ RemoteChangeBookmark(id: $0.id, changeBookmarkVersion: $0.changeBookmakGroupVersion, isDelete: $0.isDelete) })
            } else { return [] }
        } catch { throw error }
    }
    
    public func findBookmarks(ids: [String]) async throws -> [RemoteBookmarkGroup] {
        let groups = try await firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).getDocuments()
            .documents.map { try $0.data(as: RemoteBookmarkGroup.self) }.filter({ ids.contains($0.id) })
        
        for (index, group) in groups.enumerated() {
            let bookmarks = try await firestore.collection(Constants.BOOKMARKS_TABLE).whereField("idBookmarkGroup", isEqualTo: group.id).getDocuments()
            
            if bookmarks.documents.isNotEmpty { groups[index].bookmarks = [] }
            
            for document in bookmarks.documents {
                groups[index].bookmarks!.append(try document.data(as: RemoteBookmark.self))
            }
        }
        
        return groups
    }
}
