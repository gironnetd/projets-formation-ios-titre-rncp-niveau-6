//
//  SyncInitializer.swift
//  work
//
//  Created by Damien Gironnet on 08/11/2023.
//

import Foundation

public class Sync {
    public init() {}
    
    public static func initialize() {
        SyncWorker.startUpSyncWork()
    }
}
