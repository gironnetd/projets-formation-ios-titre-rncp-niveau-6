//
//  DefaultBookmarkRepository.swift
//  data
//
//  Created by Damien Gironnet on 14/11/2023.
//

import Foundation
import Combine
import model
import cache
import Factory
import remote
import remote
import preferences

public class DefaultBookmarkRepository: BookmarkRepository {
    
    @LazyInjected(\.networkMonitor) private var networkMonitor
    @LazyInjected(\.userDataRepository) private var userDataRepository
    @LazyInjected(\.olaPreferences) private var olaPreferences
    @LazyInjected(\.firestore) private var firestore
    @LazyInjected(\.bookmarkDao) private var bookmarkDao
    
    private var cancellables: Set<AnyCancellable> = Set()

    public func findAllBookmarks() -> AnyPublisher<[model.Bookmark], Error> {
        self.bookmarkDao.findAllBookmarks().map { $0.map { $0.asExternalModel()} }.eraseToAnyPublisher()
    }
    
    public func findAllBookmarkGroups() -> AnyPublisher<[model.BookmarkGroup], Error> {
        self.bookmarkDao.findAllBookmarkGroups().map { $0.filter { group in self.networkMonitor.isOnline.value ? true : group.location != .remote }.map { $0.asExternalModel()} }.eraseToAnyPublisher()
    }

    public func updateResourceBookmarked(bookmark: Bookmark, bookmarked: Bool) async throws {
        try await self.bookmarkDao.updateResourceBookmarked(bookmark: bookmark.asCached(), bookmarked: bookmarked)
        
        if bookmarked {
            olaPreferences.setResourceBookmarked(resourceId: bookmark.idResource, bookmarked: bookmarked)
        } else {
            let bookmarks = try await self.bookmarkDao.findAllBookmarks().value.map({ $0.asExternalModel() })
            
            if !bookmarks.map({ $0.idResource }).contains(bookmark.idResource) {
                olaPreferences.setResourceBookmarked(resourceId: bookmark.idResource, bookmarked: false)
            }
        }
        
        if let group = try await self.bookmarkDao.findAllBookmarkGroups().value.first(where: { $0.id == bookmark.idBookmarkGroup }) {
            if group.location == .remote || group.location == .shared {
                if bookmarked {
                    try await firestore.createOrUpdate(bookmark: bookmark.toRemote())
                } else {
                    try await firestore.remove(bookmark: bookmark.toRemote())
                }
            }
        }
    }
    
    public func createOrUpdate(group: BookmarkGroup) async throws {
        try await self.bookmarkDao.createOrUpdate(group: group.asCached())
        
        self.userDataRepository.userData.sink(
            receiveCompletion: { _ in },
            receiveValue: { [self] userData in
                if let uidUser = userData.uidUser {
                    let remotedGroup = group.toRemote(uidUser: uidUser)
                    remotedGroup.changeBookmakGroupVersion = olaPreferences.getChangeBookmarkVersions().bookmarkVersion
                    if group.location == .remote || group.location == .shared  {
                        Task {
                            try await firestore.createOrUpdate(group: remotedGroup)
                        }
                    }
                }
            }).store(in: &cancellables)
    }
    
    public func remove(group: BookmarkGroup) async throws {
        if group.location == .remote || group.location == .shared {
            self.userDataRepository.userData.sink(
                receiveCompletion: { _ in },
                receiveValue: { [self] userData in
                    if let uidUser = userData.uidUser {
                        Task {
                            try await firestore.remove(group: group.toRemote(uidUser: uidUser))
                        }
                    }
                }).store(in: &cancellables)
        }

        try await self.bookmarkDao.remove(group: group.asCached())
    }
    
    public func update(bookmark: model.Bookmark) async throws {
        try await self.bookmarkDao.update(bookmark: bookmark.asCached())
        
        if let group = try await self.bookmarkDao.findAllBookmarkGroups().value.first(where: { $0.id == bookmark.idBookmarkGroup }) {
            if group.location == .remote || group.location == .shared {
                try await firestore.createOrUpdate(bookmark: bookmark.toRemote())
            }
        }
    }
    
    @MainActor
    public func syncWith(synchronizer: Synchronizer) async throws -> Bool {
        try await synchronizer.changeBookmarkSync (
            versionReader: { $0.bookmarkVersion },
            changeBookmarksFetcher: { uidUser, currentVersion in
                try await firestore.findBookmarksChanged(uidUser: uidUser, after: currentVersion)
            },
            versionUpdater: { latestVersion in
                ChangeBookmarkVersions(latestVersion)
            },
            modelDeleter: bookmarkDao.deleteBookmarkGroups,
            modelUpdater: { changedIds in
                let remoteGroups = try await firestore.findBookmarks(ids: changedIds)
                try await bookmarkDao.upsertBookmarkGroups(groups: remoteGroups.map({ $0.asCached() }))
                
                for group in remoteGroups.map({ $0.asCached() }) {
                    group.bookmarks.map({ $0.asExternalModel() }).forEach { olaPreferences.setResourceBookmarked(resourceId: $0.idResource, bookmarked: true) }
                }
            })
    }
}
