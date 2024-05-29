//
//  UserTheme.swift
//  model
//
//  Created by Damien Gironnet on 06/08/2023.
//

import Foundation

///
/// A  Theme with the additional information for whether or not it is followed.
///
public class UserTheme: UserResource {
    
    public var idParentTheme: String?
    public var name: String
    public var language: String
    public var idRelatedThemes: [String]?
    public var presentation: String?
    public var sourcePresentation: String?
    public var nbQuotes: Int = 0
    public var authors: [UserAuthor]?
    public var books: [UserBook]?
    public var themes: [UserTheme]?
    public var pictures: [UserPicture]?
    public var quotes: [UserQuote]
    public var urls: [Url]?
    
    public init(theme: Theme) {
        self.idParentTheme = theme.idParentTheme
        self.name = theme.name
        self.language = theme.language
        self.idRelatedThemes = theme.idRelatedThemes
        self.presentation = theme.presentation
        self.sourcePresentation = theme.sourcePresentation
        self.nbQuotes = theme.nbQuotes
        self.themes = theme.themes != nil ? theme.themes!.map { UserTheme(theme: $0) } : nil
        self.pictures = theme.pictures != nil ? theme.pictures!.map { UserPicture(picture: $0) } : nil
        self.quotes =  theme.quotes.map { UserQuote(quote: $0) }
        self.urls = theme.urls
        super.init(uid: theme.idTheme)
        self.followableTopics = theme.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: false)
    }
    
    public init(theme: Theme, userData: UserData) {
        self.idParentTheme = theme.idParentTheme
        self.name = theme.name
        self.language = theme.language
        self.idRelatedThemes = theme.idRelatedThemes
        self.presentation = theme.presentation
        self.sourcePresentation = theme.sourcePresentation
        self.nbQuotes = theme.nbQuotes
        self.themes = theme.themes != nil ? theme.themes!.map { UserTheme(theme: $0, userData: userData) } : nil
        self.pictures = theme.pictures != nil ? theme.pictures!.map { UserPicture(picture: $0, userData: userData) } : nil
        self.quotes =  theme.quotes.map { UserQuote(quote: $0, userData: userData) }
        self.urls = theme.urls
        super.init(uid: theme.idTheme)
        self.followableTopics = theme.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: userData.bookmarkedResources.contains(theme.idTheme))
    }
}
