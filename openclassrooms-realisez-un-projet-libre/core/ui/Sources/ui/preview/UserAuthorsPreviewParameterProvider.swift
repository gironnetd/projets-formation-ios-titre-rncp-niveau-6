//
//  UserAuthorsPreviewParameterProvider.swift
//  ui
//
//  Created by Damien Gironnet on 27/04/2023.
//

import Foundation
import model
import RealmSwift
import domain

///
/// Class providing UserAuthors for Preview
///
public class UserAuthorsPreviewParameterProvider {
    
    public static let authors: [UserAuthor] = [
        UserAuthor(author: Author(idAuthor: UUID().uuidString,
                                  language: Locale.current.identifier,
                                  name: "Nicolas Berdiaev",
                                  quotes: [])),
        UserAuthor(author: Author(idAuthor: UUID().uuidString,
                                  language: Locale.current.identifier,
                                  name: "Aurobindo Ghose",
                                  quotes: [])),
        UserAuthor(author: Author(idAuthor: UUID().uuidString,
                                  language: Locale.current.identifier,
                                  name: "Paramhansa Yogananda",
                                  quotes: [])),
        UserAuthor(author: Author(idAuthor: UUID().uuidString,
                                  language: Locale.current.identifier,
                                  name: "Karlfried Graf Durckheim",
                                  quotes: []))
    ]
}
