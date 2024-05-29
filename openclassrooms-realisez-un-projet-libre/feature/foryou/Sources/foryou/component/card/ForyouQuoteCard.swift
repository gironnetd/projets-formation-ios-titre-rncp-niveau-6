//
//  ForyouQuoteCard.swift
//  ui
//
//  Created by Damien Gironnet on 07/04/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain
import ui

///
/// Structure representing View for daily quote card
///
public struct ForyouQuoteCard: View {
    
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var quote: UserQuote
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    private let onToggleBookmark: (UserResource) -> Void
    private let onClick: () -> Void
    private let onTopicClick: (FollowableTopic) -> Void
    
    public init(quote: UserQuote,
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

        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if let topic = quote.followableTopics.first {
                    VStack(alignment: .leading) {
                        CardTitle(title: topic.topic.name)
                        
                        if let shortDescription = topic.topic.shortDescription {
                            CardShortDescription(shortDescription: shortDescription)
                        }
                    }
                }
                
                Spacer()
                
                BookmarkButton(isBookmarked: quote.isSaved,
                    onClick: { onToggleBookmark(quote) })
                    .padding(.trailing, isTablet ? 0.0 : 4.0)
            }
            .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                     CGFloat(isTablet ? 20.0 : 10.0).adjustHorizontalPadding() :
                        CGFloat(isTablet ? 20.0 : 10.0).adjustHorizontalPadding())
            
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
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 20.0/*24.0*/ : 20.0).adjustVerticalPadding())
        .Card()
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width) :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

internal struct ForyouQuoteCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            OlaTheme(darkTheme: .systemDefault) {
                ZStack {
                    ForyouQuoteCard(
                        quote: UserQuotesPreviewParameterProvider.quotes[0],
                        onToggleBookmark: { _ in },
                        onClick: {},
                        onTopicClick: { _ in })
                    .padding(EdgeInsets(top: geometry.safeAreaInsets.top, leading: 16.0, bottom: geometry.safeAreaInsets.top, trailing: 16.0))
                    .OlaBackground()
                }
            }
        }.preferredColorScheme(.light)
    }
}
