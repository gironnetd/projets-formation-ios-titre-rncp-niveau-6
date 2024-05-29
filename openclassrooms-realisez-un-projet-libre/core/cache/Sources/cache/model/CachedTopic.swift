//
//  CachedTopic.swift
//  cache
//
//  Created by Damien Gironnet on 17/04/2023.
//

import Foundation
import RealmSwift
import model

///
/// Model used solely for the caching of a topic
///
public class CachedTopic: Object {
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted var language: CachedLanguage = .none
    @Persisted public var name: String
    @Persisted public var shortDescription: String?
    @Persisted public var longDescription: String?
    @Persisted public var idResource: String
    @Persisted var kind: CachedResourceKind
    
    public override init() {}
    
    public init(id: String,
                language: CachedLanguage,
                name: String,
                shortDescription: String? = nil,
                longDescription: String? = nil,
                idResource: String,
                kind: CachedResourceKind) {
        super.init()
        self.id = id
        self.language = language
        self.name = name
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.idResource = idResource
        self.kind = kind
    }
}

extension CachedTopic {
    public func asExternalModel() -> Topic {
        Topic(id: self.id,
              language: self.language.rawValue,
              name: self.name,
              shortDescription: self.shortDescription,
              longDescription: self.longDescription,
              idResource: self.idResource,
              kind: ResourceKind(rawValue: self.kind.rawValue) ?? ResourceKind.unknown)
    }
}

extension Topic {
    public func asCached() -> CachedTopic {
        CachedTopic(id: self.id,
                    language: CachedLanguage(rawValue: self.language) ?? .none,
                    name: self.name,
                    shortDescription: self.shortDescription,
                    longDescription: self.longDescription,
                    idResource: self.idResource,
                    kind: CachedResourceKind(rawValue: self.kind.rawValue) ?? CachedResourceKind.unknown)
    }
}
