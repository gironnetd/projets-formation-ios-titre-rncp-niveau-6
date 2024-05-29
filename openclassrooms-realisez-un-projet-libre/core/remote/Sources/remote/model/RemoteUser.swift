//
//  RemoteUser.swift
//  remote
//
//  Created by damien on 23/09/2022.
//

import Foundation
import FirebaseAuth
import model

///
/// Remote Representation for a User
///
public struct RemoteUser: Codable, Equatable {
    
    public var uid: String
    public var providerID: String
    public var email: String?
    public var displayName: String?
    public var photo: Data?
    public var bookmarks: [RemoteBookmarkGroup]?
    
    public init(uid: String,
                providerID: String,
                email: String?,
                displayName: String?,
                photo: Data?,
                bookmarks: [RemoteBookmarkGroup]?) {
        self.uid = uid
        self.providerID = providerID
        self.email = email
        self.displayName = displayName
        self.photo = photo
        self.bookmarks = bookmarks
    }
    
    enum CodingKeys: String, CodingKey {
        case uid
        case providerID
        case email
        case displayName
    }
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "providerID": providerID,
            "email": email as Any,
            "displayName": displayName as Any
        ]
    }
    
    public static func == (lhs: RemoteUser, rhs: RemoteUser) -> Bool {
         return lhs.uid == rhs.uid &&
                lhs.providerID == rhs.providerID &&
                lhs.email == rhs.email &&
                lhs.displayName == rhs.displayName
    }
}
