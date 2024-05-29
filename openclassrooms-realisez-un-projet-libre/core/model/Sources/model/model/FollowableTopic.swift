//
//  FollowableTopic.swift
//  domain
//
//  Created by Damien Gironnet on 16/04/2023.
//

import Foundation

///
/// A  Topic with the additional information for whether or not it is followed.
///
public struct FollowableTopic: Equatable {
    public let topic: Topic
    public let isFollowed: Bool
    
    public init(topic: Topic, isFollowed: Bool) {
        self.topic = topic
        self.isFollowed = isFollowed
    }
}
