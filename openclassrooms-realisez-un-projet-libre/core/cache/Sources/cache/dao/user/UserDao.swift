//
//  UserDao.swift
//  cache
//
//  Created by damien on 27/08/2022.
//  Copyright © 2022 damien. All rights reserved.
//

import Foundation
import Combine
import model

///
/// Protocol defining methods for the Data Access Object of Users.
///
public protocol UserDao {
    
    var user: CurrentValueSubject<CachedUser, Error>! { get set }
    
    /// Retrieve current user, from the cache
    ///
    /// - Returns: A Future returning an ``CachedUser`` or an Error
    func findCurrentUser() -> Future<CachedUser, Error>
    
    /// Save or update current user to the cache
    ///
    /// - Parameters:
    ///   - currentUser: A ``CachedUser``
    func saveOrUpdate(currentUser: CachedUser) async throws

    /// Delete current user to the cache
    func deleteCurrentUser() async throws
}
