//
//  UserQuote.swift
//  model
//
//  Created by Damien Gironnet on 16/04/2023.
//

import Foundation

///
/// A  Quote with the additional information for whether or not it is followed.
///
open class UserQuote: UserResource {
    public static func == (lhs: UserQuote, rhs: UserQuote) -> Bool {
        lhs.uid == rhs.uid && lhs.isSaved.value == rhs.isSaved.value &&
        lhs.quote == rhs.quote && lhs.followableTopics == rhs.followableTopics
    }
    
    public var language: String
    public var quote: String
    public var source: String?
    public var reference: String?
    public var remarque: String?
    public var comment: String?
    public var commentName: String?
    
    public init(quote: Quote) {
        self.language = quote.language
        self.quote = quote.quote
        self.source = quote.source
        self.reference = quote.reference
        self.remarque = quote.remarque
        self.comment = quote.comment
        self.commentName = quote.commentName
        super.init(uid: quote.idQuote)
        self.followableTopics = quote.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: true)
    }
    
    public init(quote: Quote, userData: UserData) {
        self.language = quote.language
        self.quote = quote.quote
        self.source = quote.source
        self.reference = quote.reference
        self.remarque = quote.remarque
        self.comment = quote.comment
        self.commentName = quote.commentName
        super.init(uid: quote.idQuote)
        self.followableTopics = quote.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: userData.bookmarkedResources.contains(quote.idQuote))
    }
    
    public init(quote: UserQuote) {
        self.language = quote.language
        self.quote = quote.quote
        self.source = quote.source
        self.reference = quote.reference
        self.remarque = quote.remarque
        self.comment = quote.comment
        self.commentName = quote.commentName
        super.init(uid: quote.id)
        self.followableTopics = quote.followableTopics
        self.isSaved = quote.isSaved
    }
}
