//
//  UserRepositorySpec.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Quick
import Nimble
import util
import remote
import cache
import model
import FirebaseAuth
import Factory
import Combine

@testable import data

@MainActor
class UserRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.userDao) private var userDao
    @LazyInjected(RemoteModule.firebase) private var firebase
    
    override func spec() {
        
        var userRepository: DefaultUserRepository!

        var currentUser: RemoteUser!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.userDao.register(factory: { TestUserDao() })
            RemoteModule.firebase.register(factory: { TestOlaRemoteFirebase() })
        }
        
        beforeEach {
            currentUser = RemoteUser.testUser()
            userRepository = DefaultUserRepository(user: currentUser!.asCached().asExternalModel())
        }
        
        afterEach { @MainActor () -> Void in
            (self.firebase as? TestOlaRemoteFirebase)?.currentUser = nil
            (self.firebase as? TestOlaRemoteFirebase)?.emailPassword = []
            (self.firebase as? TestOlaRemoteFirebase)?.users = []
            (self.userDao as? TestUserDao)?.currentUser = nil
        }
        
        describe("Signin with AuthProvider") {
            context("Found") {
                it("Return user succeeded") {
                    let email = DataFactory.randomEmail()
                    currentUser.email = email
                    currentUser.providerID = "password"

                    await (self.firebase as? TestOlaRemoteFirebase)?.currentUser = currentUser

                    await expect {
                        try await userRepository.signIn(with: .twitter)
                    }.to(equal(currentUser.asCached().asExternalModel()))
                }
            }

            context("Not found") {
                it("Error is thrown") {
                    let email = DataFactory.randomEmail()
                    currentUser.email = email

                    await (self.firebase as? TestOlaRemoteFirebase)?.currentUser = nil
                    
                    await expect {
                        try await userRepository.signIn(with: .twitter)
                    }.to(throwError())
                }
            }
        }
        
        describe("Signin with email and password") {
            context("Found") {
                it("Return user succeeded") {
                    let email = DataFactory.randomEmail()
                    let password = DataFactory.randomString()
                    currentUser.email = email

                    await (self.firebase as? TestOlaRemoteFirebase)?.currentUser = currentUser

                    await expect {
                        try await userRepository.signIn(withEmail: email, password: password)
                    }.to(equal(currentUser.asCached().asExternalModel()))
                }
            }

            context("Not found") {
                it("Error is thrown") {
                    let email = DataFactory.randomEmail()
                    currentUser.email = email

                    await expect {
                        try await userRepository.signIn(with: .twitter)
                    }.to(throwError())
                }
            }
        }
        
        describe("Signout") {
            context("Succeeded") {
                it("Return signout succeeded") { @MainActor () -> Void in
                    (self.firebase as? TestOlaRemoteFirebase)?.currentUser = currentUser
                    (self.userDao as? TestUserDao)?.currentUser = currentUser.asCached()
                    
                    await expect { try await userRepository.signOut() }.to(throwError())
                }
            }
            
            context("Already signout") {
                it("Error is thrown") {
                    await expect {
                        try await userRepository.signOut()
                    }.to(throwError())
                }
            }
        }
        
        describe("Create user with email and password") {
            context("Saved") {
                it("Return user succeeded") {
                    let email = DataFactory.randomEmail()
                    let password = DataFactory.randomString()
                    
                    await expect {
                        _ = try await userRepository.create(
                            user: model.User(
                                id: UUID().uuidString,
                                providerID: AuthProvider.password.rawValue,
                                uidUser: DataFactory.randomString(),
                                email: email),
                            password: password)
                    }.to(beVoid())
                }
            }
        }
        
        describe("Find current user") {
            context("Found") {
                it("Return user succeeded") { @MainActor () -> Void in
                    (self.userDao as? TestUserDao)?.currentUser = currentUser.asCached()
                    
                    await expect {
                        try userRepository.findCurrentUser().waitingCompletion().first }.to(equal(currentUser.asCached().asExternalModel()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    await expect {
                        try userRepository.findCurrentUser().waitingCompletion().first
                    }.to(throwError())
                }
            }
        }
    }
}
