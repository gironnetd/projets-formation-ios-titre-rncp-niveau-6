//
//  SyncWorker.swift
//  work
//
//  Created by Damien Gironnet on 08/11/2023.
//

import Foundation
import data
import preferences
import common
import analytics
import data
import Factory

public class SyncWorker: Operation, Synchronizer {
    
    @LazyInjected(\.olaPreferences) private var olaPreferences
    @LazyInjected(\.analyticsHelper) private var analyticsHelper
    @LazyInjected(\.syncSubscriber) private var syncSubscriber
    @LazyInjected(\.bookmarkRepository) private var bookmarkRepository
    
    public override func main() {
        Task {
            DispatchQueue.main.async { self.analyticsHelper.logSyncStarted() }
            
            await syncSubscriber.subscribe()
            
            let syncedSuccessfully = try await bookmarkRepository.sync(self)
            
            DispatchQueue.main.async { self.analyticsHelper.logSyncFinished(syncedSuccessfully) }
        }
    }
    
    public func getChangeBookmarkVersions() async throws -> ChangeBookmarkVersions {
        olaPreferences.getChangeBookmarkVersions()
    }
    
    public func getUidUser() async throws -> String? {
        olaPreferences.uidUser
    }
    
    public func updateChangeBookmarkVersions(update: @escaping (ChangeBookmarkVersions) -> ChangeBookmarkVersions) async throws {
        olaPreferences.updateChangeBookmarkVersions(update: update)
    }
    
    public static func startUpSyncWork() {
        let queue = OperationQueue()
        queue.addOperations([SyncWorker()], waitUntilFinished: true)
    }
}
