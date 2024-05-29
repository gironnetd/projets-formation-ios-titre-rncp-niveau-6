//
//  User.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation
import Combine

///
/// Representation for a User fetched from an external layer data source
///
public class User: Equatable, ObservableObject {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id &&
        lhs.providerID == rhs.providerID &&
        lhs.email == rhs.email &&
        lhs.displayName == rhs.displayName &&
        lhs.bookmarks == rhs.bookmarks
    }
    
    public let id: String
    public var providerID: String
    public var uidUser: String?
    public var email: String?
    public var displayName: String?
    public var photo: Data?
    @Published public var bookmarks: [BookmarkGroup]
    
    public init(id: String,
                providerID: String,
                uidUser: String?,
                email: String? = nil,
                displayName: String? = nil,
                photo: Data? = nil,
                bookmarks: [BookmarkGroup] = []) {
        self.id = id
        self.providerID = providerID
        self.uidUser = uidUser
        self.email = email
        self.displayName = displayName
        self.photo = photo
        self.bookmarks = bookmarks
    }
}
