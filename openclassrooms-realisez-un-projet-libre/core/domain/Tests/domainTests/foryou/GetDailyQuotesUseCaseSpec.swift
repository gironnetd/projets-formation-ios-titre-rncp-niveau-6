//
//  GetDailyQuotesUseCaseSpec.swift
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

class GetForyouQuotesUseCaseSpec: QuickSpec {

    override func spec() {
        var quoteRepository: QuoteRepository!
        var useCase: GetForyouQuotesUseCase!
        
        describe("Get daily quotes") {
            context("Succeeded") {
                it("Daily quotes is Returned") {
                    quoteRepository = TestQuoteRepository(quotes: [
                        Quote(idQuote: DataFactory.randomString(),
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
                                                ],
                                                language: Locale.current.identifier,
                                                quote: "L'esprit est toujours vérité, vérité orientée vers l'éternel. L'esprit échappe au temps et à l'espace. Par son caractère intégral, il s'oppose au morcellement temporel et spatial. L'esprit n'est pas être, mais il est le sens de l'être, la vérité de l'être. L'esprit est également intelligence, mais une intelligence intégrale. L'esprit est aussi bien transcendant qu'immanent. En lui le transcendant devient immanent et l'immanent transcendant. L'esprit n'est pas identique à la conscience, mais la conscience se construit par l'esprit, et c'est aussi l'esprit qui transcende les limites de la conscience, qui atteint au supraconscient. L'esprit présente un aspect prométhéen, il se révolte contre les dieux de la nature, contre le déterminisme du destin humain ; l'esprit est une évasion, une évasion vers un monde supérieur et libre."),
                        Quote(idQuote: DataFactory.randomString(),
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
                                                      kind: .book)],
                                               language: Locale.current.identifier,
                                               quote: "Dans son Essence, la Foi est une, quelle que soit la religion qui l'exprime. La foi est l'essence de la religion, atmosphère peuplée de trois catégories d'hommes: la masse crédule, les prédicateurs aveuglés par des luttes de clocher, enfin des initiés qui ont trouvé Dieu et l'adorent en vérité et en silence.")
                    ])
                    
                    DataModule.quoteRepository.register { quoteRepository }
                    
                    useCase = GetForyouQuotesUseCase()
                    
                    expect { try useCase().waitingCompletion().first!.map({ $0.uid }).sorted(by: >) }.to(equal((quoteRepository as? TestQuoteRepository)?.quotes.sorted(by: { $0.idQuote < $1.idQuote }).map { UserQuote(quote: $0).id }.sorted(by: >)))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    quoteRepository = TestQuoteRepository()
                    
                    DataModule.quoteRepository.register { quoteRepository }
                    
                    useCase = GetForyouQuotesUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

