//
//  WorkModule.swift
//  work
//
//  Created by Damien Gironnet on 14/11/2023.
//

import Foundation
import Factory
import data

///
/// Dependency injection for Work module
///
//public class WorkModule: SharedContainer {
//    public static let syncManager = Factory<SyncManager>(scope: .singleton) { WorkManagerSyncManager() }
//    public static let syncSubscriber = Factory<SyncSubscriber>(scope: .singleton) { StubSyncSubscriber() }
//}

public extension SharedContainer {
    var syncManager: Factory<SyncManager> { self { WorkManagerSyncManager() }.singleton }
    var syncSubscriber: Factory<SyncSubscriber> { self { StubSyncSubscriber() }.singleton }
}
