//
//  SignInWithAuthProviderUseCaseSpec.swift
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

class SignInWithAuthProviderUseCaseSpec: QuickSpec {
    
    @LazyInjected(DataModule.userRepository) private var userRepository
    
    override func spec() {
        
        var useCase: SignInWithAuthProviderUseCase!
        
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
            useCase = SignInWithAuthProviderUseCase()
        }
        
        describe("SignIn with AuthProvider") {
            context("Succeeded") {
                it("User is Returned") {
                    let user = try await useCase(.apple)
                    
                    expect { user }.to(equal((DataModule.userRepository.callAsFunction() as? TestUserRepository)?.authProviders.first(where: { user in user.providerID == AuthProvider.apple.rawValue })))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    (self.userRepository as? TestUserRepository)?.authProviders.removeAll()
                    await expect { try await useCase(.apple) }.to(throwError())
                }
            }
        }
    }
}
