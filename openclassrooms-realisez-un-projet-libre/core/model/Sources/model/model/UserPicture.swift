//
//  UserPicture.swift
//  model
//
//  Created by Damien Gironnet on 24/04/2023.
//

import Foundation

///
/// A  Picture with the additional information for whether or not it is followed.
///
open class UserPicture: UserResource {
    
    public var nameSmall: String
    public var `extension`: String
    public var comments: [String: String]?
    public var width : Int
    public var height : Int
    public var portrait : Bool
    public var picture: Data?
    
    public init(picture: Picture) {
        self.nameSmall = picture.nameSmall
        self.extension = picture.`extension`
        self.width = picture.width
        self.height = picture.height
        self.portrait = picture.portrait
        self.picture = picture.picture
        self.comments = picture.comments
        super.init(uid: picture.idPicture)
        self.followableTopics = picture.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: true)
    }
    
    public init(picture: Picture, userData: UserData) {
        self.nameSmall = picture.nameSmall
        self.extension = picture.`extension`
        self.width = picture.width
        self.height = picture.height
        self.portrait = picture.portrait
        self.picture = picture.picture
        self.comments = picture.comments
        super.init(uid: picture.idPicture)
        self.followableTopics = picture.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: userData.bookmarkedResources.contains(picture.idPicture))
    }
    
    public init(picture: UserPicture) {
        self.nameSmall = picture.nameSmall
        self.extension = picture.`extension`
        self.width = picture.width
        self.height = picture.height
        self.portrait = picture.portrait
        self.picture = picture.picture
        self.comments = picture.comments
        super.init(uid: picture.uid)
        self.followableTopics = picture.followableTopics
        self.isSaved = picture.isSaved
    }
}
