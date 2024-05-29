//
//  Presentation.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Presentation fetched from an external layer data source
///
public struct Presentation: Equatable {
    
    public var idPresentation: String
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
    public var topics: [Topic]?
    
    public init(idPresentation: String,
                language: String,
                presentation: String? = nil,
                presentationTitle1: String? = nil,
                presentation1: String? = nil,
                presentationTitle2: String? = nil,
                presentation2: String? = nil,
                presentationTitle3: String? = nil,
                presentation3: String? = nil,
                presentationTitle4: String? = nil,
                presentation4: String? = nil,
                sourcePresentation: String? = nil,
                topics: [Topic]? = nil) {
        self.idPresentation = idPresentation
        self.language = language
        self.presentation = presentation
        self.presentationTitle1 = presentationTitle1
        self.presentation1 = presentation1
        self.presentationTitle2 = presentationTitle2
        self.presentation2 = presentation2
        self.presentationTitle3 = presentationTitle3
        self.presentation3 = presentation3
        self.presentationTitle4 = presentationTitle4
        self.presentation4 = presentation4
        self.sourcePresentation = sourcePresentation
        self.topics = topics
    }
}
