//
//  RemoteBookmark.swift
//  remote
//
//  Created by Damien Gironnet on 19/10/2023.
//

import Foundation

public class RemoteBookmarkGroup: Codable, Equatable {
    public static func == (lhs: RemoteBookmarkGroup, rhs: RemoteBookmarkGroup) -> Bool {
        lhs.id == rhs.id &&
        lhs.idParent == rhs.idParent &&
        lhs.groups == rhs.groups &&
        lhs.directoryName == rhs.directoryName &&
        lhs.shortDescription == rhs.shortDescription &&
        lhs.changeBookmakGroupVersion == rhs.changeBookmakGroupVersion &&
        lhs.isDelete == rhs.isDelete &&
        lhs.bookmarks == rhs.bookmarks
    }
    
    public let id: String
    public var uidUser: String
    public var idParent: String?
    public var directoryName: String
    public var shortDescription: String?
    public lazy var groups: [RemoteBookmarkGroup]? = { [RemoteBookmarkGroup]() }()
    public var bookmarks: [RemoteBookmark]?
    public var changeBookmakGroupVersion: Int
    public var isDelete: Bool = false
    
    public init(id: String,
                uidUser: String,
                idParent: String? = nil,
                directoryName: String,
                shortDescription: String? = nil,
                groups: [RemoteBookmarkGroup],
                bookmarks: [RemoteBookmark]?,
                changeBookmakGroupVersion: Int = 0,
                isDelete: Bool = false) {
        self.id = id
        self.uidUser = uidUser
        self.idParent = idParent
        self.directoryName = directoryName
        self.shortDescription = shortDescription
        self.bookmarks = bookmarks
        self.changeBookmakGroupVersion = changeBookmakGroupVersion
        self.isDelete = isDelete
        self.groups = groups
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case uidUser
        case idParent
        case directoryName
        case shortDescription
        case bookmarks
        case changeBookmakGroupVersion
        case isDelete
    }
    
    var dictionary: [String: Any?] {
        return [
            "id": id,
            "uidUser": uidUser,
            "idParent": idParent,
            "shortDescription": shortDescription,
            "directoryName": directoryName,
            "changeBookmakGroupVersion": changeBookmakGroupVersion,
            "isDelete": isDelete
        ]
    }
}
