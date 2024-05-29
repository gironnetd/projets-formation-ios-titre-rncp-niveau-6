//
//  BookmarkedPictureCard.swift
//  ui
//
//  Created by Damien Gironnet on 22/10/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import Combine


public struct BookmarkedPictureCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var picture: BookmarkableUserPicture
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    @State var showsAlwaysPopover = false
    
    private let onToggleBookmark: (UserResource) -> Void
    private let onClick: () -> Void
    private let onTopicClick: (FollowableTopic) -> Void
    
    public init(picture: BookmarkableUserPicture,
                onToggleBookmark: @escaping (UserResource) -> Void,
                onClick: @escaping () -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.picture = picture
        self.onToggleBookmark = onToggleBookmark
        self.onClick = onClick
        self.onTopicClick = onTopicClick
    }
    
    public var body: some View {
        let width = (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 3 - (24.0 * 2) / 2
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let topic = picture.followableTopics.first { BookmarkCardTitle(title: topic.topic.name) }

                    if let language = picture.followableTopics.first?.topic.language,
                       let comment = picture.comments?[language] {
                        Text(comment)
                            .foregroundColor(colorScheme == .light ? localColorScheme.Primary30 : localColorScheme.Primary10)
                            .textStyle(TypographyTokens.BodyLarge)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(8)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                BookmarkButton(
                    lightColor: localColorScheme.primary,
                    darkColor: localColorScheme.primary,
                    isBookmarked: picture.isSaved,
                    onClick: { onToggleBookmark(picture) })
                .padding(.top, 2.0)
            }
            
            HStack(alignment: .center, spacing: 16) {
                Divider()
                    .frame(width: 3.0)
                    .background(colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary20)
                
                Text(picture.bookmark.note.isNotEmpty ? picture.bookmark.note :
                        "add_a_note".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) + "...")
                    .textStyle(TypographyTokens.BodyLarge)
                    .foregroundColor(colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary20)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture { SheetUiState.shared.currentSheet = .addOrEditNote(picture.bookmark) }
            
            VStack {
                if let image = picture.picture {
                    CardPicture(picture: image)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                        .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                                 CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding() :
                                    CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding())
                } else {
                    RoundedRectangle(cornerRadius: 8).foregroundColor(Color.gray).opacity(0.1)
                        .aspectRatio(CGSize(width: picture.width, height: picture.height), contentMode: .fit)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                                 CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding() :
                                    CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding())
                }
                
                CardTopics(topics: picture.followableTopics.filter({ $0.topic.kind != .century })
                    .filter({ $0.topic.language.prefix(2) == Locale.current.identifier.prefix(2) }),
                           availableWidth:
                            (isTablet ? (orientation.isPortrait ? ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing / 2) / 2 - (offset.value) / 2) : width)
                             : (orientation.isPortrait ? (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                                    (((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 2) - geometry.safeAreaInsets.trailing / 2 - 4.0)
                               )) - CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding() * 2,
                           alignment: .leading,
                           onTopicClick: { followableTopic in onTopicClick(followableTopic) })
            }
        }
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 24.0 : (20.0)))
        .Card()
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width) :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

public class BookmarkedPicturesUiState: ObservableObject, Equatable {
    public static func == (lhs: BookmarkedPicturesUiState, rhs: BookmarkedPicturesUiState) -> Bool {
        lhs.state == rhs.state
    }
    
    @Published public var state: BookmarkedPicturesState
    
    public init(state: BookmarkedPicturesState) {
        self.state = state
    }
}

public class BookmarkableUserPicture: UserPicture {

    @Published public var bookmark: Bookmark
    
    private var cancellable: AnyCancellable? = nil

    public init(picture: UserPicture, bookmark: Bookmark) {
        self.bookmark = bookmark
        super.init(picture: picture)
        cancellable = self.bookmark.objectWillChange.sink { [weak self] (_) in self?.objectWillChange.send() }
    }
}

public enum BookmarkedPicturesState : Equatable {
    public static func == (lhs: BookmarkedPicturesState, rhs: BookmarkedPicturesState) -> Bool {
        switch (lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.Success(let lhsPictures), .Success(let rhsPictures)):
            return lhsPictures.elementsEqual(rhsPictures, by: ==)
        default:
            return false
        }
    }
    
    case Loading
    case Success(feed: [BookmarkableUserPicture])
}

