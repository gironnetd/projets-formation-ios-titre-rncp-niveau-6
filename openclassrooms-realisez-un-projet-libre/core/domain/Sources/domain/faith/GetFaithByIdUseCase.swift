//
//  GetFaithByIdUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 14/08/2023.
//

import Foundation
import Combine
import model
import data
import Factory
import common

///
/// A use case which obtains a ``UserFaith`` by  Id
///
@dynamicCallable
public class GetFaithByIdUseCase {
    
    @LazyInjected(\.movementRepository) private var movementRepository
    @LazyInjected(\.userDataRepository) private var userDataRepository

    public init() {}
    
    public init(movementRepository: MovementRepository) {
        self.movementRepository = movementRepository
    }
    
    public func dynamicallyCall(withArguments args: [String]) -> AnyPublisher<UserFaith, Error> {
        guard let idMovement = args.first else {
            return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return Publishers.CombineLatest(
            movementRepository.findMovement(byIdMovement: idMovement),
            userDataRepository.userData)
        .map { faith, userData in UserFaith(faith: faith, userData: userData) }
        .eraseToAnyPublisher()
    }
}
