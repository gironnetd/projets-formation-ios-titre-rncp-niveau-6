//
//  UserBiography.swift
//  model
//
//  Created by Damien Gironnet on 24/04/2023.
//

import Foundation

///
/// A  Presentation with the additional information for whether or not it is followed.
///
open class UserBiography: UserResource {

    public var language: String
    public var presentation: String?
    public var presentationTitle1: String?
    public var presentation1: String?
    public var presentationTitle2: String?
    public var presentation2: String?
    public var presentationTitle3: String?
    public var presentation3: String?
    public var presentationTitle4: String?
    public var presentation4: String?
    public var sourcePresentation: String?
    
    public init(presentation: Presentation) {
        self.language = presentation.language
        self.presentation = presentation.presentation
        self.presentationTitle1 = presentation.presentationTitle1
        self.presentation1 = presentation.presentation1
        self.presentationTitle2 = presentation.presentationTitle2
        self.presentation2 = presentation.presentation2
        self.presentationTitle3 = presentation.presentationTitle3
        self.presentation3 = presentation.presentation3
        self.presentationTitle4 = presentation.presentationTitle4
        self.presentation4 = presentation.presentation4
        self.sourcePresentation = presentation.sourcePresentation
        super.init(uid: presentation.idPresentation)
        self.followableTopics = presentation.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: true)
    }
    
    public init(presentation: Presentation, userData: UserData) {
        self.language = presentation.language
        self.presentation = presentation.presentation
        self.presentationTitle1 = presentation.presentationTitle1
        self.presentation1 = presentation.presentation1
        self.presentationTitle2 = presentation.presentationTitle2
        self.presentation2 = presentation.presentation2
        self.presentationTitle3 = presentation.presentationTitle3
        self.presentation3 = presentation.presentation3
        self.presentationTitle4 = presentation.presentationTitle4
        self.presentation4 = presentation.presentation4
        self.sourcePresentation = presentation.sourcePresentation
        super.init(uid: presentation.idPresentation)
        self.followableTopics = presentation.topics?.map { topic in FollowableTopic(topic: topic, isFollowed: false) } ?? []
        self.isSaved = .init(value: userData.bookmarkedResources.contains(presentation.idPresentation))
    }
    
    public init(biography: UserBiography) {
        self.language = biography.language
        self.presentation = biography.presentation
        self.presentationTitle1 = biography.presentationTitle1
        self.presentation1 = biography.presentation1
        self.presentationTitle2 = biography.presentationTitle2
        self.presentation2 = biography.presentation2
        self.presentationTitle3 = biography.presentationTitle3
        self.presentation3 = biography.presentation3
        self.presentationTitle4 = biography.presentationTitle4
        self.presentation4 = biography.presentation4
        self.sourcePresentation = biography.sourcePresentation
        super.init(uid: biography.id)
        self.uid = biography.uid
        self.followableTopics = biography.followableTopics
        self.isSaved = biography.isSaved
    }
}
