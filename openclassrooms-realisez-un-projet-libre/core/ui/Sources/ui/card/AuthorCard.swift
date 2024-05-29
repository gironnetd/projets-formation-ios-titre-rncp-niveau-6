//
//  AuthorsCard.swift
//  ui
//
//  Created by Damien Gironnet on 27/04/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

///
/// Structure representing View for author home card
///
public struct AuthorCard: View {
    
    @ObservedObject private var offset: Offset = Offset.shared
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    private let author: UserAuthor
    private let onToggleBookmark: () -> Void
    private let onClick: (FollowableTopic) -> Void
    
    public init(author: UserAuthor,
                onToggleBookmark: @escaping () -> Void,
                onClick: @escaping (FollowableTopic) -> Void) {
        self.author = author
        self.onToggleBookmark = onToggleBookmark
        self.onClick = onClick
    }
    
    public var body: some View {
        let width = (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 3 - (24.0 * 2) / 2

        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                CardTitle(title: author.name)
                
                if let shortDescription = author.followableTopics.first(where: { followableTopic in followableTopic.topic.idResource == author.id })?.topic.shortDescription {
                    CardShortDescription(shortDescription: shortDescription)
                }
            }
            
            Spacer()
        }
        .padding()
        .Card()
        .onTapGesture { onClick(author.followableTopics.first!) }
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width)
                :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

internal struct AuthorCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            OlaTheme(darkTheme: .systemDefault) {
                ZStack {
                    AuthorCard(author: UserAuthorsPreviewParameterProvider.authors[0],
                               onToggleBookmark: { },
                               onClick: { _ in print("OnClick") })
                    .padding(EdgeInsets(top: geometry.safeAreaInsets.top, leading: 16.0, bottom: geometry.safeAreaInsets.top, trailing: 16.0))
                    .OlaBackground()
                }
            }
        }
        .preferredColorScheme(.light)
    }
}
