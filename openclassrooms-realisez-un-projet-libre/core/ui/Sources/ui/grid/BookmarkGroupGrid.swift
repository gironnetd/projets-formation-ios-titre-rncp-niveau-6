//
//  BookmarkGroupGrid.swift
//  ui
//
//  Created by Damien Gironnet on 01/11/2023.
//

import SwiftUI
import common
import designsystem
import model
import Combine

public struct BookmarkGroupGrid: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @StateObject private var orientation: Orientation = Orientation.shared
    
    @ObservedObject private var bookmarksState: BookmarkGroupsUiState
    /*@ObservedObject */private let frame: Frame
    
    /// ObservedObject for the offset depending on device type
    @ObservedObject private var offset: Offset = Offset.shared
    
    /// Environment value for GeometryReader
    @Environment(\.colorScheme) private var colorScheme
    
    /// Environment value for color scheme
    @Environment(\.geometry) private var geometry
    
    @State var tmpSize: CGSize = .zero
    
    private let onClick: (BookmarkGroup) -> Void
    private let onRemoveClick: (BookmarkGroup) -> Void
    private let onEditClick: (BookmarkGroup) -> Void
    private let location: BookmarkGroupLocation
        
    public init(bookmarksState: BookmarkGroupsUiState,
                location: BookmarkGroupLocation,
                onClick: @escaping (BookmarkGroup) -> Void,
                onRemoveClick: @escaping (BookmarkGroup) -> Void,
                onEditClick: @escaping (BookmarkGroup) -> Void,
                frame: Frame) {
        self.bookmarksState = bookmarksState
        self.location = location
        self.onClick = onClick
        self.onRemoveClick = onRemoveClick
        self.onEditClick = onEditClick
        self.frame = frame
    }
    
    public var body: some View {
        if case .Success(let feed) = bookmarksState.state {
            let groups = feed.filter({ $0.location == self.location })
            
            if groups.isNotEmpty || self.location == .device {
                VStack(alignment: .leading, spacing: .zero) {
                    Text(self.location.description)
                        .textStyle(TypographyTokens.HeadlineSmall)
                        .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30)
                        .padding(.bottom, isTablet ? 20 : 10)
                    
                    if isTablet || orientation.current.isLandscape {
                        VerticalStaggeredGrid<[UserAuthor], BookmarkGroupCard>(
                            columns: Columns(
                                columns: groups.map { group in
                                    ColumnElement(
                                        uid: group.id,
                                        content: BookmarkGroupCard(
                                            group: group,
                                            onClick: onClick,
                                            onRemoveClick: onRemoveClick,
                                            onEditClick: onEditClick))
                                }),
                            computationTimes: 1)
                    } else {
                        VStack(spacing: .zero) {
                            ForEach(groups, id:\.id) { group in
                                BookmarkGroupCard(
                                    group: group,
                                    onClick: onClick,
                                    onRemoveClick: onRemoveClick,
                                    onEditClick: onEditClick)
                            }
                        }
                    }
                }
                .padding(.bottom, isTablet || orientation.current.isLandscape ? geometry.safeAreaInsets.bottom : 0)
                .padding(.trailing,
                         isTablet ? 32.0 :
                            orientation.current.isPortrait ? 16.0 : geometry.safeAreaInsets.trailing)
//                .frame(width: UIScreen.main.bounds.width)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

public class BookmarkGroupsUiState: ObservableObject, Equatable {
    public static func == (lhs: BookmarkGroupsUiState, rhs: BookmarkGroupsUiState) -> Bool {
        lhs.state == rhs.state
    }
    
    @Published public var state: BookmarkGroupsState
    
    public init(state: BookmarkGroupsState) {
        self.state = state
    }
}

public enum BookmarkGroupsState: Equatable {
    public static func == (lhs: BookmarkGroupsState, rhs: BookmarkGroupsState) -> Bool {
        switch(lhs, rhs) {
        case (.Loading, .Loading):
            return true
        case (.InProgress, .InProgress):
            return true
        case (.Success(let lhsBookmarkGroups), .Success(let rhsBookmarkGroups)):
            return /*false*/ lhsBookmarkGroups == rhsBookmarkGroups
        default:
            return false
        }
    }
    
    case Loading
    case InProgress
    case Success(feed: [BookmarkGroup])
}

extension BookmarkGroupLocation: CustomStringConvertible {
    
    public init?(rawValue: String) {
        switch rawValue {
        case "on_device".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem):
            self = .device
        case "from_account".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem):
            self = .remote
        case "shared".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem):
            self = .shared
        default:
            self = .device
        }
    }
    
    public var description: String {
        switch self {
        case .device:
            return "on_device".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
        case .remote:
            return "from_account".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
        case .shared:
            return "shared".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)
        }
    }
}

