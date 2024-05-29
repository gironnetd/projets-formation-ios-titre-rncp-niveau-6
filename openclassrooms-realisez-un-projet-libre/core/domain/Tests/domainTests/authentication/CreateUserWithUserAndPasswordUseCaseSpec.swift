//
//  CreateUserWithUserAndPasswordUseCaseSpec.swift
//  domainTests
//
//  Created by Damien Gironnet on 29/03/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import remote
import Factory
import model

@testable import domain

class CreateUserWithUserAndPasswordUseCaseSpec: QuickSpec {
    
    @LazyInjected(DataModule.userRepository) private var userRepository
    
    override func spec() {
        
        var useCase: CreateUserWithUserAndPasswordUseCase!
        
        beforeEach {
            DataModule.userRepository.register {
                TestUserRepository(
                    user: User(id: DataFactory.randomString(),
                               providerID: DataFactory.randomString(),
                               uidUser: DataFactory.randomString(),
                               email: DataFactory.randomEmail(),
                               displayName: DataFactory.randomString(),
                               photo: nil,
                               bookmarks: []))
            }
            useCase = CreateUserWithUserAndPasswordUseCase()
        }
        
        describe("Create user with user and password") {
            context("Succeeded") {
                it("User is Returned") {
                    let user = model.User(id: UUID().uuidString,
                                          providerID: AuthProvider.password.rawValue,
                                          uidUser: UUID().uuidString,
                                          email: DataFactory.randomEmail(),
                                          displayName: DataFactory.randomString())
                    
                    try await useCase(with: (user: user, password: DataFactory.randomString()))
                    
                    await expect { (self.userRepository as? TestUserRepository)?.authProviders }.to(contain(user))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    let user = model.User(id: UUID().uuidString,
                                          providerID: AuthProvider.password.rawValue,
                                          uidUser: UUID().uuidString,
                                          email: DataFactory.randomEmail(),
                                          displayName: DataFactory.randomString())
                    
                    await expect { try await useCase(with: (user: user, password: "")) }.to(throwError())
                }
            }
        }
    }
}
