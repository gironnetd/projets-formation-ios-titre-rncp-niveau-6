//
//  Bookmark.swift
//  model
//
//  Created by Damien Gironnet on 19/10/2023.
//

import Foundation
import SwiftUI
import Combine

public enum BookmarkGroupLocation: String, CaseIterable, Identifiable {
    public var id: String { self.rawValue }
    
    case shared, device, remote
}

public class BookmarkGroup: Equatable, ObservableObject {
    public static func == (lhs: BookmarkGroup, rhs: BookmarkGroup) -> Bool {
        lhs.id == rhs.id &&
        lhs.idParent == rhs.idParent &&
        lhs.location == rhs.location &&
        lhs.groups == rhs.groups &&
        lhs.directoryName == rhs.directoryName &&
        lhs.shortDescription == rhs.shortDescription &&
        lhs.bookmarks == rhs.bookmarks
    }
    
    public let id: String
    public var idParent: String?
    @Published public var location: BookmarkGroupLocation
    @Published public var directoryName: String
    @Published public var shortDescription: String
    public var groups: [BookmarkGroup]
    @Published public var bookmarks: [Bookmark]
    
    public init(id: String,
                idParent: String? = nil,
                location: BookmarkGroupLocation,
                directoryName: String = "",
                shortDescription: String = "",
                groups: [BookmarkGroup] = [],
                bookmarks: [Bookmark] = []) {
        self.id = id
        self.idParent = idParent
        self.location = location
        self.directoryName = directoryName
        self.shortDescription = shortDescription
        self.groups = groups
        self.bookmarks = bookmarks
    }
}
