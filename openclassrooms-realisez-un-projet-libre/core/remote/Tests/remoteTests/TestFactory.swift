//
//  TestFactory.swift
//  remoteTests
//
//  Created by damien on 30/09/2022.
//

import Foundation
import util
import FirebaseFirestore

@testable import remote

extension RemoteUser {
    static func testUser() -> RemoteUser {
        RemoteUser(uid: DataFactory.randomString(),
                   providerID: DataFactory.randomString(),
                   email: DataFactory.randomEmail(),
                   displayName: DataFactory.randomString(),
                   photo: DataFactory.randomData(),
                   bookmarks: [])
    }
}

extension RemoteBookmark {
    static func testBookmark() -> RemoteBookmark {
        RemoteBookmark(id: DataFactory.randomString(),
                       idBookmarkGroup: DataFactory.randomString(),
                       idResource: DataFactory.randomString(),
                       kind: DataFactory.randomString(),
                       dateCreation: Timestamp(date: .now))
    }
}

extension RemoteBookmarkGroup {
    static func testBookmarkGroup() -> RemoteBookmarkGroup {
        RemoteBookmarkGroup(id: DataFactory.randomString(),
                            uidUser: DataFactory.randomString(),
                            directoryName: DataFactory.randomString(),
                            groups: [], bookmarks: [RemoteBookmark.testBookmark()])
    }
}
