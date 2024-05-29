//
//  GetDailyBiographiesUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import Combine
import model
import data
import preferences
import common
import Factory

///
/// A use case which obtains an exhaustive Array of ``UserBiography``
///
@dynamicCallable
public class GetForyouBiographiesUseCase {
    
    @LazyInjected(\.olaPreferences) private var olaPreferences
    @LazyInjected(\.userDataRepository) private var userDataRepository
    @LazyInjected(\.presentationRepository) private var presentationRepository
    
    typealias AreInIncreasingOrder = (Presentation, Presentation) -> Bool
    
    public init() {}
    
    public init(presentationRepository: PresentationRepository) {
        self.presentationRepository = presentationRepository
    }
    
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) -> AnyPublisher<[UserBiography], Error> {
        Publishers.Zip(
            userDataRepository.userData,
            (olaPreferences.hasDateChanged ?
             presentationRepository.findAllPresentations().map {
                 $0.filter({ presentation in presentation.presentation != nil })
                     .filter({ presentation in presentation.presentation!.count < 1760 })
                     .filter { presentation in
                         presentation.language.prefix(2) == Locale.current.identifier.prefix(2)
                     }
                 .shuffled().prefix(isTablet ? 6 : 4)
             }.map { Array($0) }.eraseToAnyPublisher() :
                olaPreferences.dailyBiographyIds
                .flatMap { ids -> AnyPublisher<[Presentation], Error> in
                    ids.publisher.flatMap { self.presentationRepository.findPresentation(byIdPresentation: $0) }
                        .collect().eraseToAnyPublisher()
                }.eraseToAnyPublisher()
            )
        )
        .map { [self] userData, biographies in
            let dailyBiographies = biographies.sorted { (lhs, rhs) in
                let predicates: [AreInIncreasingOrder] = [ { $0.presentation!.count > $1.presentation!.count }, { $0.topics!.count > $1.topics!.count }, { $0.topics![0].name.count > $1.topics![0].name.count }
                ]

                for predicate in predicates {
                    if !predicate(lhs, rhs) && !predicate(rhs, lhs) {
                        continue
                    }
                    return predicate(lhs, rhs)
                }
                return false
            }
            
            if olaPreferences.hasDateChanged {
                olaPreferences.setDailyBiographyIds(ids: dailyBiographies.map { $0.idPresentation })
            }
                            
            return dailyBiographies.map { UserBiography(presentation: $0, userData: userData) }
        }
        .eraseToAnyPublisher()
    }
}
