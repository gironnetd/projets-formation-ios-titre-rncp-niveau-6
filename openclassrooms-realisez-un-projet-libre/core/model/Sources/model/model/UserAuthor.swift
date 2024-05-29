//
//  UserAuthor.swift
//  model
//
//  Created by Damien Gironnet on 27/04/2023.
//

import Foundation

///
/// A  Author with the additional information for whether or not it is followed.
///
public class UserAuthor: UserResource {
        
    public var name: String
    public var language: String
    public var idRelatedAuthors: [String]?
    public var century: Century?
    public var surname: String?
    public var details: String?
    public var period: String?
    public var idMovement: String?
    public var bibliography: String?
    public var presentation: UserBiography?
    public var mainPicture: Int?
    public var mcc1: String?
    public var quotes: [UserQuote]
    public var pictures: [UserPicture]?
    public var urls: [Url]?
    
    public init(author: Author) {
        self.language = author.language
        self.name = author.name
        self.idRelatedAuthors = author.idRelatedAuthors
        self.century =  author.century
        self.surname =  author.surname
        self.details =  author.details
        self.period =  author.period
        self.idMovement =  author.idMovement
        self.bibliography =  author.bibliography
        self.presentation = author.presentation != nil ? UserBiography(presentation: author.presentation!) : nil
        self.mainPicture =  author.mainPicture
        self.mcc1 =  author.mcc1
        self.quotes =  author.quotes.map { UserQuote(quote: $0) }
        self.pictures =  author.pictures != nil ? author.pictures!.map { UserPicture(picture: $0) } : nil
        self.urls =  author.urls
        super.init(uid: author.idAuthor)
        self.followableTopics = author.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: false)
    }
    
    public init(author: Author, userData: UserData) {
        self.language = author.language
        self.name = author.name
        self.idRelatedAuthors = author.idRelatedAuthors
        self.century =  author.century
        self.surname =  author.surname
        self.details =  author.details
        self.period =  author.period
        self.idMovement =  author.idMovement
        self.bibliography =  author.bibliography
        self.presentation = author.presentation != nil ? UserBiography(presentation: author.presentation!, userData: userData) : nil
        self.mainPicture =  author.mainPicture
        self.mcc1 =  author.mcc1
        self.quotes =  author.quotes.map { UserQuote(quote: $0, userData: userData) }
        self.pictures =  author.pictures != nil ? author.pictures!.map { UserPicture(picture: $0, userData: userData) } : nil
        self.urls =  author.urls
        super.init(uid: author.idAuthor)
        self.followableTopics = author.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: userData.bookmarkedResources.contains(author.idAuthor))
    }
}
