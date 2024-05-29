//
//  CachedUser.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

///
/// Model used solely for the caching of a user
///
public class CachedUser: Object {
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var providerID: String
    @Persisted public var uidUser: String?
    @Persisted public var email: String?
    @Persisted public var displayName: String?
    @Persisted public var photo: Data?
    
    public override init() {}
    
    public init(id: String,
                providerID: String,
                uidUser: String? = nil,
                email: String? = nil,
                displayName: String? = nil,
                photo: Data? = nil) {
        super.init()
        self.id = id
        self.providerID = providerID
        self.uidUser = uidUser
        self.email = email
        self.displayName = displayName
        self.photo = photo
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let account = object as? CachedUser else {
            return false
        }
        
        return self.id == account.id &&
            self.providerID == account.providerID &&
            self.uidUser == account.uidUser &&
            self.email == account.email &&
            self.displayName == account.displayName
    }
}

extension CachedUser {
    public func asExternalModel() -> model.User {
        User(id: self.id,
             providerID: self.providerID,
             uidUser: self.uidUser,
             email:  self.email,
             displayName: self.displayName,
             photo:  self.photo)
    }
}

extension model.User {
    public func asCached() -> CachedUser {
        CachedUser(id: self.id,
                   providerID: self.providerID,
                   uidUser: self.uidUser,
                   email: self.email,
                   displayName: self.displayName,
                   photo: self.photo)
    }
}
