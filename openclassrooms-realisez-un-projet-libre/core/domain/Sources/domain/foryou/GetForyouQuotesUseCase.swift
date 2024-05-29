//
//  GetDailyQuotesUseCase.swift
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
/// A use case which obtains an exhaustive Array of ``UserQuote``
///
@dynamicCallable
public class GetForyouQuotesUseCase {
    
    @LazyInjected(\.olaPreferences) private var olaPreferences
    @LazyInjected(\.quoteRepository) private var quoteRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository

    typealias AreInIncreasingOrder = (Quote, Quote) -> Bool
    
    public init() {}
    
    public init(quoteRepository: QuoteRepository) {
        self.quoteRepository = quoteRepository
    }
    
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) -> AnyPublisher<[UserQuote], Error> {
            Publishers.Zip(
                userDataRepository.userData,
                (olaPreferences.hasDateChanged ?
                 quoteRepository.findAllQuotes().map {
                     $0.filter({ quote in
                         quote.topics != nil &&
                         quote.language.prefix(2) == Locale.current.identifier.prefix(2) })
                     .shuffled().prefix(isTablet ? 6 : 4)
                 }.map { Array($0) }.eraseToAnyPublisher() :
                    olaPreferences.dailyQuoteIds
                    .flatMap { ids -> AnyPublisher<[Quote], Error> in
                        ids.publisher.flatMap { self.quoteRepository.findQuote(byIdQuote: $0) }
                            .collect().eraseToAnyPublisher()
                    }.eraseToAnyPublisher()
                )
            )
            .map { [self] userData, quotes in
                let dailyQuotes = quotes.sorted { (lhs, rhs) in
                    let predicates: [AreInIncreasingOrder] = [ { $0.quote.count > $1.quote.count }, { $0.topics!.count > $1.topics!.count }, { $0.topics![0].name.count > $1.topics![0].name.count }
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
                    olaPreferences.setDailyQuoteIds(ids: dailyQuotes.map { $0.idQuote })
                }
                                
                return dailyQuotes.map { UserQuote(quote: $0, userData: userData) }
            }
            .eraseToAnyPublisher()
    }
}
