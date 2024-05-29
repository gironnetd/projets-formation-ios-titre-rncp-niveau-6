//
//  RemoteDataSourceSpec.swift
//  remoteTests
//
//  Created by damien on 15/09/2022.
//

import Foundation
import Quick
import Nimble
import util
import Combine
import FirebaseCore
import FirebaseFirestore
import Factory

@testable import remote

class RemoteDataSourceSpec: QuickSpec {
    
    override func spec() {
        
        var remoteDataSource: OlaRemoteDataSource!
        var firestore: Firestore!

        var user: RemoteUser!
        var userRef: DocumentReference!
        
        var firstBookmarkGroup: RemoteBookmarkGroup!
        var firstBookmarkGroupRef: DocumentReference!
        
        var secondBookmarkGroup: RemoteBookmarkGroup!
        var secondBookmarkGroupRef: DocumentReference!
        
        var thirdBookmarkGroup: RemoteBookmarkGroup!
        var thirdBookmarkGroupRef: DocumentReference!
        
        var fourthBookmarkGroup: RemoteBookmarkGroup!
        var fourthBookmarkGroupRef: DocumentReference!
        
        var fifthBookmarkGroup: RemoteBookmarkGroup!
        var fifthBookmarkGroupRef: DocumentReference!
        
        var batch: WriteBatch!
        
        beforeSuite {
            let path = Bundle.module.url(forResource: "GoogleService-Info", withExtension: "plist")
            let firbaseOptions = FirebaseOptions(contentsOfFile: path!.path)
            
            FirebaseApp.configure(options: firbaseOptions!)
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
        }
        
        beforeEach {
            firestore = Firestore.firestore()
            remoteDataSource = FirestoreRemoteDataSource()
            
            user = RemoteUser.testUser()

            // Get new write batch
            batch = firestore.batch()

            userRef = firestore.collection(Constants.USERS_TABLE).document(user.uid)
            batch.setData(user.dictionary as [String : Any], forDocument: userRef)

            firstBookmarkGroup = RemoteBookmarkGroup.testBookmarkGroup()
            firstBookmarkGroup.uidUser = user.uid
            firstBookmarkGroup.idParent = nil
            
            secondBookmarkGroup = RemoteBookmarkGroup.testBookmarkGroup()
            secondBookmarkGroup.uidUser = user.uid
            secondBookmarkGroup.idParent = firstBookmarkGroup.id
            
            thirdBookmarkGroup = RemoteBookmarkGroup.testBookmarkGroup()
            thirdBookmarkGroup.uidUser = user.uid
            thirdBookmarkGroup.idParent = firstBookmarkGroup.id
            
            fourthBookmarkGroup = RemoteBookmarkGroup.testBookmarkGroup()
            fourthBookmarkGroup.uidUser = UUID().uuidString
            
            fourthBookmarkGroup.idParent = firstBookmarkGroup.id
            
            fifthBookmarkGroup = RemoteBookmarkGroup.testBookmarkGroup()
            fifthBookmarkGroup.uidUser = user.uid
            
            fifthBookmarkGroup.idParent = secondBookmarkGroup.id
            
            firstBookmarkGroupRef = firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).document(firstBookmarkGroup.id)
            batch.setData(firstBookmarkGroup.dictionary as [String : Any], forDocument: firstBookmarkGroupRef)

            secondBookmarkGroupRef = firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).document(secondBookmarkGroup.id)
            batch.setData(secondBookmarkGroup.dictionary as [String : Any], forDocument: secondBookmarkGroupRef)
            
