//
//  CachedCentury.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import RealmSwift
import model

///
/// Model used solely for the caching of a century
///
public class CachedCentury: Object {
    
    @Persisted(primaryKey: true) public  var idCentury: String
    @Persisted public var century: String
    @Persisted public var frenchShortDescription: String?
    @Persisted public var englishShortDescription: String?
    @Persisted public var frenchPresentation: String
    @Persisted public var englishPresentation: String
    @Persisted public var presentations: Map<String, String>
    @Persisted public var topics: List<CachedTopic>
    
    public override init() {}
    
    public init(idCentury: String,
                century: String,
                presentations: Map<String, String>,
                topics: List<CachedTopic>
    ) {
        super.init()
        self.idCentury = idCentury
        self.century = century
        self.presentations = presentations
        self.topics = topics
    }
}

extension CachedCentury {
    public func asExternalModel() -> Century {
        Century(idCentury: self.idCentury,
                century: self.century,
                presentations: self.presentations.keys.isNotEmpty ? self.presentations.toDictionary() : nil,
                topics: self.topics.isNotEmpty ? self.topics.map { topic in topic.asExternalModel() } : nil)
    }
}

extension Century {
    public func asCached() -> CachedCentury {
        CachedCentury(idCentury: self.idCentury,
                      century: self.century,
                      presentations: self.presentations?.toMap() ?? Map<String, String>(),
                      topics: self.topics != nil ? self.topics!.map { topic in topic.asCached() }.toList() : List<CachedTopic>()
        )
    }
}
