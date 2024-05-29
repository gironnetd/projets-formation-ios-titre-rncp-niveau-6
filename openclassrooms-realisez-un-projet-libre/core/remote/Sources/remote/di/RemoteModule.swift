//
//  RemoteModule.swift
//  remote
//
//  Created by Damien Gironnet on 30/03/2023.
//

import Foundation
import Factory
import Firebase

///
/// Dependency injection for Remote module
///
//public class RemoteModule: SharedContainer {
//    
//    internal static let authentication = Factory<OlaRemoteAuthentication>(scope: .singleton) {
//        if let path = Bundle.remote.url(forResource: "GoogleService-Info", withExtension: "plist"),
//           let firbaseOptions = FirebaseOptions(contentsOfFile: path.path) {
//            if FirebaseApp.app() == nil {
//                FirebaseApp.configure(options: firbaseOptions)
//            }
//        }
//        return FirebaseRemoteAuthentication()
//    }
//    
//    public static let firestore = Factory<OlaRemoteDataSource>(scope: .singleton) {
//        if let path = Bundle.remote.url(forResource: "GoogleService-Info", withExtension: "plist"),
//           let firbaseOptions = FirebaseOptions(contentsOfFile: path.path) {
//            if FirebaseApp.app() == nil {
//                FirebaseApp.configure(options: firbaseOptions)
//            }
//        }
//        
//        return FirestoreRemoteDataSource()
//    }
//    
//    public static let firebase = Factory<OlaRemoteFirebase>(scope: .singleton) { DefaultOlaRemoteFirebase() }
//}

public extension SharedContainer {
    var authentication: Factory<OlaRemoteAuthentication> {
        self {
            if let path = Bundle.remote.url(forResource: "GoogleService-Info", withExtension: "plist"),
               let firbaseOptions = FirebaseOptions(contentsOfFile: path.path) {
                if FirebaseApp.app() == nil {
                    FirebaseApp.configure(options: firbaseOptions)
                }
            }
            return FirebaseRemoteAuthentication()
        }.singleton
    }
    
    var firestore: Factory<OlaRemoteDataSource> {
        self {
            if let path = Bundle.remote.url(forResource: "GoogleService-Info", withExtension: "plist"),
               let firbaseOptions = FirebaseOptions(contentsOfFile: path.path) {
                if FirebaseApp.app() == nil {
                    FirebaseApp.configure(options: firbaseOptions)
                }
            }
            return FirestoreRemoteDataSource()
        }.singleton
    }
    
    var firebase: Factory<OlaRemoteFirebase> { self { DefaultOlaRemoteFirebase() }.singleton }

}
