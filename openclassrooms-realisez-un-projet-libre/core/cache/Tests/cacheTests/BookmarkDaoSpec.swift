//
//  BookmarkDaoSpec.swift
//  cacheTests
//
//  Created by Damien Gironnet on 13/12/2023.
//

import Foundation
import Quick
import Nimble
import RealmSwift
import util

@testable import cache

class BookmarkDaoSpec: QuickSpec {
    
    override func spec() {
        var bookmarkDatabase: Realm!
        var bookmarkDao: BookmarkDao!
        
        var firstGroup: CachedBookmarkGroup!
        var secondGroup: CachedBookmarkGroup!
        var thirdGroup: CachedBookmarkGroup!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-bookmark-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                bookmarkDatabase = try? Realm()
                return bookmarkDatabase
            }
            
            bookmarkDao = DefaultBookmarkDao()
            firstGroup = CachedBookmarkGroup.testBookmarkGroup()
            secondGroup = CachedBookmarkGroup.testBookmarkGroup()
            thirdGroup = CachedBookmarkGroup.testBookmarkGroup()
        }
        
        afterEach {
            if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find all bookmarks") {
            context("Found") {
                it("All bookmarks are returned") {
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            realm.add(firstGroup.bookmarks.toArray(), update: .all)
                            realm.add(secondGroup.bookmarks.toArray(), update: .all)
                            realm.add(thirdGroup.bookmarks.toArray(), update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookmarkDao.findAllBookmarks().value.map({ $0.thaw() }) }.to(equal([firstGroup.bookmarks.toArray(), secondGroup.bookmarks.toArray(), thirdGroup.bookmarks.toArray()].flatMap({ $0 })))
                }
            }
        }
    
        describe("Find all groups") {
            context("Found") {
                it("All groups are returned") {
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            realm.add([firstGroup, secondGroup, thirdGroup], update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookmarkDao.findAllBookmarkGroups().value.map({ $0.thaw() }) }.to(equal([firstGroup, secondGroup, thirdGroup]))
                }
            }
        }
        
        describe("Update Resource Bookmark ") {
            context("Added") {
                it("Bookmark is added") {
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            realm.add(firstGroup, update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    let bookmark = CachedBookmark.testBookmark()
                    bookmark.idBookmarkGroup = firstGroup.id
                    
                    await expect { try await bookmarkDao.updateResourceBookmarked(bookmark: bookmark, bookmarked: true) }.to(beVoid())
                    
                    let expected: CachedBookmarkGroup! = bookmarkDatabase.objects(CachedBookmarkGroup.self).first(where: { $0.id == firstGroup.id })

                    expect { expected.bookmarks }.to(contain(bookmark))
                }
            }
            
            context("Deleted") {
                it("Bookmark is deleted") {
                    let bookmark = CachedBookmark.testBookmark()
                    bookmark.idBookmarkGroup = firstGroup.id
                    
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            firstGroup.bookmarks.append(bookmark)
                            realm.add(firstGroup, update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookmarkDao.updateResourceBookmarked(bookmark: bookmark, bookmarked: false) }.to(beVoid())
                    
                    let expected: CachedBookmarkGroup! = bookmarkDatabase.objects(CachedBookmarkGroup.self).first(where: { $0.id == firstGroup.id })
                    
                     expect { expected.bookmarks }.toNot(contain(bookmark))
                }
            }
        }
                
        describe("Create or update group") {
            context("Create") {
                it("Group is created") {
                    let group = CachedBookmarkGroup.testBookmarkGroup()
                    
                    await expect { try await bookmarkDao.createOrUpdate(group: group) }.to(beVoid())
                    
                    let expected: [CachedBookmarkGroup]! = bookmarkDatabase.objects(CachedBookmarkGroup.self).toArray()

                    await expect { expected }.to(contain(group))
                }
            }
            
            context("Update") {
                it("Group id updated") {
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            realm.add(firstGroup, update: .all)
                            
                            firstGroup.location = .shared
                            firstGroup.directoryName = DataFactory.randomString()
                            firstGroup.shortDescription = DataFactory.randomString()
                            
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookmarkDao.createOrUpdate(group: firstGroup) }.to(beVoid())
                    
                    let expected: CachedBookmarkGroup! = bookmarkDatabase.objects(CachedBookmarkGroup.self).first(where: { $0.id == firstGroup.id })
                    
                    await expect { expected }.to(equal(firstGroup))
                }
            }
        }
        
        describe("Remove group") {
            context("Removed") {
                it("Group is removed") {
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            realm.add(firstGroup, update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookmarkDao.remove(group: firstGroup) }.to(beVoid())
                    
                    let expected: [CachedBookmarkGroup]! = bookmarkDatabase.objects(CachedBookmarkGroup.self).toArray()
                    
                    await expect { expected }.toNot(contain(firstGroup))
                }
            }
        }

        describe("Update bookmark") {
            context("Updated") {
                it("Bookmark is updated") {
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            realm.add(firstGroup, update: .all)
                            firstGroup.bookmarks[0].note = DataFactory.randomString()
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookmarkDao.update(bookmark: firstGroup.bookmarks[0]) }.to(beVoid())
                    
                    let expected: CachedBookmarkGroup! = bookmarkDatabase.objects(CachedBookmarkGroup.self).first(where: { $0.id == firstGroup.id })
                    
                    expect { expected.bookmarks[0] }.to(equal(firstGroup.bookmarks[0]))
                }
            }
        }
        
        describe("Delete groups by id") {
            context("Deleted") {
                it("Groups are deleted") {
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            realm.add([firstGroup, secondGroup, thirdGroup], update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookmarkDao.deleteBookmarkGroups(ids: [secondGroup, thirdGroup].map({ $0.id })) }.to(beVoid())
                    
                    let expected: [CachedBookmarkGroup]! = bookmarkDatabase.objects(CachedBookmarkGroup.self).toArray()
                    
                    await expect { expected }.toNot(contain([secondGroup, thirdGroup]))
                }
            }
        }
                
        describe("Upsert groups") {
            context("Upserted") {
                it("Groups are upserted") {
                    if let realm = (bookmarkDao as? DefaultBookmarkDao)?.realm {
                        try? realm.write {
                            realm.add([firstGroup], update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookmarkDao.upsertBookmarkGroups(groups: [secondGroup]) }.to(beVoid())
                    
                    let expected: [CachedBookmarkGroup]! = bookmarkDatabase.objects(CachedBookmarkGroup.self).toArray()
                    
                    await expect { expected }.to(contain([secondGroup]))
                }
            }
        }
    }
}

extension CachedBookmarkGroup {
    internal static func testBookmarkGroup() -> CachedBookmarkGroup {
        CachedBookmarkGroup(id: DataFactory.randomString(),
                            location: .device,
                            directoryName: DataFactory.randomString(),
                            groups: List(),
                            bookmarks: [CachedBookmark.testBookmark(), CachedBookmark.testBookmark()].toList())
    }
}

extension CachedBookmark {
    internal static func testBookmark() -> CachedBookmark {
        CachedBookmark(id: DataFactory.randomString(),
                       idBookmarkGroup:  DataFactory.randomString(),
                       note:  DataFactory.randomString(),
                       idResource:  DataFactory.randomString(),
                       kind: .unknown,
                       dateCreation: .now)
    }
}