            thirdBookmarkGroupRef = firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).document(thirdBookmarkGroup.id)
            batch.setData(thirdBookmarkGroup.dictionary as [String : Any], forDocument: thirdBookmarkGroupRef)
            
            fourthBookmarkGroupRef = firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).document(fourthBookmarkGroup.id)
            batch.setData(fourthBookmarkGroup.dictionary as [String : Any], forDocument: fourthBookmarkGroupRef)
            
            fifthBookmarkGroupRef = firestore.collection(Constants.BOOKMARK_GROUPS_TABLE).document(fifthBookmarkGroup.id)
            batch.setData(fifthBookmarkGroup.dictionary as [String : Any], forDocument: fifthBookmarkGroupRef)
        }

        afterEach {
            batch = firestore.batch()
            
            batch.deleteDocument(userRef)
            batch.deleteDocument(firstBookmarkGroupRef)
            batch.deleteDocument(secondBookmarkGroupRef)
            batch.deleteDocument(thirdBookmarkGroupRef)
            batch.deleteDocument(fourthBookmarkGroupRef)
            batch.deleteDocument(fifthBookmarkGroupRef)
                    
            _ = try? (batch.commit() as Future<Void, Error>).waitingCompletion()
        }
        
        describe("Find user by uid") {
            context("Found") {
                it("User is returned") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    secondBookmarkGroup.groups?.append(fifthBookmarkGroup)
                    firstBookmarkGroup.groups?.append(contentsOf: [secondBookmarkGroup, thirdBookmarkGroup])
                    user.bookmarks?.append(firstBookmarkGroup)
                    
                    let expectedUser = try await remoteDataSource.findUser(byUid: user.uid)
                    expect { expectedUser }.to(equal(user))
                }
            }
            
            context("Found without favourites") {
                it("User is returned") {
                    batch.deleteDocument(firstBookmarkGroupRef)
                    batch.deleteDocument(secondBookmarkGroupRef)
                    batch.deleteDocument(thirdBookmarkGroupRef)
                    batch.deleteDocument(fourthBookmarkGroupRef)
                    batch.deleteDocument(fifthBookmarkGroupRef)
                    
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    let expectedUser = try await remoteDataSource.findUser(byUid: user.uid)
                    expect { expectedUser }.to(equal(user))
                }
            }
        }
        
        describe("Save or update user") {
            context("Saved") {
                it("Return saved succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    let newUser = RemoteUser.testUser()
                    
                    await expect { try await remoteDataSource.saveOrUpdate(user: newUser) }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.USERS_TABLE)
                            .document(newUser.uid).getDocument(as: RemoteUser.self) { result in
                                switch result {
                                case .success(let user):
                                    expect { user }.to(equal(newUser))
                                    
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                    _ = try? await remoteDataSource.deleteUser(byUid: newUser.uid)
                }
            }
            
            context("Updated") {
                it("Return updated succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    user.displayName = DataFactory.randomString()
                    
                    await expect { try await remoteDataSource.saveOrUpdate(user: user) }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.USERS_TABLE)
                            .document(user.uid).getDocument(as: RemoteUser.self) { result in
                                switch result {
                                case .success(let updatedUser):
                                    user.bookmarks = nil
                                    expect { updatedUser }.to(equal(user))
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                }
            }
        }
        
        describe("Find bookmarks changed") {
            context("Found") {
                it("Return array of RemoteChangeBookmark") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    let newUser = RemoteUser.testUser()
                    
                    await expect { try await remoteDataSource.saveOrUpdate(user: newUser) }.to(beVoid())
                    
                    let newGroup = RemoteBookmarkGroup.testBookmarkGroup()
                    newGroup.uidUser = newUser.uid
                    
                    await expect { try await remoteDataSource.createOrUpdate(group: newGroup) }.to(beVoid())
                    
                    let remoteBookmarkChange = try await remoteDataSource.findBookmarksChanged(uidUser: newUser.uid, after: 0)
                    
                    expect { remoteBookmarkChange.map({ $0.id }) }.to(equal([newGroup.id]))
                    
                    _ = try? await remoteDataSource.deleteUser(byUid: newUser.uid)
                }
            }
        }
        
        describe("Find bookmarks by ids") {
            context("Found") {
                it("Return array of RemoteChangeBookmark") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
//                    let firstBookmark = RemoteBookmark.testBookmark()
//                    let secondBookmark = RemoteBookmark.testBookmark()
//                    let thirdBookmark = RemoteBookmark.testBookmark()
                    
//                    await expect { try await remoteDataSource.createOrUpdate(bookmark: firstBookmark) }.to(beVoid())
//                    await expect { try await remoteDataSource.createOrUpdate(bookmark: secondBookmark) }.to(beVoid())
//                    await expect { try await remoteDataSource.createOrUpdate(bookmark: thirdBookmark) }.to(beVoid())
                    
                    let bookmarkIds = try await remoteDataSource.findBookmarks(ids: [firstBookmarkGroup.id, thirdBookmarkGroup.id]).map({ $0.id }).sorted(by: >)
                    
                    expect { bookmarkIds }.to(equal([firstBookmarkGroup, thirdBookmarkGroup].map({ $0.id }).sorted(by: >) ))
                }
            }
        }
        
        describe("Delete user by uid") {
            context("Found") {
                it("Return deletion succeeded") {
                    firstBookmarkGroup.uidUser = user.uid
                    
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    await expect { try await remoteDataSource.deleteUser(byUid: user.uid) }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.USERS_TABLE).getDocuments() { (querySnapshot, error) in
                            
                            guard let querySnapshot = querySnapshot else {
                                if let error = error {
                                    promise(.failure(error))
                                }
                                return
                            }
                            expect { querySnapshot.documents.compactMap { document in
                                try? document.data(as: RemoteUser.self)
                                }
                            }.notTo(contain(user))
                            promise(.success(()))
                        }
                    }.waitingCompletion()
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    await expect { try await remoteDataSource.deleteUser(byUid: DataFactory.randomString()) }.to(throwError())
                }
            }
        }
        
        describe("Save or update Bookmark") {
            context("Saved") {
                it("Return saved succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    let newBookmark = RemoteBookmark.testBookmark()
                    
                    await expect { try await remoteDataSource.createOrUpdate(bookmark: newBookmark) }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.BOOKMARKS_TABLE)
                            .document(newBookmark.id).getDocument(as: RemoteBookmark.self) { result in
                                switch result {
                                case .success(let bookmark):
                                    expect { bookmark }.to(equal(newBookmark))
                                    
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                    _ = try? await remoteDataSource.remove(bookmark: newBookmark)
                }
            }
            
            context("Updated") {
                it("Return updated succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    firstBookmarkGroup.directoryName = DataFactory.randomString()
                    
                    await expect { try await remoteDataSource.createOrUpdate(group: firstBookmarkGroup) }.to(beVoid())
                    
                    _ = try Future <Void, Error> { promise in
                        firestore.collection(Constants.BOOKMARK_GROUPS_TABLE)
                            .document(firstBookmarkGroup.id).getDocument(as: RemoteBookmarkGroup.self) { result in
                                switch result {
                                case .success(let updatedBookmark):
                                    expect { updatedBookmark.id }.to(equal(firstBookmarkGroup.id))
                                    promise(.success(()))
                                case .failure (let error):
                                    promise(.failure(error))
                                }
                        }
                    }.waitingCompletion()
                }
            }
        }
        
        describe("Delete favourite by idDirectory") {
            context("Found") {
                it("Return deletion succeeded") {
                    _ = try (batch.commit() as Future<Void, Error>).waitingCompletion()
                    
                    await expect { try await remoteDataSource.remove(group: firstBookmarkGroup) }.to(beVoid())
                    
                    _ = try Future<Void, Error> { promise in
                        firestore.collection(Constants.BOOKMARKS_TABLE).getDocuments() { (querySnapshot, error) in
                            guard let querySnapshot = querySnapshot else {
                                if let error = error {
                                    promise(.failure(error))
                                }
                                return
                            }
                            
                            let actual = querySnapshot.documents.compactMap { document in
                                try? document.data(as: RemoteBookmark.self).id
                            }
                            
                            expect { actual }.notTo(contain([firstBookmarkGroup.id, secondBookmarkGroup.id, thirdBookmarkGroup.id,
                                fifthBookmarkGroup.id
                            ]))
                            promise(.success(()))
                        }
                    }.waitingCompletion()
                }
            }
        }
    }
}
