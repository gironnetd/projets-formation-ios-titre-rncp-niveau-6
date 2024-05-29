//
//  UserFaith.swift
//  model
//
//  Created by Damien Gironnet on 06/08/2023.
//

import Foundation

///
/// A  Faith with the additional information for whether or not it is followed.
///
public class UserFaith: UserResource {
    
    public var idParentMovement: String?
    public var name: String
    public var language: String
    public var idRelatedMovements: [String]?
    public var mcc1: String?
    public var mcc2: String?
    public var presentation: UserBiography?
    public var mcc3: String?
    public var nbQuotes: Int
    public var nbAuthors: Int
    public var nbAuthorsQuotes: Int
    public var nbBooks: Int
    public var nbBooksQuotes: Int
    public var selected: Bool = false
    public var nbTotalQuotes: Int
    public var nbTotalAuthors: Int
    public var nbTotalBooks: Int
    public var nbSubcourants: Int
    public var nbAuthorsSubcourants: Int
    public var nbBooksSubcourants: Int
    public var authors: [UserAuthor]?
    public var books: [UserBook]?
    public var movements: [UserFaith]?
    public var pictures: [UserPicture]?
    public var urls: [Url]?
    
    public init(faith: Movement) {
        self.idParentMovement = faith.idParentMovement
        self.name = faith.name
        self.language = faith.language
        self.idRelatedMovements = faith.idRelatedMovements
        self.mcc1 = faith.mcc1
        self.mcc2 = faith.mcc2
        self.presentation = faith.presentation != nil ? UserBiography(presentation: faith.presentation!) : nil
        self.mcc3 = faith.mcc3
        self.nbQuotes = faith.nbQuotes
        self.nbAuthors = faith.nbAuthors
        self.nbAuthorsQuotes = faith.nbAuthorsQuotes
        self.nbBooks = faith.nbBooks
        self.nbBooksQuotes = faith.nbBooksQuotes
        self.selected = faith.selected
        self.nbTotalQuotes = faith.nbTotalQuotes
        self.nbTotalAuthors = faith.nbTotalAuthors
        self.nbTotalBooks = faith.nbTotalBooks
        self.nbSubcourants = faith.nbSubcourants
        self.nbAuthorsSubcourants = faith.nbAuthorsSubcourants
        self.nbBooksSubcourants = faith.nbBooksSubcourants
        self.authors = faith.authors != nil ? faith.authors!.map { UserAuthor(author: $0) } : nil
        self.books = faith.books != nil ? faith.books!.map { UserBook(book: $0) } : nil
        self.movements = faith.movements != nil ? faith.movements!.map { UserFaith(faith: $0) } : nil
        self.pictures = faith.pictures != nil ? faith.pictures!.map { UserPicture(picture: $0) } : nil
        self.urls = faith.urls
        super.init(uid: faith.idMovement)
        self.followableTopics = faith.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: false)
    }
    
    public init(faith: Movement, userData: UserData) {
        self.idParentMovement = faith.idParentMovement
        self.name = faith.name
        self.language = faith.language
        self.idRelatedMovements = faith.idRelatedMovements
        self.mcc1 = faith.mcc1
        self.mcc2 = faith.mcc2
        self.presentation = faith.presentation != nil ? UserBiography(presentation: faith.presentation!, userData: userData) : nil
        self.mcc3 = faith.mcc3
        self.nbQuotes = faith.nbQuotes
        self.nbAuthors = faith.nbAuthors
        self.nbAuthorsQuotes = faith.nbAuthorsQuotes
        self.nbBooks = faith.nbBooks
        self.nbBooksQuotes = faith.nbBooksQuotes
        self.selected = faith.selected
        self.nbTotalQuotes = faith.nbTotalQuotes
        self.nbTotalAuthors = faith.nbTotalAuthors
        self.nbTotalBooks = faith.nbTotalBooks
        self.nbSubcourants = faith.nbSubcourants
        self.nbAuthorsSubcourants = faith.nbAuthorsSubcourants
        self.nbBooksSubcourants = faith.nbBooksSubcourants
        self.authors = faith.authors != nil ? faith.authors!.map { UserAuthor(author: $0, userData: userData) } : nil
        self.books = faith.books != nil ? faith.books!.map { UserBook(book: $0) } : nil
        self.movements = faith.movements != nil ? faith.movements!.map { UserFaith(faith: $0, userData: userData) } : nil
        self.pictures = faith.pictures != nil ? faith.pictures!.map { UserPicture(picture: $0, userData: userData) } : nil
        self.urls = faith.urls
        super.init(uid: faith.idMovement)
        self.followableTopics = faith.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: userData.bookmarkedResources.contains(faith.idMovement))
    }
}
