//
//  GetCenturiesUseCase.swift
//  domain
//
//  Created by Damien Gironnet on 17/05/2023.
//

import Foundation
import Combine
import model
import data
import Factory

///
/// A use case which obtains an exhaustive Array of  Century
///
@dynamicCallable
public class GetCenturiesUseCase {
    
    @LazyInjected(\.centuryRepository) private var centuryRepository
    
    public init() {}
    
    public init(centuryRepository: CenturyRepository) {
        self.centuryRepository = centuryRepository
    }
    
    public func dynamicallyCall(withArguments args: [Any]) -> AnyPublisher<[Century], Error> {
        centuryRepository.findAllCenturies().eraseToAnyPublisher()
    }
}
