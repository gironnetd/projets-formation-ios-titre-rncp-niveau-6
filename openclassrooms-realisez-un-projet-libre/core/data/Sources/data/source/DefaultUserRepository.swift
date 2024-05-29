//
//  DefaultUserRepository.swift
//  data
//
//  Created by damien on 06/10/2022.
//

import Foundation
import Combine
import model
import cache
import remote
import FirebaseAuth
import Factory
import preferences

public class DefaultUserRepository: UserRepository {
    
    @LazyInjected(\.olaPreferences) private var olaPreferences
    @LazyInjected(\.firebase) private var firebase
    @LazyInjected(\.bookmarkDao) private var bookmarkDao
    @LazyInjected(\.userDao) private var userDao
    
    /// Retrieve current user, from the cache
    ///
    /// - Returns: A User or throws an Error
    public var user: CurrentValueSubject<model.User, Error>!
    
    private var cancellables: Set<AnyCancellable> = Set()

    /// Retrieve current user, from the cache
    ///
    /// - Returns: A User or throws an Error
    public func findCurrentUser() -> AnyPublisher<model.User, Error> {
        self.userDao.findCurrentUser().map { $0.asExternalModel() }.eraseToAnyPublisher()
    }
    
    public init(user: model.User) {
        self.user = CurrentValueSubject(user)
    }
    
    public init() {
        self.userDao.findCurrentUser().sink(
            receiveCompletion: { _ in },
            receiveValue: { user in self.user = CurrentValueSubject(user.asExternalModel()) })
        .store(in: &cancellables)
    }
            
    /// SignIn a User with a AuthProvider
    ///
    /// - Parameters:
    ///   - authProvider: The AuthProvider of the user
    ///
    /// - Returns: A Model User or throws an Error
    public func signIn(with authProvider: AuthProvider) async throws -> model.User {
        let user = try await self.firebase.signIn(with: authProvider)
        olaPreferences.setUidUser(uidUser: user.asCached().uidUser)
        
        try await self.userDao.saveOrUpdate(currentUser: user.asCached())
        
        if let groups = user.bookmarks {
            try await self.bookmarkDao.upsertBookmarkGroups(groups: groups.map({ $0.asCached() }))
            
            for group in groups {
                group.bookmarks?.forEach { olaPreferences.setResourceBookmarked(resourceId: $0.idResource, bookmarked: true) }
            }
        }
        
        self.userDao.findCurrentUser().sink(
            receiveCompletion: { _ in },
            receiveValue: { user in self.user.value = user.asExternalModel() })
        .store(in: &cancellables)
        
        return user.asCached().asExternalModel()
    }
    
    /// SignIn a User with email and password
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: A Model User or throws an Error
    public func signIn(withEmail email: String, password: String) async throws -> model.User {
        let user = try await self.firebase.signIn(withEmail: email, password: password)
        
        olaPreferences.setUidUser(uidUser: user.asCached().uidUser)
        
        try await self.userDao.saveOrUpdate(currentUser: user.asCached())
        
        if let groups = user.bookmarks {
            try await self.bookmarkDao.upsertBookmarkGroups(groups: groups.map({ $0.asCached() }))
            
            for group in groups {
                group.bookmarks?.forEach { olaPreferences.setResourceBookmarked(resourceId: $0.idResource, bookmarked: true) }
            }
        }

        self.userDao.findCurrentUser().sink(
            receiveCompletion: { _ in },
            receiveValue: { user in self.user.value = user.asExternalModel() })
        .store(in: &cancellables)
        
        return user.asCached().asExternalModel()
    }
    
    /// SignOut current User
    ///
    /// - Returns: Void or throws an Error
    public func signOut() async throws -> Void {
        try await self.userDao.deleteCurrentUser()
        
        for group in try await self.bookmarkDao.findAllBookmarkGroups().value {
            if group.location == .remote {
                try await self.bookmarkDao.remove(group: group)
            }
        }
        
        self.bookmarkDao.findAllBookmarkGroups()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [self] groups in
                    olaPreferences.userData.value.bookmarkedResources.forEach { bookmarkedResourceId in
                        if !groups.flatMap({ $0.bookmarks.toArray().map { $0.asExternalModel()} })
                            .map({ $0.idResource }).contains(bookmarkedResourceId) {
                            olaPreferences.setResourceBookmarked(resourceId: bookmarkedResourceId, bookmarked: false)
                        }
                    }
                })
            .store(in: &cancellables)
        
        self.user.value = try await self.userDao.findCurrentUser().value.asExternalModel()
    }
    
    /// Create a User with email and password
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///
    /// - Returns: Void or throws an Error
    public func create(user: model.User, password: String) async throws -> model.User {
        let remotedUser = try await self.firebase.create(user: user.toRemote(), password: password)
        
        try await self.userDao.saveOrUpdate(currentUser: remotedUser.asCached())
        
        olaPreferences.setUidUser(uidUser: user.uidUser)
        
        if let groups = remotedUser.bookmarks {
            for group in groups {
                group.bookmarks?.forEach { olaPreferences.setResourceBookmarked(resourceId: $0.idResource, bookmarked: true) }
            }
        }
        
        self.userDao.findCurrentUser()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { user in self.user.value = user.asExternalModel() })
            .store(in: &cancellables)
        
        return remotedUser.asCached().asExternalModel()
    }
}
