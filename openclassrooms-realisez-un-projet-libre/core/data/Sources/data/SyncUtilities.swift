//
//  SyncUtilities.swift
//  data
//
//  Created by Damien Gironnet on 08/11/2023.
//

import Foundation
import preferences
import remote
import common

public protocol Synchronizer {
    func getChangeBookmarkVersions() async throws -> ChangeBookmarkVersions
    
    func getUidUser() async throws -> String?
    
    func updateChangeBookmarkVersions(update: @escaping (ChangeBookmarkVersions) -> ChangeBookmarkVersions) async throws
}

public extension Syncable {
    func sync(_ synchronizer: Synchronizer) async throws -> Bool {
        try await self.syncWith(synchronizer: synchronizer)
    }
}

/**
 * Interface marker for a class that is synchronized with a remote source. Syncing must not be
 * performed concurrently and it is the [Synchronizer]'s responsibility to ensure this.
 */
public protocol Syncable {
    
    /**
     * Synchronizes the local database backing the repository with the network.
     * Returns if the sync was successful or not.
     */
    func syncWith(synchronizer: Synchronizer) async throws -> Bool
}

public extension Synchronizer {
    func changeBookmarkSync(
        versionReader: (ChangeBookmarkVersions) -> Int,
        changeBookmarksFetcher: (String, Int) async throws -> [RemoteChangeBookmark],
        versionUpdater: @escaping (Int) -> ChangeBookmarkVersions,
        modelDeleter: ([String]) async throws -> Void,
        modelUpdater: ([String]) async throws -> Void) async throws -> Bool {
            do {
                // Fetch the change list since last sync (akin to a git fetch)
                let currentVersion = try await versionReader(getChangeBookmarkVersions())
                
                guard let uidUser = try await getUidUser() else {
                    return true
                }
                let changeBookmarks = try await changeBookmarksFetcher(uidUser, currentVersion)
                if changeBookmarks.isEmpty { return true }
                
                let (deleted, updated) = changeBookmarks.partition({ $0.isDelete })
                
                // Delete models that have been deleted server-side
                try await modelDeleter(deleted.map({ $0.id }))
                
                // Using the change list, pull down and save the changes (akin to a git pull)
                try await modelUpdater(updated.map({ $0.id }))
                
                // Update the last synced version (akin to updating local git HEAD)
                if let latestVersion = changeBookmarks.last?.changeBookmarkVersion {
                    try await updateChangeBookmarkVersions { _ in
                        versionUpdater(latestVersion)
                    }
                } else { return false }
                
                return true
            } catch {
                return false
            }
        }
}
