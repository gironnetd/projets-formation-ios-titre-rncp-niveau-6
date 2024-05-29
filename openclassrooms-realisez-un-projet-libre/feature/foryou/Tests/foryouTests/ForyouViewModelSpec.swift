//
// ForyouViewModelSpec.swift
// foryouTests
//
// Created by Damien Gironnet on 31/03/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import domain
import remote
import model
import Factory
import XCTest

@testable import foryou

class ForyouViewModelSpec: QuickSpec {
    
    override func spec() {
        var quoteRepository: QuoteRepository!
        var pictureRepository: PictureRepository!
        var presentationRepository: PresentationRepository!
        var viewModel: ForyouViewModel!
        var quotes: [Quote]!
        var pictures: [Picture]!
        var biographies: [Presentation]!
        
        beforeEach {
            quotes = [
                Quote(idQuote: DataFactory.randomString(),
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
                                        ],
                                        language: Locale.current.identifier,
                                        quote: "L'esprit est toujours vérité, vérité orientée vers l'éternel. L'esprit échappe au temps et à l'espace. Par son caractère intégral, il s'oppose au morcellement temporel et spatial. L'esprit n'est pas être, mais il est le sens de l'être, la vérité de l'être. L'esprit est également intelligence, mais une intelligence intégrale. L'esprit est aussi bien transcendant qu'immanent. En lui le transcendant devient immanent et l'immanent transcendant. L'esprit n'est pas identique à la conscience, mais la conscience se construit par l'esprit, et c'est aussi l'esprit qui transcende les limites de la conscience, qui atteint au supraconscient. L'esprit présente un aspect prométhéen, il se révolte contre les dieux de la nature, contre le déterminisme du destin humain ; l'esprit est une évasion, une évasion vers un monde supérieur et libre."),
                Quote(idQuote:DataFactory.randomString(),
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
                                              kind: .book)],
                                       language: Locale.current.identifier,
                                       quote: "Dans son Essence, la Foi est une, quelle que soit la religion qui l'exprime. La foi est l'essence de la religion, atmosphère peuplée de trois catégories d'hommes: la masse crédule, les prédicateurs aveuglés par des luttes de clocher, enfin des initiés qui ont trouvé Dieu et l'adorent en vérité et en silence."),
                Quote(idQuote: DataFactory.randomString(),
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
                                        
                                       ],
                                       language: Locale.current.identifier,
                                       quote: "Des imprégnations très variées issues de la tension agitée sont unies à la conscience. L'homme ordinaire les perçoit comme extérieures et ne voit pas l'essence de la conscience. L'essence de la conscience est pure, mais non la conscience provenant de l'erreur. L'erreur est faite de tension, ainsi on ne perçoit pas la Conscience."),
                Quote(idQuote: DataFactory.randomString(),
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
                                       ],
                                       language: Locale.current.identifier,
                                       quote: "La véritable extinction, c'est de supprimer la conscience mentale, la différenciatrice..., car pour agir, c'est sur elle que prennent appui les autres consciences... Cette conscience s'attache à la sphère sensorielle qu'elle discerne en la délimitant à l'aide des imprégnations. C'est elle aussi qui alimente la conscience de tréfonds.")
            ]
            
            quoteRepository = TestQuoteRepository(quotes: quotes)
            
            DataModule.quoteRepository.register { quoteRepository }
            
            pictures = [
                Picture(idPicture: DataFactory.randomString(),
                        nameSmall: "",
                        extension: "",
                        width: 1,
                        height: 1,
                        portrait: true,
                        picture: nil,
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
                       ),
                Picture(idPicture: DataFactory.randomString(),
                        nameSmall: "",
                        extension: "",
                        width: 1,
                        height: 1,
                        portrait: true,
                        picture: nil,
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
                       ),
                Picture(idPicture: DataFactory.randomString(),
                        nameSmall: "",
                        extension: "",
                        width: 1,
                        height: 1,
                        portrait: true,
                        picture: nil,
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
                       ),
                Picture(idPicture: DataFactory.randomString(),
                        nameSmall: "",
                        extension: "",
                        width: 1,
                        height: 1,
                        portrait: true,
                        picture: nil,
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
                       )
            ]
            
            pictureRepository = TestPictureRepository(pictures: pictures)
            
            DataModule.pictureRepository.register { pictureRepository }

            biographies = [
                Presentation(idPresentation: DataFactory.randomString(),
                             language: Locale.current.identifier,
                             presentation: """
        Yogananda est né le 5 janvier 1893 à Gorakhpur.
        """,
                             presentationTitle1: "Yogananda, le retour en Inde",
                             presentation1: """
        En 1935, il entend intérieurement son Maître: "Reviens dans l'Inde. Je t'ai patiemment attendu pendant quinze ans. Bientôt, je vais quitter mon corps et voguer sur les eaux de l'Esprit. Yogananda reviens". Il conclut son discours par un extrait de son poème My India: "Là où le Gange, les forêts, les cavernes de l'Himalaya et les hommes rêvent de Dieu. Je suis sanctifié, mon corps touche ce sol." Un sourire de béatitude envahit son visage et le grand yogi tombe à terre. Yogananda était en bonne santé. Il était entré dans l'état de "mahasamadhi" qui est la "sortie finale" volontaire et consciente des grands yogis. La décision de garder le corps à la morgue de Los Angeles pour que des disciples venus précipitamment de l'Inde puissent le voir une dernière fois, a permis de constater l'incorruptibilité de son corps. "L'absence de tout signe visible de décomposition du corps de Paramahansa Yogananda, même 20 jours après son décès, présente le cas le plus stupéfiant de nos annales [...]." C'est la déclaration que signait le directeur du cimetière américain de Glendale. Yogananda était parfaitement au courant de cet état, il cite en particulier dans "Autobiographie d'un Yogi" les cas de Sainte Thérèse d'Avila et de Saint Jean de la Croix. L'ambassadeur de l'Inde aux Etats Unis a déclaré: "Je ne pense pas qu'aucun d'entre nous ait eu envie de pleurer. C'était avant tout un sentiment d'exaltation, l'impression d'avoir été le témoin d'un événement divin.
        """,
                             presentationTitle2: "",
                             presentation2: "",
                             presentationTitle3: "",
                             presentation3: "",
                             presentationTitle4: "",
                             presentation4: "",
                             sourcePresentation: "http://perso.wanadoo.fr/revue.shakti",
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
                            ),
                Presentation(idPresentation: DataFactory.randomString(),
                             language: Locale.current.identifier,
                             presentation: """
        Yogananda est né le 5 janvier 1893 à Gorakhpur.
        """,
                             presentationTitle1: "Yogananda, le retour en Inde",
                             presentation1: """
        En 1935, il entend intérieurement son Maître: "Reviens dans l'Inde. Je t'ai patiemment attendu pendant quinze ans. Bientôt, je vais quitter mon corps et voguer sur les eaux de l'Esprit. Yogananda reviens". Il conclut son discours par un extrait de son poème My India: "Là où le Gange, les forêts, les cavernes de l'Himalaya et les hommes rêvent de Dieu. Je suis sanctifié, mon corps touche ce sol." Un sourire de béatitude envahit son visage et le grand yogi tombe à terre. Yogananda était en bonne santé. Il était entré dans l'état de "mahasamadhi" qui est la "sortie finale" volontaire et consciente des grands yogis. La décision de garder le corps à la morgue de Los Angeles pour que des disciples venus précipitamment de l'Inde puissent le voir une dernière fois, a permis de constater l'incorruptibilité de son corps. "L'absence de tout signe visible de décomposition du corps de Paramahansa Yogananda, même 20 jours après son décès, présente le cas le plus stupéfiant de nos annales [...]." C'est la déclaration que signait le directeur du cimetière américain de Glendale. Yogananda était parfaitement au courant de cet état, il cite en particulier dans "Autobiographie d'un Yogi" les cas de Sainte Thérèse d'Avila et de Saint Jean de la Croix. L'ambassadeur de l'Inde aux Etats Unis a déclaré: "Je ne pense pas qu'aucun d'entre nous ait eu envie de pleurer. C'était avant tout un sentiment d'exaltation, l'impression d'avoir été le témoin d'un événement divin.
        """,
                             presentationTitle2: "",
                             presentation2: "",
                             presentationTitle3: "",
                             presentation3: "",
                             presentationTitle4: "",
                             presentation4: "",
                             sourcePresentation: "http://perso.wanadoo.fr/revue.shakti",
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
                            ),
                Presentation(idPresentation: DataFactory.randomString(),
                             language: Locale.current.identifier,
                             presentation: """
        Yogananda est né le 5 janvier 1893 à Gorakhpur.
        """,
                             presentationTitle1: "Yogananda, le retour en Inde",
                             presentation1: """
        En 1935, il entend intérieurement son Maître: "Reviens dans l'Inde. Je t'ai patiemment attendu pendant quinze ans. Bientôt, je vais quitter mon corps et voguer sur les eaux de l'Esprit. Yogananda reviens". Il conclut son discours par un extrait de son poème My India: "Là où le Gange, les forêts, les cavernes de l'Himalaya et les hommes rêvent de Dieu. Je suis sanctifié, mon corps touche ce sol." Un sourire de béatitude envahit son visage et le grand yogi tombe à terre. Yogananda était en bonne santé. Il était entré dans l'état de "mahasamadhi" qui est la "sortie finale" volontaire et consciente des grands yogis. La décision de garder le corps à la morgue de Los Angeles pour que des disciples venus précipitamment de l'Inde puissent le voir une dernière fois, a permis de constater l'incorruptibilité de son corps. "L'absence de tout signe visible de décomposition du corps de Paramahansa Yogananda, même 20 jours après son décès, présente le cas le plus stupéfiant de nos annales [...]." C'est la déclaration que signait le directeur du cimetière américain de Glendale. Yogananda était parfaitement au courant de cet état, il cite en particulier dans "Autobiographie d'un Yogi" les cas de Sainte Thérèse d'Avila et de Saint Jean de la Croix. L'ambassadeur de l'Inde aux Etats Unis a déclaré: "Je ne pense pas qu'aucun d'entre nous ait eu envie de pleurer. C'était avant tout un sentiment d'exaltation, l'impression d'avoir été le témoin d'un événement divin.
        """,
                             presentationTitle2: "",
                             presentation2: "",
                             presentationTitle3: "",
                             presentation3: "",
                             presentationTitle4: "",
                             presentation4: "",
                             sourcePresentation: "http://perso.wanadoo.fr/revue.shakti",
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
                            ),
                Presentation(idPresentation: DataFactory.randomString(),
                             language: Locale.current.identifier,
                             presentation: """
        Yogananda est né le 5 janvier 1893 à Gorakhpur.
        """,
                             presentationTitle1: "Yogananda, le retour en Inde",
                             presentation1: """
        En 1935, il entend intérieurement son Maître: "Reviens dans l'Inde. Je t'ai patiemment attendu pendant quinze ans. Bientôt, je vais quitter mon corps et voguer sur les eaux de l'Esprit. Yogananda reviens". Il conclut son discours par un extrait de son poème My India: "Là où le Gange, les forêts, les cavernes de l'Himalaya et les hommes rêvent de Dieu. Je suis sanctifié, mon corps touche ce sol." Un sourire de béatitude envahit son visage et le grand yogi tombe à terre. Yogananda était en bonne santé. Il était entré dans l'état de "mahasamadhi" qui est la "sortie finale" volontaire et consciente des grands yogis. La décision de garder le corps à la morgue de Los Angeles pour que des disciples venus précipitamment de l'Inde puissent le voir une dernière fois, a permis de constater l'incorruptibilité de son corps. "L'absence de tout signe visible de décomposition du corps de Paramahansa Yogananda, même 20 jours après son décès, présente le cas le plus stupéfiant de nos annales [...]." C'est la déclaration que signait le directeur du cimetière américain de Glendale. Yogananda était parfaitement au courant de cet état, il cite en particulier dans "Autobiographie d'un Yogi" les cas de Sainte Thérèse d'Avila et de Saint Jean de la Croix. L'ambassadeur de l'Inde aux Etats Unis a déclaré: "Je ne pense pas qu'aucun d'entre nous ait eu envie de pleurer. C'était avant tout un sentiment d'exaltation, l'impression d'avoir été le témoin d'un événement divin.
        """,
                             presentationTitle2: "",
                             presentation2: "",
                             presentationTitle3: "",
                             presentation3: "",
                             presentationTitle4: "",
                             presentation4: "",
                             sourcePresentation: "http://perso.wanadoo.fr/revue.shakti",
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
                            )
            ]
            
            presentationRepository = TestPresentationRepository(presentations: biographies)
            
            DataModule.presentationRepository.register { presentationRepository }

            viewModel = ForyouViewModel(/*quoteRepository: quoteRepository, pictureRepository: pictureRepository, presentationRepository: presentationRepository*/)
        }
        
        describe("Get Feeds") {
            context("Succeeded") {
                it("Quotes is Returned") {
                    viewModel.updateForyou()
                    
                    let exp = self.expectation(description: "Test after 5 seconds")
                    _ = await XCTWaiter.fulfillment(of: [exp], timeout: 5.0)
                    
                    if case let .Success(feed) = viewModel.quotesUiState.value.state {
                        expect(feed.sorted(by: { $0.id > $1.id }).map({ $0.uid })).to(equal(quotes.sorted(by: { $0.idQuote < $1.idQuote }).map { UserQuote(quote: $0).id }.sorted(by: >)))
                    } else {
                        fail("Expected <content> but got <\(viewModel.quotesUiState)>")
                    }
                    
                    if case let .Success(feed) = viewModel.biographiesUiState.value.state {
                        expect(feed.sorted(by: { $0.id > $1.id }).map({ $0.uid })).to(equal(biographies.map { UserBiography(presentation: $0).id}.sorted(by: >)))
                    } else {
                        fail("Expected <content> but got <\(viewModel.biographiesUiState)>")
                    }
                    
                    if case let .Success(feed) = viewModel.picturesUiState.value.state {
                        expect(feed.sorted(by: { $0.id > $1.id }).map({ $0.uid })).to(equal(pictures.map { UserPicture(picture: $0).id }.sorted(by: >)))
                    } else {
                        fail("Expected <content> but got <\(viewModel.picturesUiState)>")
                    }
                }
            }
        }
    }
}
