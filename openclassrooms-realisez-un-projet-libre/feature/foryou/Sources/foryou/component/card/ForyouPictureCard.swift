//
//  ForyouPictureCard.swift
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
/// Structure representing View for daily picture card
///
public struct ForyouPictureCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var picture: UserPicture

    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    private let onToggleBookmark: (UserResource) -> Void
    private let onClick: () -> Void
    private let onTopicClick: (FollowableTopic) -> Void
    
    public init(picture: UserPicture,
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

        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let topic = picture.followableTopics.first {
                        VStack(alignment: .leading) {
                            CardTitle(title: topic.topic.name)
                            
                            if let shortDescription = topic.topic.shortDescription {
                                CardShortDescription(shortDescription: shortDescription)
                            }
                        }
                    } 

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
                
                BookmarkButton(isBookmarked: picture.isSaved,
                                   onClick: { onToggleBookmark(picture) })
                    .padding(.trailing, isTablet ? 0.0 : 4.0)
                    .padding(.top, CGFloat(6).adjustPadding())
            }
            .padding(.bottom, (orientation == .landscapeLeft || orientation == .landscapeRight) ?
                     CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding() :
                        CGFloat(isTablet ? 20.0 : 10.0).adjustVerticalPadding())
            
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
                           alignment: .center,
                           onTopicClick: { followableTopic in onTopicClick(followableTopic) })
            }
        }
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 20.0 /*24.0*/ : 20.0).adjustVerticalPadding())
        .Card()
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width) :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

internal struct ForyouPictureCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            OlaTheme(darkTheme: .systemDefault) {
                ZStack {
                    ForyouPictureCard(picture: UserPicturesPreviewParameterProvider.pictures[0],
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
