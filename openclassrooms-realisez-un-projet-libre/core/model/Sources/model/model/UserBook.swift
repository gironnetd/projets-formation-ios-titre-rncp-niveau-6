//
//  UserBook.swift
//  model
//
//  Created by Damien Gironnet on 27/04/2023.
//

import Foundation

///
/// A  Book with the additional information for whether or not it is followed.
///
public class UserBook: UserResource {
    
    public var name: String
    public var language: String
    public var idRelatedBooks: [String]?
    public var century: Century?
    public var details: String?
    public var period: String?
    public var idMovement: String?
    public var presentation: UserBiography?
    public var mcc1: String?
    public var quotes: [UserQuote]
    public var pictures: [UserPicture]?
    public var urls: [Url]?
    
    public init(book: Book) {
        self.name = book.name
        self.language = book.language
        self.idRelatedBooks = book.idRelatedBooks
        self.century = book.century
        self.details = book.details
        self.period = book.period
        self.idMovement = book.idMovement
        self.presentation = book.presentation != nil ? UserBiography(presentation: book.presentation!) : nil
        self.mcc1 = book.mcc1
        self.quotes = book.quotes.map { UserQuote(quote: $0) }
        self.pictures = book.pictures != nil ? book.pictures!.map { UserPicture(picture: $0) } : nil
        self.urls = book.urls
        super.init(uid: book.idBook)
        self.followableTopics = book.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: false)
    }
    
    public init(book: Book, userData: UserData) {
        self.name = book.name
        self.language = book.language
        self.idRelatedBooks = book.idRelatedBooks
        self.century = book.century
        self.details = book.details
        self.period = book.period
        self.idMovement = book.idMovement
        self.presentation = book.presentation != nil ? UserBiography(presentation: book.presentation!, userData: userData) : nil
        self.mcc1 = book.mcc1
        self.quotes = book.quotes.map { UserQuote(quote: $0, userData: userData) }
        self.pictures = book.pictures != nil ? book.pictures!.map { UserPicture(picture: $0, userData: userData) } : nil
        self.urls = book.urls
        super.init(uid: book.idBook)
        self.followableTopics = book.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: userData.bookmarkedResources.contains(book.idBook))
    }
}
