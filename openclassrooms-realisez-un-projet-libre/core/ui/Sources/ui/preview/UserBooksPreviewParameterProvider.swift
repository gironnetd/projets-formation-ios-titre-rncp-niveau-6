//
//  UserBooksPreviewParameterProvider.swift
//  ui
//
//  Created by Damien Gironnet on 27/04/2023.
//

import Foundation
import model
import domain

///
/// Class providing UserBook sfor Preview
///
public class UserBooksPreviewParameterProvider {
    
    public static let books: [UserBook] = [
        UserBook(book: Book(idBook: UUID().uuidString,
                            name: "Khuddaka Nikaya",
                            language: Locale.current.identifier,
                            quotes: [])),
        UserBook(book: Book(idBook: UUID().uuidString,
                            name: "Divers Sutras",
                            language: Locale.current.identifier,
                            quotes: [])),
        UserBook(book: Book(idBook: UUID().uuidString,
                            name: "Bible",
                            language: Locale.current.identifier,
                            quotes: [])),
        UserBook(book: Book(idBook: UUID().uuidString,
                            name: "Books Of Changes",
                            language: Locale.current.identifier,
                            quotes: []))
    ]
}
