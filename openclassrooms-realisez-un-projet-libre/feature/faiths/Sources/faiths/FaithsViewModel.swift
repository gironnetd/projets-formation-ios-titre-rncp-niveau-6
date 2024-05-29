//
//  FaithsViewModel.swift
//  faiths
//
//  Created by Damien Gironnet on 08/04/2023.
//

import Foundation
import domain
import model
import remote
import data
import Combine
import Factory

///
/// ObservableObject representing the viewmodel for faiths package
///
internal class FaithsViewModel: ObservableObject {
    
    @LazyInjected(\.getFaithsUseCase) var getFaiths
    @LazyInjected(\.getFaithByIdUseCase) var getFaithById
    
    @Published internal var faithsUiState: FaithsState = .Loading
    
    var cancellables: Set<AnyCancellable> = Set()
    
    init() { }
    
    init(movementRepository: MovementRepository) {
        self.getFaiths = GetFaithsUseCase(movementRepository: movementRepository)
    }
    
    internal func feeds() {
        getFaiths().assertNoFailure().sink { [self] in
            faithsUiState = .Success(feed: $0)
            self.objectWillChange.send()
        }.store(in: &cancellables)
    }
}

internal enum FaithsState {
    case Loading
    case Success(feed: [UserFaith])
}
