//
//  Picture.swift
//  model
//
//  Created by damien on 13/09/2022.
//

import Foundation

///
/// Representation for a Picture fetched from an external layer data source
///
public struct Picture: Equatable {
    
    public var idPicture: String
    public var nameSmall: String
    public var `extension`: String
    public var comments: [String: String]?
    public var width : Int
    public var height : Int
    public var portrait : Bool
    public var picture: Data?
    public var topics: [Topic]?
    
    public init(idPicture: String,
                nameSmall: String,
                `extension`: String,
                comments: [String: String]? = nil,
                width: Int,
                height: Int,
                portrait: Bool = false,
                picture: Data? = nil,
                topics: [Topic]? = nil) {
        self.idPicture = idPicture
        self.nameSmall = nameSmall
        self.extension = `extension`
        self.width = width
        self.height = height
        self.portrait = portrait
        self.picture = picture
        self.comments = comments
        self.topics = topics
    }
}
