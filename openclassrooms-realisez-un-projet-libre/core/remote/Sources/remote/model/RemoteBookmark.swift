//
//  RemoteResource.swift
//  remote
//
//  Created by Damien Gironnet on 19/10/2023.
//

import Foundation
import FirebaseFirestore

public class RemoteBookmark: Codable, Equatable {
    public static func == (lhs: RemoteBookmark, rhs: RemoteBookmark) -> Bool {
        lhs.id == rhs.id &&
        lhs.idBookmarkGroup == rhs.idBookmarkGroup &&
        lhs.note == rhs.note &&
        lhs.idResource == rhs.idResource
    }
    
    public let id: String
    public var idBookmarkGroup: String
    public var note: String?
    public var idResource: String
    public var kind: String
    public var dateCreation: Timestamp
    
    public init(id: String,
                idBookmarkGroup: String,
                note: String? = nil,
                idResource: String,
                kind: String,
                dateCreation: Timestamp) {
        self.id = id
        self.idBookmarkGroup = idBookmarkGroup
        self.note = note
        self.idResource = idResource
        self.kind = kind
        self.dateCreation = dateCreation
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case idBookmarkGroup
        case note
        case idResource
        case kind
        case dateCreation
    }
    
    var dictionary: [String: Any?] {
        return [
            "id": id,
            "idBookmarkGroup": idBookmarkGroup,
            "note": note,
            "idResource": idResource,
            "kind": kind,
            "dateCreation": dateCreation,
        ]
    }
}
