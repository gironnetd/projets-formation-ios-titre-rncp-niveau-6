//
//  UserDaoSpec.swift
//  cacheTests
//
//  Created by damien on 14/09/2022.
//

import Foundation
import Quick
import Nimble
import RealmSwift
import util

@testable import cache

class UserDaoSpec: QuickSpec {
    
    override func spec() {
        var userDatabase: Realm!
        var userDao: UserDao!
        
        var currentUser: CachedUser!
        
        var validConfiguration: Realm.Configuration!
        
        beforeSuite {
            validConfiguration = Realm.Configuration(inMemoryIdentifier: "cached-user-dao-testing")
        }
        
        beforeEach {
            currentUser = CachedUser.testUser()
        }
        
        afterEach {  () -> Void in
            if let userDatabase = userDatabase {
                autoreleasepool {
                    if !userDatabase.configuration.readOnly {
                        try! userDatabase.write {
                            userDatabase.deleteAll()
                            try? userDatabase.commitWrite()
                        }
                    }
                }
            }
        }
        
        describe("Find current user") {
            beforeEach {
                DatabaseModule.realm.register {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    userDatabase = try? Realm()
                    return userDatabase
                }
                userDao = DefaultUserDao()
            }
            
            context("Found") {
                it("User is returned") {  () -> Void in
                    if let realm = (userDao as? DefaultUserDao)?.realm {
                        try? realm.write {
                            realm.add(currentUser)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await userDao.findCurrentUser().value.thaw() }.to(equal(currentUser))
                }
            }
            
            context("Not found") {
                it("Return nil value") {
                    await expect { try await userDao.findCurrentUser().value }.to(throwError())
                }
            }
        }
        
        describe("Save or update current user") {
            beforeEach {
                DatabaseModule.realm.register {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    userDatabase = try? Realm()
                    return userDatabase
                }
                userDao = DefaultUserDao()
            }
            
            context("Updated") {
                it("Return updated succeeded") {  () -> Void in
                    if let realm = (userDao as? DefaultUserDao)?.realm {
                        try? realm.write {
                            realm.add(currentUser)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await userDao.saveOrUpdate(currentUser: currentUser) }.to(beVoid())
                    
                    try userDatabase.write {
                        currentUser.email = DataFactory.randomEmail()
                    }
                    
                    await expect { try await userDao.saveOrUpdate(currentUser: currentUser) }.to(beVoid())
                    await expect { userDatabase.objects(CachedUser.self).toArray() }.to(equal([currentUser]))
                }
            }
        }
        
        describe("Delete current user") {
            beforeEach {
                DatabaseModule.realm.register {
                    Realm.Configuration.defaultConfiguration = validConfiguration
                    userDatabase = try? Realm()
                    return userDatabase
                }
                userDao = DefaultUserDao()
            }
            
            context("Found") {
                it("Return deletion succeeded") {  () -> Void in
                    if let realm = (userDao as? DefaultUserDao)?.realm {
                        try? realm.write {
                            realm.add(currentUser)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await userDao.deleteCurrentUser() }.to(beVoid())
                    
                    expect { currentUser.providerID }.to(equal(""))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    await expect { try await userDao.deleteCurrentUser() }.to(throwError())
                }
            }
        }
    }
}

extension CachedUser {
    
    internal static func testUser() -> CachedUser {
        return CachedUser(id: DataFactory.randomString(),
                          providerID: DataFactory.randomString(),
                          email: DataFactory.randomString(),
                          displayName: DataFactory.randomString(),
                          photo: DataFactory.randomData())
    }
}
