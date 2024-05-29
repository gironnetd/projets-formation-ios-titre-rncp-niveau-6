//
//  CachedQuote.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

///
/// Model used solely for the caching of a quote
///
public class CachedQuote: Object {
    
    @Persisted(primaryKey: true) public var idQuote: String
    @Persisted var language: CachedLanguage = .none
    @Persisted public var quote: String
    @Persisted public var source: String?
    @Persisted public var reference: String?
    @Persisted public var remarque: String?
    @Persisted public var comment: String?
    @Persisted public var commentName: String?
    @Persisted public var topics: List<CachedTopic>
    
    public override init() {}
    
    public init(idQuote: String,
                topics: List<CachedTopic>,
                language: CachedLanguage,
                quote: String,
                source: String? = nil,
                reference: String? = nil,
                remarque: String? = nil,
                comment: String? = nil,
                commentName: String? = nil) {
        super.init()
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
    
    public convenience init?(idQuote: String) {
        guard let quote = try? Realm().objects(CachedQuote.self).where({ quote in quote.idQuote == idQuote }).first else { return nil }
        
        self.init(idQuote: quote.idQuote,
                  topics: quote.topics,
                  language: quote.language,
                  quote: quote.quote,
                  source: quote.source,
                  reference: quote.reference,
                  remarque: quote.remarque,
                  comment: quote.comment,
                  commentName: quote.commentName)
    }
}

extension CachedQuote {
    public func asExternalModel() -> Quote {
        Quote(idQuote: self.idQuote,
              topics: self.topics.isNotEmpty ? self.topics.map { topic in topic.asExternalModel() } : nil,
              language: self.language.rawValue,
              quote: self.quote,
              source: self.source,
              reference: self.reference,
              remarque: self.remarque,
              comment: self.comment,
              commentName: self.commentName)
    }
}

extension Quote {
    public func asCached() -> CachedQuote {
        CachedQuote(idQuote: self.idQuote,
                    topics: self.topics != nil ? self.topics!.map { topic in topic.asCached() }.toList() : List<CachedTopic>(),
                    language: CachedLanguage(rawValue: self.language) ?? .none,
                    quote: self.quote,
                    source: self.source,
                    reference: self.reference,
                    remarque: self.remarque,
                    comment: self.comment,
                    commentName: self.commentName)
    }
}
