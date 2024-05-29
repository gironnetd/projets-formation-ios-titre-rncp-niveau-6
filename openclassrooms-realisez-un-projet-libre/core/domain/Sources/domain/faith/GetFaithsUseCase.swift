//
//  GetFaithsUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import Combine
import model
import data
import Factory
import common

///
/// A use case which obtains an exhaustive Array of ``UserFaith``
///
@dynamicCallable
public class GetFaithsUseCase {
    
    @LazyInjected(\.movementRepository) private var movementRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository

    public init() {}
    
    public init(movementRepository: MovementRepository) {
        self.movementRepository = movementRepository
    }
    
    public func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, String>) -> AnyPublisher<[UserFaith], Error> {
        Publishers.Zip(
            movementRepository.findMainMovements(),
            userDataRepository.userData)
            .map { movements, userData in
                movements.filter({ movement in movement.language.prefix(2) == Locale.current.identifier.prefix(2) })
                    .reduce(into: [Movement]()) { result, mainMovement in
                        if mainMovement.nbTotalQuotes != 0 {
                            var final = mainMovement
                            
                            if final.movements != nil {
                                var m = final
                                m.movements = [Movement]()
                                let movement = final.movements!.reduce(into: m) { r, movement in
                                    if movement.nbTotalQuotes != 0 {
                                        var tmp = movement
                                        var final = movement
                                        
                                        tmp.movements = nil
                                        
                                        final.movements?.insert(tmp, at: 0)
                                        
                                        r.movements?.append(final)
                                    }
                                }
                                final = movement
                            }
                            
                            var tmp = mainMovement
                            tmp.movements = nil
                            
                            final.movements?.insert(tmp, at: 0)
                            
                            result.append(final)
                        }
                    }.map { faith in UserFaith(faith: faith, userData: userData) }
            }.eraseToAnyPublisher()
    }
}
