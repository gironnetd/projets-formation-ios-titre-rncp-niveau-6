//
//  UserResource.swift
//  model
//
//  Created by Damien Gironnet on 24/10/2023.
//

import Foundation
import common

open class UserResource: ObservableObject, Equatable, Hashable, Identifiable {
    public static func == (lhs: UserResource, rhs: UserResource) -> Bool {
        lhs.uid == rhs.uid && lhs.isSaved.value == rhs.isSaved.value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.isSaved.value)
    }
    
    public var id: String { uid }
    public var uid: String
    public var followableTopics: [FollowableTopic] = []
    @Published public var isSaved: BoolObservable = .init(value: false)

    public init(uid: String) {
        self.uid = uid
    }
}
