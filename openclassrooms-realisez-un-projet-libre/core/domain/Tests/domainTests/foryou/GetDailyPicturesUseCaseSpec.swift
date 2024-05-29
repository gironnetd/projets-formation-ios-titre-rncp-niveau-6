//
//  GetDailyPicturesUseCaseSpec.swift
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

class GetForyouPicturesUseCaseSpec: QuickSpec {
    
    override func spec() {
        var pictureRepository: PictureRepository!
        var useCase: GetForyouPicturesUseCase!

        describe("Get daily pictures") {
            context("Succeeded") {
                it("Daily pictures is Returned") {
                    pictureRepository = TestPictureRepository(pictures: [
                        Picture(idPicture: DataFactory.randomString(),
                                nameSmall: "",
                                extension: "",
                                width: 1,
                                height: 1,
                                portrait: true,
                                picture: nil,
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
                        Picture(idPicture: DataFactory.randomString(),
                                nameSmall: "",
                                extension: "",
                                width: 1,
                                height: 1,
                                portrait: true,
                                picture: nil,
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
                        Picture(idPicture: DataFactory.randomString(),
                                nameSmall: "",
                                extension: "",
                                width: 1,
                                height: 1,
                                portrait: true,
                                picture: nil,
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
                        Picture(idPicture: DataFactory.randomString(),
                                nameSmall: "",
                                extension: "",
                                width: 1,
                                height: 1,
                                portrait: true,
                                picture: nil,
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
                    
                    DataModule.pictureRepository.register { pictureRepository }
                    
                    useCase = GetForyouPicturesUseCase()
                    
                    let dailyPictures = try useCase().waitingCompletion().first
                    
                    await expect { try useCase().waitingCompletion().first!.map({ $0.uid }).sorted(by: >) }.to( equal((pictureRepository as? TestPictureRepository)?.pictures.map { UserPicture(picture: $0).id }.sorted(by: >)))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    pictureRepository = TestPictureRepository()
                    
                    DataModule.pictureRepository.register { pictureRepository }
                    
                    useCase = GetForyouPicturesUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

