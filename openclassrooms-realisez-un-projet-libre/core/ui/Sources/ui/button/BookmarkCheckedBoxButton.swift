//
//  BookmarkGroupCheckedBoxButton.swift
//  ui
//
//  Created by Damien Gironnet on 27/10/2023.
//

import SwiftUI
import model
import designsystem
import common

public struct BookmarkGroupCheckedBoxButton: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject private var group: BookmarkGroup
    private let resource: UserResource
    private var bookmark: Bookmark
    private let onClick: (Bookmark, Bool) -> Void
    
    public init(group: BookmarkGroup,
                resource: UserResource,
                onClick: @escaping (Bookmark, Bool) -> Void) {
        self.group = group
        self.onClick = onClick
        self.resource = resource
        
        if let bookmark = group.bookmarks
            .first(where: { $0.idResource == resource.id }) {
            self.bookmark = bookmark
        } else {
            let kind: ResourceKind = switch resource {
            case _ as UserQuote:
               .quote
            case _ as UserPicture:
               .picture
            case _ as UserBiography:
               .biography
            default:
               .unknown
            }
            
            self.bookmark = Bookmark(
                id: UUID().uuidString,
                idBookmarkGroup: group.id,
                idResource: resource.id,
                kind: kind,
                dateCreation: .now)
        }
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            CheckBoxButton(
                label: group.id == "-1" ?
                "reading_list".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem) : group.directoryName,
                isChecked: group.bookmarks.contains(self.bookmark),
                onClick: { isChecked in
                    if isChecked {
                        resource.isSaved.value = true
                        group.bookmarks.append(self.bookmark)
                    } else {
                        if let index = group.bookmarks.firstIndex(where: { $0 == bookmark }) {
                            group.bookmarks.remove(at: index)
                        }
                    }
                    onClick(bookmark, isChecked)
                })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}
