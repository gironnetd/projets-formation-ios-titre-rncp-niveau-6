//
//  WorkManagerSyncManager.swift
//  work
//
//  Created by Damien Gironnet on 14/11/2023.
//

import Foundation
import data
import Combine
import Factory
import analytics

public class WorkManagerSyncManager: SyncManager {
    
    @LazyInjected(\.analyticsHelper) private var analyticsHelper
    @LazyInjected(\.bookmarkRepository) private var bookmarkRepository
    
    public var isSyncing: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    public func requestSync() {}
}


