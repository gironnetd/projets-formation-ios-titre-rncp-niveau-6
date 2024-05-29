//
//  BookmarkableUserResource.swift
//  model
//
//  Created by Damien Gironnet on 16/11/2023.
//

import Foundation

public class BookmarkableUserResource: Equatable, Hashable, ObservableObject, Identifiable {
    public static func == (lhs: BookmarkableUserResource, rhs: BookmarkableUserResource) -> Bool {
        lhs.bookmark == rhs.bookmark && lhs.resource == rhs.resource
    }
    
    public var id: String { resource.id }
    @Published public var resource: UserResource
    @Published public var bookmark: Bookmark
    
    public init(resource: UserResource, bookmark: Bookmark) {
        self.resource = resource
        self.bookmark = bookmark
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmark)
    }
}
