//
//  Quote.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Quote fetched from an external layer data source
///
public struct Quote: Equatable {
    
    public var idQuote: String
    public var topics: [Topic]?
    public var language: String
    public var quote: String
    public var source: String?
    public var reference: String?
    public var remarque: String?
    public var comment: String?
    public var commentName: String?
    
    public init(idQuote: String,
                topics: [Topic]? = nil,
                language: String,
                quote: String,
                source: String? = nil,
                reference: String? = nil,
                remarque: String? = nil,
                comment: String? = nil,
                commentName: String? = nil) {
        self.idQuote = idQuote
        self.topics = topics
        self.language = language
        self.quote = quote
        self.source = source
        self.reference = reference
        self.remarque = remarque
        self.comment = comment
        self.commentName = commentName
    }
}
