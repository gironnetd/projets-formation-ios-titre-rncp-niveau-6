//
//  BookmarkableUserResourcesGrid.swift
//  ui
//
//  Created by Damien Gironnet on 19/11/2023.
//

import SwiftUI
import common
import designsystem
import model
import Combine

public struct BookmarkableUserResourcesGrid: View {
    
    /// EnvironmentObject for orientation
    @StateObject private var orientation: Orientation = Orientation.shared
    
    private let resources: [BookmarkableUserResource]
    private let onTopicClick: (FollowableTopic) -> Void
    private let onToggleBookmark: (UserResource) -> Void
    
    public init(resources: [BookmarkableUserResource],
                onToggleBookmark: @escaping (UserResource) -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.resources = resources
        self.onTopicClick = onTopicClick
        self.onToggleBookmark = onToggleBookmark
    }
    
    public var body: some View {
        if isTablet || orientation.current.isLandscape {
            VerticalStaggeredGrid<[BookmarkableUserResource], BookmarkableUserResourceCard>(
                columns: Columns(
                    columns: resources.map { resource in
                        ColumnElement(
                            uid: resource.resource.uid,
                            content: BookmarkableUserResourceCard(
                                bookmarkableUserResource: resource,
                                onToggleBookmark: onToggleBookmark,
                                onClick: {},
                                onTopicClick: onTopicClick)) },
                    numberOfColumns: isTablet && orientation.current.isLandscape ? 3 : 2
                ),
                computationTimes: isTablet || orientation.current.isLandscape ? 1 : 1)
            .fixedSize(horizontal: false, vertical: true)
        } else {
            OlaList<[BookmarkableUserResource], BookmarkableUserResourceCard>(
                elements: resources,
                frame: Frame(bounds: UIScreen.main.bounds),
                content: { resource in
                    BookmarkableUserResourceCard(
                        bookmarkableUserResource: resource,
                        onToggleBookmark: onToggleBookmark,
                        onClick: {},
                        onTopicClick: onTopicClick)
                })
        }
    }
}

public class BookmarkedUserResourcesUiState: ObservableObject, Equatable {
    public static func == (lhs: BookmarkedUserResourcesUiState, rhs: BookmarkedUserResourcesUiState) -> Bool {
        lhs.state == rhs.state
    }
    
    @Published public var state: BookmarkableUserResourceState
    
    public init(state: BookmarkableUserResourceState) {
        self.state = state
    }
}

public enum BookmarkableUserResourceState : Equatable {
    public static func == (lhs: BookmarkableUserResourceState, rhs: BookmarkableUserResourceState) -> Bool {
        switch (lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.Success(let lhsUserResources), .Success(let rhsUserResources)):
            return lhsUserResources.elementsEqual(rhsUserResources, by: ==)
        default:
            return false
        }
    }
    
    case Loading
    case Success(feed: [BookmarkableUserResource])
}
