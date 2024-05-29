//
//  BookmarkRepositorySpec.swift
//  dataTests
//
//  Created by Damien Gironnet on 11/10/2023.
//

import Foundation
import Quick
import Nimble
import util
import remote
import cache
import model
import Factory
import analytics
import preferences

@testable import data

@MainActor
class BookmarkRepositorySpec: QuickSpec {
    
    @LazyInjected(DataModule.networkMonitor) private var networkMonitor
    @LazyInjected(DaosModule.bookmarkDao) private var bookmarkDao

    override func spec() {
        
        var bookmarkRepository: DefaultBookmarkRepository!
        
        var firstGroup: BookmarkGroup!
        var secondGroup: BookmarkGroup!
        var thirdGroup: BookmarkGroup!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.bookmarkDao.register(factory: { TestBookmarkDao() })
            self.networkMonitor.isOnline.value = true
        }
        
        beforeEach {
            bookmarkRepository = DefaultBookmarkRepository()
            
            firstGroup = BookmarkGroup.testGroup()
            secondGroup = BookmarkGroup.testGroup()
            thirdGroup = BookmarkGroup.testGroup()
        }
        
        afterEach { @MainActor () -> Void in
            (self.bookmarkDao as? TestBookmarkDao)?.groups = []
        }
        
        describe("Find all groups") {
            context("Found") {
                it("All groups are returned") { @MainActor () -> Void in
                    (self.bookmarkDao as? TestBookmarkDao)?.groups.append(contentsOf: [firstGroup.asCached(), secondGroup.asCached(), thirdGroup.asCached()])
                    let expected = try bookmarkRepository.findAllBookmarkGroups().waitingCompletion().first
                    
                    await expect { expected }.to(equal([firstGroup, secondGroup, thirdGroup]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    await expect { try bookmarkRepository.findAllBookmarkGroups().waitingCompletion().first }.to(throwError())
                }
            }
        }
    
        describe("Find all bookmarks") {
            context("Found") {
                it("All groups are returned") { @MainActor () -> Void in
                    (self.bookmarkDao as? TestBookmarkDao)?.groups.append(firstGroup.asCached())
                    await expect { try bookmarkRepository.findAllBookmarks().waitingCompletion().first }.to(equal(firstGroup.bookmarks))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    await expect { try bookmarkRepository.findAllBookmarks().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Update Resource Bookmark ") {
            context("Added") {
                it("Bookmark is added") { @MainActor () -> Void in
                    (self.bookmarkDao as? TestBookmarkDao)?.groups.append(firstGroup.asCached())
                    
                    let bookmark = Bookmark.testBookmark()
                    bookmark.idBookmarkGroup = firstGroup.id
                    
                    await expect { try await bookmarkRepository.updateResourceBookmarked(bookmark: bookmark, bookmarked: true) }.to(beVoid())
                    
                    let expected: CachedBookmarkGroup! = (self.bookmarkDao as? TestBookmarkDao)!.groups.first(where: { $0.id == firstGroup.id })

                    expect { expected.bookmarks.toArray().map({ $0.asExternalModel() }) }.to(contain(bookmark))
                }
            }
            
            context("Deleted") {
                it("Bookmark is deleted") { @MainActor () -> Void in
                    let bookmark = Bookmark.testBookmark()
                    bookmark.idBookmarkGroup = firstGroup.id
                    
                    firstGroup.bookmarks.append(bookmark)
                    
                    (self.bookmarkDao as? TestBookmarkDao)?.groups.append(firstGroup.asCached())
                    
                    await expect { try await bookmarkRepository.updateResourceBookmarked(bookmark: bookmark, bookmarked: false) }.to(beVoid())
                    
                    let expected: CachedBookmarkGroup! = (self.bookmarkDao as? TestBookmarkDao)!.groups.first(where: { $0.id == firstGroup.id })
                    
                     expect { expected.bookmarks.toArray().map({ $0.asExternalModel() }) }.toNot(contain(bookmark))
                }
            }
        }
                
        describe("Create or update group") {
            context("Create") {
                it("Group is created") { @MainActor () -> Void in
                    let group = BookmarkGroup.testGroup()
                    
                    await expect { try await bookmarkRepository.createOrUpdate(group: group) }.to(beVoid())
                    expect { (self.bookmarkDao as? TestBookmarkDao)!.groups.map({ $0.asExternalModel() }) }.to(contain(group))
                }
            }
            
            context("Update") {
                it("Group id updated") { @MainActor () -> Void in
                    (self.bookmarkDao as? TestBookmarkDao)?.groups.append(firstGroup.asCached())
                    
                    firstGroup.location = .shared
                    firstGroup.directoryName = DataFactory.randomString()
                    firstGroup.shortDescription = DataFactory.randomString()
                    
                    await expect { try await bookmarkRepository.createOrUpdate(group: firstGroup) }.to(beVoid())
                    
                    let expected: CachedBookmarkGroup! = (self.bookmarkDao as? TestBookmarkDao)!.groups.first(where: { $0.id == firstGroup.id })
                    
                    expect { expected.asExternalModel() }.to(equal(firstGroup))
                }
            }
        }
        
        describe("Remove group") {
            context("Removed") {
                it("Group is removed") { @MainActor () -> Void in
                    (self.bookmarkDao as? TestBookmarkDao)?.groups.append(firstGroup.asCached())
                    
                    await expect { try await bookmarkRepository.remove(group: firstGroup) }.to(beVoid())
                    expect { (self.bookmarkDao as? TestBookmarkDao)!.groups.map({ $0.asExternalModel() }) }.toNot(contain(firstGroup))
                }
            }
        }

        describe("Update bookmark") {
            context("Updated") {
                it("Bookmark is updated") { @MainActor () -> Void in
                    (self.bookmarkDao as? TestBookmarkDao)?.groups.append(firstGroup.asCached())
                    
                    firstGroup.bookmarks[0].idBookmarkGroup = firstGroup.id
                    firstGroup.bookmarks[0].note = DataFactory.randomString()
                    
                    await expect { try await bookmarkRepository.update(bookmark: firstGroup.bookmarks[0]) }.to(beVoid())
                    
                    let expected: CachedBookmarkGroup! = (self.bookmarkDao as? TestBookmarkDao)!.groups.first(where: { $0.id == firstGroup.id })
                    
                    expect { expected.bookmarks[0].asExternalModel().note }.to(equal(firstGroup.bookmarks[0].note))
                }
            }
        }
    }
}
