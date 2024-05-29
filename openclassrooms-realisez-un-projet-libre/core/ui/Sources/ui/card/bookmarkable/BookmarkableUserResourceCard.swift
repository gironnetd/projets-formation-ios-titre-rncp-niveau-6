//
//  BookmarkableUserResourceCard.swift
//  bookmarks
//
//  Created by Damien Gironnet on 19/11/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem

public struct BookmarkableUserResourceCard: View {
    
    @ObservedObject private var offset: Offset = Offset.shared
    private let bookmarkableUserResource: BookmarkableUserResource
        
    private let onToggleBookmark: (UserResource) -> Void
    private let onClick: () -> Void
    private let onTopicClick: (FollowableTopic) -> Void
    
    public init(bookmarkableUserResource: BookmarkableUserResource,
                onToggleBookmark: @escaping (UserResource) -> Void,
                onClick: @escaping () -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.bookmarkableUserResource = bookmarkableUserResource
        self.onToggleBookmark = onToggleBookmark
        self.onClick = onClick
        self.onTopicClick = onTopicClick
    }
    
    public var body: some View {
        switch bookmarkableUserResource.resource {
        case let quote as UserQuote:
            BookmarkedQuoteCard(
                quote: BookmarkableUserQuote(
                    quote: quote,
                    bookmark: bookmarkableUserResource.bookmark),
                onToggleBookmark: onToggleBookmark,
                onClick: {},
                onTopicClick: onTopicClick)
            .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
        case let picture as UserPicture:
            BookmarkedPictureCard(
                picture: BookmarkableUserPicture(
                    picture: picture,
                    bookmark: bookmarkableUserResource.bookmark),
                onToggleBookmark: onToggleBookmark,
                onClick: {},
                onTopicClick: onTopicClick)
            .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
        case let biography as UserBiography:
            BookmarkedBiographyCard(
                biography: BookmarkableUserBiography(
                    biography: biography,
                    bookmark: bookmarkableUserResource.bookmark),
                onToggleBookmark: onToggleBookmark,
                onClick: {},
                onTopicClick: onTopicClick)
            .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
        default:
            EmptyView()
        }
    }
}

