//
//  AuthenticationViewModelSpec.swift
//  authenticationTests
//
//  Created by Damien Gironnet on 31/03/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import domain
import remote
import model
import Factory

@testable import authentication

class AuthenticationViewModelSpec: QuickSpec {
    
    override func spec() {
        var userRepository: UserRepository!
        var viewModel: AuthenticationViewModel!
        var user: User!
        var emailPasswordProvider: model.User!
        var authProviders: [model.User]!
        
        beforeEach {
            user = User(id: DataFactory.randomString(),
                        providerID: AuthProvider.password.rawValue,
                        uidUser: DataFactory.randomString(),
                        email: DataFactory.randomEmail(),
                        displayName: DataFactory.randomString())
            
            emailPasswordProvider =
                model.User(id: UUID().uuidString,
                           providerID: AuthProvider.password.rawValue,
                           uidUser: UUID().uuidString,
                           email: DataFactory.randomEmail())
            
            authProviders = [
                model.User(id: UUID().uuidString,
                           providerID: AuthProvider.apple.rawValue,
                           uidUser: UUID().uuidString),
                model.User(id: UUID().uuidString,
                           providerID: AuthProvider.facebook.rawValue,
                           uidUser: UUID().uuidString),
                model.User(id: UUID().uuidString,
                           providerID: AuthProvider.google.rawValue,
                           uidUser: UUID().uuidString),
                model.User(id: UUID().uuidString,
                           providerID: AuthProvider.twitter.rawValue,
                           uidUser: UUID().uuidString),
                emailPasswordProvider]
            
            userRepository = TestUserRepository(user: user, emailPasswordProvider: emailPasswordProvider, authProviders: authProviders)
            
            DataModule.userRepository.register { userRepository }
                        
            viewModel = AuthenticationViewModel()
        }
        
        describe("Create user with user and password") {
            context("Succeeded") {
                it("User is Returned") {
                    let user = model.User(id: UUID().uuidString,
                                          providerID: AuthProvider.password.rawValue,
                                          uidUser: DataFactory.randomString(),
                                          email: DataFactory.randomEmail(),
                                          displayName: DataFactory.randomString())
                    
                    let _ = try await viewModel.create(user: user, password: DataFactory.randomString())
                    
                    await expect { (userRepository as? TestUserRepository)?.authProviders.map({ $0.providerID }) }.to(contain(user.providerID))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    let user = model.User(id: UUID().uuidString,
                                          providerID: AuthProvider.password.rawValue,
                                          uidUser: DataFactory.randomString(),
                                          email: DataFactory.randomEmail(),
                                          displayName: DataFactory.randomString())
                    
                    await expect { try await viewModel.create(user: user, password: "") }.to(throwError())
                }
            }
        }
        
        describe("SignIn with AuthProvider") {
            context("Succeeded") {
                it("Return Void") {
                    await expect { let _ = try await viewModel.signIn(with: .apple) }.to(beVoid())
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    (userRepository as? TestUserRepository)?.authProviders.removeAll()
                    await expect { try await viewModel.signIn(with: .apple) }.to(throwError())
                }
            }
        }
        
        describe("SignIn with email and password") {
            context("Succeeded") {
                it("Return Void") {
                    await expect { let _ = try await viewModel.signIn(withEmail: emailPasswordProvider.email!, password: DataFactory.randomString()) }.to( beVoid())
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    await expect { try await viewModel.signIn(withEmail: "", password: DataFactory.randomString()) }.to(throwError())
                }
            }
        }
    }
}
