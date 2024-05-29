//
//  User.swift
//  data
//
//  Created by damien on 04/10/2022.
//

import Foundation
import cache
import remote
import model
import RealmSwift

extension RemoteUser {
    public func asCached() -> CachedUser {
        CachedUser(id: self.uid,
                   providerID: self.providerID,
                   uidUser: self.uid,
                   email: self.email,
                   displayName: self.displayName,
                   photo: self.photo)
    }
}

extension model.User {
    public func toRemote() -> RemoteUser {
        RemoteUser(uid: self.id,
                   providerID: self.providerID,
                   email: self.email,
                   displayName: self.displayName,
                   photo: self.photo,
                   bookmarks: self.bookmarks.map { $0.toRemote(uidUser: self.id) })
    }
}
