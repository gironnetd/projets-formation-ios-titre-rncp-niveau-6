//
//  CardTopics.swift
//  ui
//
//  Created by Damien Gironnet on 25/04/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

///
/// Structure representing card topics
///
public struct CardTopics: View {
    
    private let topics: [FollowableTopic]
    private let availableWidth: CGFloat
    private let alignment: HorizontalAlignment
    private let onTopicClick: (FollowableTopic) -> Void
    
    public init(topics: [FollowableTopic],
                availableWidth: CGFloat,
                alignment: HorizontalAlignment = .leading,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.topics = topics
        self.availableWidth = availableWidth
        self.alignment = alignment
        self.onTopicClick = onTopicClick
    }
    
    public var body: some View {
        FlexibleGrid(
            availableWidth: availableWidth,
            data: topics.indices,
            spacing: 10 ,
            alignment: alignment) { index in
                Text(topics[index].topic.name).textStyle(TypographyTokens.BodyLarge)
                    .padding(.horizontal, 6)
                    .FollowableTopicTag(followed: topics[index].isFollowed,
                                        onClick: { onTopicClick(topics[index]) },
                                        enabled: false)
            }
            
    }
}
