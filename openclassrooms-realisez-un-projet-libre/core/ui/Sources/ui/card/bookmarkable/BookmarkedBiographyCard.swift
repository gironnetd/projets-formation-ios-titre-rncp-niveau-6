//
//  BookmarkedBiographyCard.swift
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

public struct BookmarkedBiographyCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var biography: BookmarkableUserBiography
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    @State var showsAlwaysPopover = false
    
    private let onToggleBookmark: (UserResource) -> Void
    private let onClick: () -> Void
    private let onTopicClick: (FollowableTopic) -> Void
    
    public init(biography: BookmarkableUserBiography,
                onToggleBookmark: @escaping (UserResource) -> Void,
                onClick: @escaping () -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.biography = biography
        self.onToggleBookmark = onToggleBookmark
        self.onClick = onClick
        self.onTopicClick = onTopicClick
    }
    
    public var body: some View {
        let width = (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 3 - (24.0 * 2) / 2
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if let topic = biography.followableTopics.first {
                    BookmarkCardTitle(title: topic.topic.name)
                }
                
                Spacer()
                
                BookmarkButton(
                    lightColor: localColorScheme.primary,
                    darkColor: localColorScheme.primary,
                    isBookmarked: biography.isSaved,
                    onClick: { onToggleBookmark(biography) })
                .padding(.top, 2.0)
            }
            
            HStack(alignment: .center, spacing: 16) {
                Divider()
                    .frame(width: 3.0)
                    .background(colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary20)
                
                Text(biography.bookmark.note.isNotEmpty ? biography.bookmark.note :
                        "add_a_note".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) + "...")
                .textStyle(TypographyTokens.BodyLarge)
                .foregroundColor(colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary20)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture { SheetUiState.shared.currentSheet = .addOrEditNote(biography.bookmark) }
            
            CardTextContent(
                text: biography.presentation!,
                width: (isTablet ? (orientation.isPortrait ? ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing / 2) / 2 - (offset.value) / 2) : width)
                        : (orientation.isPortrait ? (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                            (((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 2) - geometry.safeAreaInsets.trailing / 2 - 4.0)
                          )) - CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding() * 2)
            .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                     CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding() :
                        CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding())
            
            CardTopics(topics: biography.followableTopics.filter({ $0.topic.kind != .century })
                .filter({ $0.topic.language.prefix(2) == Locale.current.identifier.prefix(2) }),
                       availableWidth:
                        (isTablet ? (orientation.isPortrait ? ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing / 2) / 2 - (offset.value) / 2) : width)
                         : (orientation.isPortrait ? (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                                (((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 2) - geometry.safeAreaInsets.trailing / 2 - 4.0)
                           )) - CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding() * 2,
                       alignment: .leading,
                       onTopicClick: { followableTopic in onTopicClick(followableTopic) })
        }
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding())
        .Card()
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width) :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

public class BookmarkedBiographiesUiState: ObservableObject, Equatable {
    public static func == (lhs: BookmarkedBiographiesUiState, rhs: BookmarkedBiographiesUiState) -> Bool {
        lhs.state == rhs.state
    }
    
    @Published public var state: BookmarkedBiographiesState
    
    public init(state: BookmarkedBiographiesState) {
        self.state = state
    }
}

public class BookmarkableUserBiography: UserBiography {
    
    @Published public var bookmark: Bookmark
    
    private var cancellable: AnyCancellable? = nil
    
    public init(biography: UserBiography, bookmark: Bookmark) {
        self.bookmark = bookmark
        super.init(biography: biography)
        cancellable = self.bookmark.objectWillChange.sink { [weak self] (_) in self?.objectWillChange.send() }
    }
}

public enum BookmarkedBiographiesState : Equatable {
    public static func == (lhs: BookmarkedBiographiesState, rhs: BookmarkedBiographiesState) -> Bool {
        switch (lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.Success(let lhsBiographies), .Success(let rhsBiographies)):
            return lhsBiographies.elementsEqual(rhsBiographies, by: ==)
        default:
            return false
        }
    }
    
    case Loading
    case Success(feed: [BookmarkableUserBiography])
}
