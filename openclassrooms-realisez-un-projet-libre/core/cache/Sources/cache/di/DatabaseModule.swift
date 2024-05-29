//
//  CacheModule.swift
//  cache
//
//  Created by Damien Gironnet on 11/03/2023.
//

import Foundation
import common
import Factory
import RealmSwift
import SwiftUI

///
/// Dependency injection for Realm database
///
//public class DatabaseModule: SharedContainer {
//    
//    public static let queue = Factory(scope: .singleton) {
//        DispatchQueue(label: "serial-background")
//    }
//    
//    public static let configuration = Factory(scope: .singleton) {
//        guard let file = Bundle.cache.url(forResource: "default", withExtension: "realm") else {
//            fatalError("Could not find file in Bundle")
//        }
//        
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            fatalError("Could not access documents directory when setting up Realm")
//        }
//        
//        var realmDirectoryPath = documentsDirectory.appendingPathComponent("realm")
//                
//        do {
//            try FileManager.default.createDirectory(atPath: realmDirectoryPath.path, withIntermediateDirectories: true, attributes: [.protectionKey: FileProtectionType.none])
//        } catch {
//            fatalError("Error creating directory: \(error.localizedDescription)")
//        }
//        
//        var fullDestPath = NSURL(fileURLWithPath: realmDirectoryPath.path).appendingPathComponent("default.realm")
//        var fullDestPathString = fullDestPath?.path
//        
//        do {
//            if !FileManager.default.fileExists(atPath: fullDestPath!.path) {
//                try FileManager.default.copyItem(atPath: file.path, toPath: fullDestPath!.path)
//            }
//            
//            var configuration = Realm.Configuration(fileURL: fullDestPath!, readOnly: false, schemaVersion: 3, deleteRealmIfMigrationNeeded: false)
//            
//            return configuration
//        } catch {
//            fatalError("Failed to load 'in_memory' Realm: \(error)")
//        }
//    }
//    
//    public static let realm = Factory(scope: .singleton) {
//        // swiftlint:disable:next force_try
//        try! Realm(configuration: DatabaseModule.configuration.callAsFunction(), queue: DatabaseModule.queue.callAsFunction()).freeze()
//    }
//}

public extension SharedContainer {
    var queue: Factory<DispatchQueue> { self {
        DispatchQueue(label: "serial-background")
    }.singleton }

    var configuration: Factory<Realm.Configuration> { self {
        guard let file = Bundle.cache.url(forResource: "default", withExtension: "realm") else {
            fatalError("Could not find file in Bundle")
        }
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not access documents directory when setting up Realm")
        }
        
        var realmDirectoryPath = documentsDirectory.appendingPathComponent("realm")
                
        do {
            try FileManager.default.createDirectory(atPath: realmDirectoryPath.path, withIntermediateDirectories: true, attributes: [.protectionKey: FileProtectionType.none])
        } catch {
            fatalError("Error creating directory: \(error.localizedDescription)")
        }
        
        var fullDestPath = NSURL(fileURLWithPath: realmDirectoryPath.path).appendingPathComponent("default.realm")
        var fullDestPathString = fullDestPath?.path
        
        do {
            if !FileManager.default.fileExists(atPath: fullDestPath!.path) {
                try FileManager.default.copyItem(atPath: file.path, toPath: fullDestPath!.path)
            }
            
            var configuration = Realm.Configuration(fileURL: fullDestPath!, readOnly: false, schemaVersion: 3, deleteRealmIfMigrationNeeded: false)
            
            return configuration
        } catch {
            fatalError("Failed to load 'in_memory' Realm: \(error)")
        }
    }.singleton }
    
    var realm: Factory<Realm> { self { [self] in
        // swiftlint:disable:next force_try
        try! Realm(configuration: configuration.callAsFunction(), queue: queue.callAsFunction()).freeze()
    }.singleton }
}
