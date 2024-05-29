//
//  UserThemesPreviewParameterProvider.swift
//  ui
//
//  Created by Damien Gironnet on 02/05/2023.
//

import Foundation
import model
import domain

///
/// Class providing UserThemes for Preview
///
public class UserThemesPreviewParameterProvider {
    
    public static let themes: [Theme] = [
        Theme(idTheme: UUID().uuidString,
              name: "l'Absolu",
              language: Locale.current.identifier,
              themes: [
                Theme(idTheme: UUID().uuidString,
                      name: "Bien et Mal",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Citations des autres",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Souffrance et Désespoir",
                      language: Locale.current.identifier
                     )
              ]
             ),
        Theme(idTheme: UUID().uuidString,
              name: "Le Détachement",
              language: Locale.current.identifier,
              themes: [
                Theme(idTheme: UUID().uuidString,
                      name: "Poèmes d'Amour",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Paroles d'Eveil",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Le Karma",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Dieu - l'Absolu",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Livre d'or",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Contes du monde",
                      language: Locale.current.identifier
                     )
              ]
             ),
        Theme(idTheme: UUID().uuidString,
              name: "Ignorance & Savoir",
              language: Locale.current.identifier,
              themes: [
                Theme(idTheme: UUID().uuidString,
                      name: "La Réalisation",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Ascetisme ?",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Authenticité & Spontanéité",
                      language: Locale.current.identifier
                     ),
                Theme(idTheme: UUID().uuidString,
                      name: "Nature Divine",
                      language: Locale.current.identifier
                     )
              ]
             ),
        Theme(idTheme: UUID().uuidString,
              name: "Amour, Compassion, Devotion",
              language: Locale.current.identifier)
    ]
}
