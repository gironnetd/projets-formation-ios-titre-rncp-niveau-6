//
//  GetDailyBiographiesUseCaseSpec.swift
//  domainTests
//
//  Created by Damien Gironnet on 26/07/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import remote
import model
import Factory

@testable import domain

class GetForyouBiographiesUseCaseSpec: QuickSpec {

    override func spec() {
        var presentationRepository: PresentationRepository!
        var useCase: GetForyouBiographiesUseCase!

        describe("Get daily biographies") {
            context("Succeeded") {
                it("Daily biographies is Returned") {
                    presentationRepository = TestPresentationRepository(presentations: [
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
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Omniprésence",
                                              shortDescription: "",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .theme),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "XVII",
                                              shortDescription: "",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .century),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Theravada",
                                              shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .movement),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Astasahasrika Prajnaparamita Theravada",
                                              shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
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
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Omniprésence",
                                              shortDescription: "",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .theme),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "XVII",
                                              shortDescription: "",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .century),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Theravada",
                                              shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .movement),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Astasahasrika Prajnaparamita Theravada",
                                              shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
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
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Omniprésence",
                                              shortDescription: "",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .theme),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "XVII",
                                              shortDescription: "",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .century),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Theravada",
                                              shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .movement),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Astasahasrika Prajnaparamita Theravada",
                                              shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
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
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Omniprésence",
                                              shortDescription: "",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .theme),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "XVII",
                                              shortDescription: "",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .century),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Theravada",
                                              shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .movement),
                                        Topic(id: DataFactory.randomString(),
                                              language: Locale.current.identifier,
                                              name: "Astasahasrika Prajnaparamita Theravada",
                                              shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                              longDescription: "",
                                              idResource: DataFactory.randomString(),
                                              kind: .book)
                                     ]
                                    )
                    ])
                    
                    DataModule.presentationRepository.register { presentationRepository }
    
                    useCase = GetForyouBiographiesUseCase(presentationRepository: presentationRepository)
                    
                    await expect { try useCase().waitingCompletion().first.map({ $0.map({ $0.uid })})?.sorted(by: >) }.to(equal((presentationRepository as? TestPresentationRepository)?.presentations.map { UserBiography(presentation: $0).id }.sorted(by: >)))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    presentationRepository = TestPresentationRepository()
                    
                    DataModule.presentationRepository.register { presentationRepository }
                    
                    useCase = GetForyouBiographiesUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

