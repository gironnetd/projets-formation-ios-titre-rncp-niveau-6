//
//  TestUserDao.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Combine
import cache
import util

class TestUserDao: UserDao {
    internal var currentUser: CachedUser?
    
    var user: CurrentValueSubject<cache.CachedUser, Error>!
    
    public init() {
        self.currentUser = CachedUser(id: DataFactory.randomString(), providerID: DataFactory.randomString())
        self.user = CurrentValueSubject(currentUser!)
    }
    
    func findCurrentUser() -> Future<cache.CachedUser, Error> {
        Future { [self] promise in
            guard currentUser != nil else {
                return promise(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
             
            promise(.success(currentUser!))
        }
    }
    
    func updateResourceBookmarked(bookmark: CachedBookmark, bookmarked: Bool) async throws {
        
    }
    
    func createOrUpdate(group: CachedBookmarkGroup) async throws {
        
    }
    
    func remove(group: CachedBookmarkGroup) async throws {
        
    }
    
    func update(bookmark: CachedBookmark) async throws {
        
    }
    
    func findCurrentUser() async throws -> CachedUser {
        guard let currentUser = self.currentUser else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return currentUser
    }
    
    func saveOrUpdate(currentUser: cache.CachedUser) async throws {
        self.currentUser = currentUser
    }

    func deleteCurrentUser() async throws -> Void {
        guard self.currentUser != nil else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        self.currentUser?.providerID = ""
    }
}
