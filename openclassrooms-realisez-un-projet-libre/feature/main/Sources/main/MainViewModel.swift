//
//  MainViewModel.swift
//  main
//
//  Created by Damien Gironnet on 21/11/2023.
//

import Foundation
import model
import data
import Factory
import Combine
import SwiftUI

public class MainViewModel: ObservableObject {
    
    @LazyInjected(\.userRepository) var userRepository

    @Published public var user: model.User!
    
    var cancellables: Set<AnyCancellable> = Set()
    
    public init() {
        userRepository.user.assertNoFailure().sink(receiveValue: { self.user = $0 }).store(in: &cancellables)
    }
}

