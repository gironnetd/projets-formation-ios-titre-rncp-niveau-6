//
//  QuoteCard.swift
//  ui
//
//  Created by Damien Gironnet on 09/08/2023.
//

import SwiftUI
import model
import designsystem
import common
import domain

public struct QuoteCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var quote: UserQuote
    
    private let onToggleBookmark: (UserResource) -> Void
    private let onTopicClick: (FollowableTopic) -> Void
    
    public init(quote: UserQuote,
                onToggleBookmark: @escaping (UserResource) -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.quote = quote
        self.onToggleBookmark = onToggleBookmark
        self.onTopicClick = onTopicClick
    }
    
    public var body: some View {
        let width = (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 3 - (24.0 * 2) / 2
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if let source = quote.source {
                    Text(source)
                        .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.primary)
                        .textStyle(TypographyTokens.BodyLarge)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(8)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 16)
                    
                }
                
                Spacer()
                
                BookmarkButton(isBookmarked: quote.isSaved,
                               onClick: { onToggleBookmark(quote) })
                    .padding(.trailing, isTablet ? 0.0 : 4.0)
                    .frame(alignment: .trailing)
            }.padding(.bottom, 20)
              
            CardTextContent(
                text: quote.quote,
                width: (isTablet ? (orientation.isPortrait ? ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing / 2) / 2 - (offset.value) / 2) : width /*(UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing / 2) / 2 - (offset.value) / 2*/)
                        : (orientation.isPortrait ? (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                            (((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 2) - geometry.safeAreaInsets.trailing / 2 - 4.0)
                          )) - CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding() * 2)
                .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                         CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding() :
                            CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding())
            
            CardTopics(topics: quote.followableTopics,
                       availableWidth:
                        (isTablet ?
                         (orientation.isPortrait ? ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing / 2) / 2 - (offset.value) / 2)
                                     : width
                                        /*(UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing / 2) / 2 - (offset.value) / 2*/)
                         
                         : (orientation.isPortrait ? (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                                (((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 2) - geometry.safeAreaInsets.trailing / 2 - 4.0)
                           )) - CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding() * 2,
                       alignment: .leading,
                       onTopicClick: { followableTopic in onTopicClick(followableTopic) })
        }
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding())
        .Card()
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width)
                :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

internal struct QuoteCard_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCard(quote: UserQuotesPreviewParameterProvider.quotes[0],
                  onToggleBookmark: { _ in },
                  onTopicClick: { _ in }
        )
    }
}
