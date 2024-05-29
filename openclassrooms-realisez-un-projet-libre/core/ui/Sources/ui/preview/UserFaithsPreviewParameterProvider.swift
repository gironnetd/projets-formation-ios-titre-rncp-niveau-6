//
//  UserFaithsPreviewParameterProvider.swift
//  ui
//
//  Created by Damien Gironnet on 01/05/2023.
//

import Foundation
import model
import domain

///
/// Class providing UserFaiths for Preview
///
public class UserFaithsPreviewParameterProvider {
    
    public static let faiths: [Movement] = [
        Movement(idMovement: UUID().uuidString,
                 name: "Bouddhisme",
                 language: Locale.current.identifier,
                 idRelatedMovements: nil,
                 movements: [
                    Movement(idMovement: UUID().uuidString,
                             name: "Bouddhisme",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil),
                    Movement(idMovement: UUID().uuidString,
                             name: "Mahayana",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil,
                             movements: [
                                Movement(idMovement: UUID().uuidString,
                                         name: "Mahayana",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Madhyamaka",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Tantrisme",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Zen",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Yogacara",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil)
                             ]
                            ),
                    Movement(idMovement: UUID().uuidString,
                             name: "Theravada",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil)
                    
                 ]
            ),
        Movement(idMovement: UUID().uuidString,
                 name: "Bouddhisme",
                 language: Locale.current.identifier,
                 idRelatedMovements: nil,
                 movements: [
                    Movement(idMovement: UUID().uuidString,
                             name: "Bouddhisme",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil),
                    Movement(idMovement: UUID().uuidString,
                             name: "Mahayana",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil,
                             movements: [
                                Movement(idMovement: UUID().uuidString,
                                         name: "Mahayana",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Madhyamaka",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Tantrisme",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Zen",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Yogacara",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil)
                             ]
                            ),
                    Movement(idMovement: UUID().uuidString,
                             name: "Theravada",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil)
                    
                 ]
            ),
        Movement(idMovement: UUID().uuidString,
                 name: "Bouddhisme",
                 language: Locale.current.identifier,
                 idRelatedMovements: nil,
                 movements: [
                    Movement(idMovement: UUID().uuidString,
                             name: "Bouddhisme",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil),
                    Movement(idMovement: UUID().uuidString,
                             name: "Mahayana",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil,
                             movements: [
                                Movement(idMovement: UUID().uuidString,
                                         name: "Mahayana",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Madhyamaka",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Tantrisme",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Zen",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil),
                                Movement(idMovement: UUID().uuidString,
                                         name: "Yogacara",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil)
                             ]
                            ),
                    Movement(idMovement: UUID().uuidString,
                             name: "Theravada",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil)
                    
                 ]
        ),
        Movement(idMovement: UUID().uuidString,
                 name: "Theravada",
                 language: Locale.current.identifier,
                 idRelatedMovements: nil)
    ]
}
