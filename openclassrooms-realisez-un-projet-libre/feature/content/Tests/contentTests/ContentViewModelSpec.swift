//
// ContentViewModelSpec.swift
// contentTests
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

@testable import content

class ContentViewModelSpec: QuickSpec {
    
    override func spec() {
        var authorRepository: AuthorRepository!
        var bookRepository: BookRepository!
        var movementRepository: MovementRepository!
        var themeRepository: ThemeRepository!
        var userDataRepository: UserDataRepository!
        var contentViewModel: ContentViewModel!
        var authors: [Author]!
        var books: [Book]!
        var movements: [Movement]!
        var themes: [Theme]!
        
        beforeEach {
            let picture = Picture(idPicture: DataFactory.randomString(),
                                  nameSmall: "",
                                  extension: "",
                                  width: 1,
                                  height: 1,
                                  portrait: true,
                                  picture: nil,
                                  topics: []
                                 )
            
            let presentation = Presentation(idPresentation: DataFactory.randomString(),
                                            language: Locale.current.identifier,
                presentation: """
Yogananda est né le 5 janvier 1893 à Gorakhpur, en Inde du Nord-Est, sous le nom de Mukunda Lal Ghosh. Le nom de Yogananda ("béatitude par le yoga") lui a été donné en 1914, et le titre de Paramahansa (("cygne supérieur", le cygne étant le véhicule de Brahma) en 1935. Ses parents, Bengalis tous les deux, ont été très tôt des disciples de Lahiri Mahasaya. Sa mère lui fait connaître le Mahabharata et le Ramayana. Les phénomènes surnaturels ne tardent pas à accompagner sa vie. En 1901, à 8 ans, atteint du choléra asiatique que les médecins ne savent pas guérir, sur le conseil de sa mère, il s'agenouille devant le portrait de Lahiri Mahasaya (mort en 1895), et est bientôt "enveloppé par une vive lumière" qui se répand aussi dans la pièce. "La nausée et les autres symptômes disparurent; je me sentis guéri". Après avoir terminé ses études secondaires, dont il dit lui-même "Je ne prétends pas y avoir mis du zèle", il rencontre, après avoir eu de nombreuses visions, son Maître Shri Yukteswar, qui lui dit: "Enfin, mon enfant! Que d'années je t'ai attendu".
""",
                presentationTitle1: "Yogananda, le retour en Inde",
                presentation1: """
En 1935, il entend intérieurement son Maître: "Reviens dans l'Inde. Je t'ai patiemment attendu pendant quinze ans. Bientôt, je vais quitter mon corps et voguer sur les eaux de l'Esprit. Yogananda reviens". Ses amis rassemblent les dons, et il part pour l'Inde avec son secrétaire, en passant par l'Europe, où il rencontre notamment Thérèse Neumann, stigmatisée catholique. Il reçoit un accueil triomphal à Bombay, puis dans les autres villes où il passe, et enfin, retrouve son Maître Shri Yukteswar avec une émotion très humaine. Il est reçu par de nombreuses personnalités hindoues. Son Maître lui donne le titre de Paramahansa puis lui dit: "Désormais, mon oeuvre sur cette terre est achevée; c'est à toi de la continuer. Désigne moi un successeur à mon ashram de Puri. Je remets tout entre tes mains." Shri Yukteswar meurt alors que Yogananda est à la Kumbha Mela, pensant rencontrer Babaji. Yogananda reçoit intérieurement la mort de son Maître. Quelques mois après, Shri Yukteswar ressuscite devant Yogananda quelques heures "Mon fils, désormais tu as entièrement compris que je suis ressuscité par décret divin...", et lui apprend sa mission dans "l'au-delà", dont Yogananda ne donne que quelques éléments. Yoga voyage en Inde, rencontre Gandi, Ananda Moya Ma et bien d'autres êtres remarquables, comme une femme yogi qui ne mange pas. Il repart en occident en septembre 1936, Angleterre puis Etats Unis où il retrouve son école transformée. Il poursuit alors la mission qui lui a été demandée, prolongeant ainsi le travail de Swami Vivekananda (mort en 1902, qu'il n'a connu qu'à travers des amis et son oeuvre) d'une manière plus ciblée. En 1952, sortant d'une retraite dans le désert, Yogananda fait savoir à son entourage que "son oeuvre était terminée". Le 7 mars, il participe, à titre de conférencier invité, à une soirée en l'honneur de l'ambassadeur de l'Inde aux Etats-Unis. Il conclut son discours par un extrait de son poème My India: "Là où le Gange, les forêts, les cavernes de l'Himalaya et les hommes rêvent de Dieu. Je suis sanctifié, mon corps touche ce sol." Un sourire de béatitude envahit son visage et le grand yogi tombe à terre. Yogananda était en bonne santé. Il était entré dans l'état de "mahasamadhi" qui est la "sortie finale" volontaire et consciente des grands yogis. La décision de garder le corps à la morgue de Los Angeles pour que des disciples venus précipitamment de l'Inde puissent le voir une dernière fois, a permis de constater l'incorruptibilité de son corps. "L'absence de tout signe visible de décomposition du corps de Paramahansa Yogananda, même 20 jours après son décès, présente le cas le plus stupéfiant de nos annales [...]." C'est la déclaration que signait le directeur du cimetière américain de Glendale. Yogananda était parfaitement au courant de cet état, il cite en particulier dans "Autobiographie d'un Yogi" les cas de Sainte Thérèse d'Avila et de Saint Jean de la Croix. L'ambassadeur de l'Inde aux Etats Unis a déclaré: "Je ne pense pas qu'aucun d'entre nous ait eu envie de pleurer. C'était avant tout un sentiment d'exaltation, l'impression d'avoir été le témoin d'un événement divin.
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
            
            authors = []
            
            for _ in 0..<2 {
                let authorId = DataFactory.randomString()
                authors.append(
                    Author(idAuthor: authorId,
                           language: Locale.current.identifier,
                           name: "Nicolas Berdiaev",
                           presentation: presentation,
                           quotes: [Quote(idQuote: DataFactory.randomString(),
                                          topics: [
                                            Topic(id: UUID().uuidString,
                                                  language: Locale.current.identifier,
                                                  name: "Astasahasrika Prajnaparamita Theravada",
                                                  shortDescription: "recueil de textes sur la perfection de la sapience (-Ie au IIe siècle)",
                                                  longDescription: "",
                                                  idResource: UUID().uuidString,
                                                  kind: .book)
                                          ],
                                          language: Locale.current.identifier,
                                          quote: "L'esprit est toujours vérité, vérité orientée vers l'éternel. L'esprit échappe au temps et à l'espace. Par son caractère intégral, il s'oppose au morcellement temporel et spatial. L'esprit n'est pas être, mais il est le sens de l'être, la vérité de l'être. L'esprit est également intelligence, mais une intelligence intégrale. L'esprit est aussi bien transcendant qu'immanent. En lui le transcendant devient immanent et l'immanent transcendant. L'esprit n'est pas identique à la conscience, mais la conscience se construit par l'esprit, et c'est aussi l'esprit qui transcende les limites de la conscience, qui atteint au supraconscient. L'esprit présente un aspect prométhéen, il se révolte contre les dieux de la nature, contre le déterminisme du destin humain ; l'esprit est une évasion, une évasion vers un monde supérieur et libre.")],
                          pictures: [picture],
                          topics: [
                            Topic(id: UUID().uuidString,
                                  language: Locale.current.identifier,
                                  name: "Omniprésence",
                                  shortDescription: "",
                                  longDescription: "",
                                  idResource: authorId,
                                  kind: .author),
                            Topic(id: UUID().uuidString,
                                  language: Locale.current.identifier,
                                  name: "XVII",
                                  shortDescription: "",
                                  longDescription: "",
                                  idResource: authorId,
                                  kind: .century)
                          ])
                )
            }
            
            authorRepository = TestAuthorRepository(authors: authors.sorted(by: { $0.name.lowercased() < $1.name.lowercased() }))
            
            DataModule.authorRepository.register { authorRepository }
            
            books = []
            
            for _ in 0..<2 {
                let bookId = DataFactory.randomString()
                
                books.append(
                    Book(idBook: bookId,
                         name: "Khuddaka Nikaya",
                         language: Locale.current.identifier,
                         presentation: presentation,
                         quotes: [Quote(idQuote: DataFactory.randomString(),
                                        topics: [],
                                        language: Locale.current.identifier,
                                        quote: "Dans son Essence, la Foi est une, quelle que soit la religion qui l'exprime. La foi est l'essence de la religion, atmosphère peuplée de trois catégories d'hommes: la masse crédule, les prédicateurs aveuglés par des luttes de clocher, enfin des initiés qui ont trouvé Dieu et l'adorent en vérité et en silence.")],
                         pictures: [picture],
                         topics: [
                           Topic(id: UUID().uuidString,
                                 language: Locale.current.identifier,
                                 name: "Omniprésence",
                                 shortDescription: "",
                                 longDescription: "",
                                 idResource: bookId,
                                 kind: .book),
                           Topic(id: UUID().uuidString,
                                 language: Locale.current.identifier,
                                 name: "XVII",
                                 shortDescription: "",
                                 longDescription: "",
                                 idResource: bookId,
                                 kind: .century)
                         ])
                )
            }
            
            bookRepository = TestBookRepository(books: books.sorted(by: { $0.name.lowercased() < $1.name.lowercased() }))
            
            DataModule.bookRepository.register { bookRepository }
            
            movements = []
            
            for _ in 0..<2 {
                let movementId = DataFactory.randomString()
                
                movements.append(
                    Movement(idMovement: movementId,
                             name: "Mahayana",
                             language: Locale.current.identifier,
                             idRelatedMovements: nil,
                             presentation: presentation,
                             nbTotalQuotes: 3,
                             authors: authors,
                             books: books,
                             movements: [
                                Movement(idMovement: DataFactory.randomString(),
                                         name: "Madhyamaka",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil,
                                         nbTotalQuotes: 3,
                                         authors: [],
                                         movements: []),
                                Movement(idMovement: DataFactory.randomString(),
                                         name: "Tantrisme",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil,
                                         nbTotalQuotes: 3,
                                         authors: [],
                                         movements: []),
                                Movement(idMovement: DataFactory.randomString(),
                                         name: "Zen",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil,
                                         nbTotalQuotes: 3,
                                         authors: [],
                                         movements: []),
                                Movement(idMovement: DataFactory.randomString(),
                                         name: "Yogacara",
                                         language: Locale.current.identifier,
                                         idRelatedMovements: nil,
                                         nbTotalQuotes: 3,
                                         authors: [],
                                         movements: [])
                             ],
                            pictures: [picture],
                             topics: [
                               Topic(id: UUID().uuidString,
                                     language: Locale.current.identifier,
                                     name: "Omniprésence",
                                     shortDescription: "",
                                     longDescription: "",
                                     idResource: movementId,
                                     kind: .movement),
                               Topic(id: UUID().uuidString,
                                     language: Locale.current.identifier,
                                     name: "XVII",
                                     shortDescription: "",
                                     longDescription: "",
                                     idResource: movementId,
                                     kind: .century)
                             ])
                )
            }
            
            movementRepository = TestMovementRepository(movements: movements)
            
            DataModule.movementRepository.register { movementRepository }
            
            themes = []
            
            for _ in 0..<2 {
                let themeId = DataFactory.randomString()
                
                themes.append(
                    Theme(idTheme: themeId,
                          name: "La Réalisation",
                          language: Locale.current.identifier,
                          themes: [
                            Theme(idTheme: DataFactory.randomString(),
                                  name: "Ascetisme ?",
                                  language: Locale.current.identifier,
                                  themes: []),
                            Theme(idTheme: DataFactory.randomString(),
                                  name: "Authenticité & Spontanéité",
                                  language: Locale.current.identifier,
                                  themes: []),
                            Theme(idTheme: DataFactory.randomString(),
                                  name: "Nature Divine",
                                  language: Locale.current.identifier,
                                  themes: [])
                          ],
                          pictures: [picture],
                          quotes: [
                            Quote(idQuote: DataFactory.randomString(),
                                           topics: [],
                                           language: Locale.current.identifier,
                                           quote: "Dans son Essence, la Foi est une, quelle que soit la religion qui l'exprime. La foi est l'essence de la religion, atmosphère peuplée de trois catégories d'hommes: la masse crédule, les prédicateurs aveuglés par des luttes de clocher, enfin des initiés qui ont trouvé Dieu et l'adorent en vérité et en silence.")
                          ],
                          topics: [
                            Topic(id: UUID().uuidString,
                                  language: Locale.current.identifier,
                                  name: "Omniprésence",
                                  shortDescription: "",
                                  longDescription: "",
                                  idResource: themeId,
                                  kind: .theme),
                            Topic(id: UUID().uuidString,
                                  language: Locale.current.identifier,
                                  name: "XVII",
                                  shortDescription: "",
                                  longDescription: "",
                                  idResource: themeId,
                                  kind: .century)
                          ])
                )
            }

            themeRepository = TestThemeRepository(themes: themes)
            
            DataModule.themeRepository.register { themeRepository }

            userDataRepository = TestUserDataRepository()
            
            DataModule.userDataRepository.register { userDataRepository }
            
            contentViewModel = ContentViewModel()
        }
        
        describe("Get Author by Id Feed") {
            context("Succeeded") {
                it("Author is Returned") {
                    contentViewModel.populateFeeds(from: FollowableTopic(
                        topic: authors[0].topics!.first!, isFollowed: false), onComplete: {
                            if case let .Success(quotes) = contentViewModel.quotesUiState.value.state,
                               let author = authors.first(where: { $0.idAuthor == authors[0].topics!.first!.idResource }) {
                                expect(quotes.map({ $0.uid }).sorted(by: >)).to(equal(author.quotes.map { UserQuote(quote: $0).uid }.sorted(by: >)))
                            }
                            
                            if case let .Success(biography) = contentViewModel.biographyUiState.value.state,
                               let author = authors.first(where: { $0.idAuthor == authors[0].topics!.first!.idResource }) {
                                expect(biography.uid).to(equal(UserBiography(presentation: author.presentation!).id))
                            }
                            
                            if case let .Success(pictures) = contentViewModel.picturesUiState.value.state,
                               let author = authors.first(where: { $0.idAuthor == authors[0].topics!.first!.idResource }) {
                                expect(pictures.map({ $0.uid }).sorted(by: >)).to(equal(author.pictures!.map { UserPicture(picture: $0).uid }.sorted(by: >)))
                            }
                        })
                }
            }
        }
        
        describe("Get Book by Id Feed") {
            context("Succeeded") {
                it("Book is Returned") {
                    contentViewModel.populateFeeds(from: FollowableTopic(
                        topic: books[0].topics!.first!,
                        isFollowed: false), onComplete: {
                            if case let .Success(quotes) = contentViewModel.quotesUiState.value.state,
                               let book = books.first(where: { $0.idBook == books[0].topics!.first!.idResource }) {
                                expect(quotes.map({ $0.uid }).sorted(by: >)).to(equal(book.quotes.map { UserQuote(quote: $0).id }.sorted(by: >)))
                            }
                            
                            if case let .Success(biography) = contentViewModel.biographyUiState.value.state,
                               let book = books.first(where: { $0.idBook == books[0].topics!.first!.idResource }) {
                                expect(biography.uid).to(equal(UserBiography(presentation: book.presentation!).id))
                            }
                            
                            if case let .Success(pictures) = contentViewModel.picturesUiState.value.state,
                               let book = books.first(where: { $0.idBook == books[0].topics!.first!.idResource }) {
                                expect(pictures.map({ $0.uid }).sorted(by: >)).to(equal(book.pictures!.map { UserPicture(picture: $0).id }.sorted(by: >)))
                            }
                        })
                }
            }
        }
        
        describe("Get Faith by Id Feed") {
            context("Succeeded") {
                it("Faith is Returned") {
                    contentViewModel.populateFeeds(from: FollowableTopic(
                        topic: movements[0].topics!.first!,
                        isFollowed: false), onComplete: {
                        if case let .Success(quotes) = contentViewModel.quotesUiState.value.state,
                           let movement = movements.first(where: { $0.idMovement == movements[0].topics!.first!.idResource }) {
                            let quoteIds = (movement.authors!.map({ $0.quotes }).map({ $0.map({ $0.idQuote })}) + movement.books!.map({ $0.quotes }).map({ $0.map({ $0.idQuote })})).flatMap({ $0 })
                            expect(quotes.map({ $0.uid }).sorted(by: >)).to(equal(quoteIds.sorted(by: >)))
                        }
                    })
                }
            }
        }
        
        describe("Get Theme by Id Feed") {
            context("Succeeded") {
                it("Theme is Returned") {
                    contentViewModel.populateFeeds(from: FollowableTopic(
                        topic: themes[0].topics!.first!,
                        isFollowed: false), onComplete: {
                            if case let .Success(quotes) = contentViewModel.quotesUiState.value.state,
                               let theme = themes.first(where: { $0.idTheme == themes[0].topics!.first!.idResource }) {
                                expect(quotes.map({ $0.uid }).sorted(by: >)).to(equal(theme.quotes.map { UserQuote(quote: $0).id }.sorted(by: >)))
                            }
                            
                            if case let .Success(pictures) = contentViewModel.picturesUiState.value.state,
                               let theme = themes.first(where: { $0.idTheme == themes[0].topics!.first!.idResource }) {
                                expect(pictures.map({ $0.uid }).sorted(by: >)).to(equal(theme.pictures!.map { UserPicture(picture: $0).id }.sorted(by: >)))
                            }
                        })
                }
            }
        }
    }
}
