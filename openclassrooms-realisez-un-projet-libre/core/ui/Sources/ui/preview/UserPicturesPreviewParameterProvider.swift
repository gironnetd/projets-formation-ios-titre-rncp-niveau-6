//
//  UserPicturesPreviewParameterProvider.swift
//  ui
//
//  Created by Damien Gironnet on 10/04/2023.
//

import Foundation
import model
import UIKit
import domain

///
/// Class providing UserPictures for Preview
///
public class UserPicturesPreviewParameterProvider {
    
    public static let pictures: [UserPicture] = [
        UserPicture(picture: Picture(
            idPicture: UUID().uuidString,
            nameSmall: "",
            extension: "",
            width: 1,
            height: 1,
            portrait: true,
            picture: NSDataAsset(name: "Seneca_762", bundle: Bundle.ui)!.data,
            topics: [
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Omniprésence",
                      shortDescription: "",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .theme),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "XVII",
                      shortDescription: "",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .century),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Theravada",
                      shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .movement),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Astasahasrika Prajnaparamita Theravada",
                      shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .book)
            ]
        )),
        UserPicture(picture: Picture(
            idPicture: UUID().uuidString,
            nameSmall: "",
            extension: "",
            width: 1,
            height: 1,
            portrait: true,
            picture: NSDataAsset(name: "Blaise_Pascal_742", bundle: Bundle.ui)!.data,
            topics: [
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Omniprésence",
                      shortDescription: "",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .theme),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "XVII",
                      shortDescription: "",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .century),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Theravada",
                      shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .movement),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Astasahasrika Prajnaparamita Theravada",
                      shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .book)
            ]
        )),
        UserPicture(picture: Picture(
            idPicture: UUID().uuidString,
            nameSmall: "",
            extension: "",
            width: 1,
            height: 1,
            portrait: true,
            picture: NSDataAsset(name: "Bhagavat_Gita_575", bundle: Bundle.ui)!.data,
            topics: [
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Omniprésence",
                      shortDescription: "",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .theme),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "XVII",
                      shortDescription: "",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .century),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Theravada",
                      shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .movement),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Astasahasrika Prajnaparamita Theravada",
                      shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .book)
            ]
        )),
        UserPicture(picture: Picture(
            idPicture: UUID().uuidString,
            nameSmall: "",
            extension: "",
            width: 1,
            height: 1,
            portrait: true,
            picture: NSDataAsset(name: "Nagarjuna_226", bundle: Bundle.ui)!.data,
            topics: [
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Omniprésence",
                      shortDescription: "",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .theme),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "XVII",
                      shortDescription: "",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .century),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Theravada",
                      shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .movement),
                Topic(id: UUID().uuidString,
                      language: Locale.current.identifier,
                      name: "Astasahasrika Prajnaparamita Theravada",
                      shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                      longDescription: "",
                      idResource: UUID().uuidString,
                      kind: .book)
            ]
        ))
    ]
}
