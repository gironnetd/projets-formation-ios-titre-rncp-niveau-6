//
//  SignInWithEmailAndPasswordUseCaseSpec.swift
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
import model
import Factory

@testable import domain

class SignInWithEmailAndPasswordUseCaseSpec: QuickSpec {
    
    @LazyInjected(DataModule.userRepository) private var userRepository
    
    override func spec() {
        
        var useCase: SignInWithEmailAndPasswordUseCase!
        
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
            useCase = SignInWithEmailAndPasswordUseCase()
        }
        
        describe("SignIn with email and password") {
            context("Succeeded") {
                it("User is Returned") {
                    let email = DataFactory.randomEmail()
                    (self.userRepository as? TestUserRepository)?.emailPasswordProvider.email = email
                    let user = try await useCase(email: email, password: DataFactory.randomString())
                    
                    expect { user }.to( equal((self.userRepository as? TestUserRepository)?.emailPasswordProvider))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    await expect { try await useCase(email: "", password: DataFactory.randomString()) }.to(throwError())
                }
            }
        }
    }
}
