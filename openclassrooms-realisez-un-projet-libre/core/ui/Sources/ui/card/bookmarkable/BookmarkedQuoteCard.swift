//
//  BookmarkedQuoteCard.swift
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

public struct BookmarkedQuoteCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var quote: BookmarkableUserQuote
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    private let onToggleBookmark: (UserResource) -> Void
    private let onClick: () -> Void
    private let onTopicClick: (FollowableTopic) -> Void
    
    public init(quote: BookmarkableUserQuote,
                onToggleBookmark: @escaping (UserResource) -> Void,
                onClick: @escaping () -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.quote = quote
        self.onToggleBookmark = onToggleBookmark
        self.onClick = onClick
        self.onTopicClick = onTopicClick
    }
    
    public var body: some View {
        let width = (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 3 - (24.0 * 2) / 2
        
        LazyVStack(alignment: .leading) {
            HStack(alignment: .top) {
                if let topic = quote.followableTopics.first {
                    VStack(alignment: .leading) {
                        BookmarkCardTitle(title: topic.topic.name)
                        
                        if let source = quote.source {
                            Text(source)
                                .foregroundColor(colorScheme == .light ? localColorScheme.Primary30 : localColorScheme.Primary10)
                                .textStyle(TypographyTokens.BodyLarge)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(8)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                
                Spacer()
                
                BookmarkButton(
                    lightColor: localColorScheme.primary,
                    darkColor: localColorScheme.primary,
                    isBookmarked: quote.isSaved,
                    onClick: { onToggleBookmark(quote) })
                .padding(.top, 2.0)
            }
            
            HStack(alignment: .center, spacing: 16) {
                Divider()
                    .frame(width: 3.0)
                    .background(colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary20)
                
                Text(quote.bookmark.note.isNotEmpty ? quote.bookmark.note :
                        "add_a_note".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) + "...")
                .textStyle(TypographyTokens.BodyLarge)
                .foregroundColor(colorScheme == .light ? localColorScheme.Primary60 : localColorScheme.Primary20)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture { SheetUiState.shared.currentSheet = .addOrEditNote(quote.bookmark) }
            
            CardTextContent(
                text: quote.quote,
                width: (isTablet ? (orientation.isPortrait ? ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing / 2) / 2 - (offset.value) / 2) : width)
                        : (orientation.isPortrait ? (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                            (((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 2) - geometry.safeAreaInsets.trailing / 2 - 4.0)
                          )) - CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding() * 2)
            .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                     CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding() :
                        CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding())
            
            CardTopics(topics: quote.followableTopics.filter({ $0.topic.kind != .century }),
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

public class BookmarkedQuotesUiState: ObservableObject, Equatable {
    public static func == (lhs: BookmarkedQuotesUiState, rhs: BookmarkedQuotesUiState) -> Bool {
        lhs.state == rhs.state
    }
    
    @Published public var state: BookmarkedQuotesState
    
    public init(state: BookmarkedQuotesState) {
        self.state = state
    }
}

public class BookmarkableUserQuote: UserQuote {
    
    @Published public var bookmark: Bookmark
    
    private var cancellable: AnyCancellable? = nil
    
    public init(quote: UserQuote, bookmark: Bookmark) {
        self.bookmark = bookmark
        super.init(quote: quote)
        cancellable = self.bookmark.objectWillChange.sink { [weak self] (_) in self?.objectWillChange.send() }
    }
}

public enum BookmarkedQuotesState : Equatable {
    public static func == (lhs: BookmarkedQuotesState, rhs: BookmarkedQuotesState) -> Bool {
        switch (lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.Success(let lhsQuotes), .Success(let rhsQuotes)):
            return lhsQuotes.elementsEqual(rhsQuotes, by: ==)
        default:
            return false
        }
    }
    
    case Loading
    case Success(feed: [BookmarkableUserQuote])
}
