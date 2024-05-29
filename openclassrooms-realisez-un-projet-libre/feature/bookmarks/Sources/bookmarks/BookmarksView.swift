//
//  BookmarksView.swift
//  bookmarks
//
//  Created by Damien Gironnet on 22/10/2023.
//

import Foundation
import SwiftUI
import common
import designsystem
import ui
import model
import navigation

public struct BookmarksView: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    /// ObservedObject for the offset depending on device type
    @ObservedObject private var offset: Offset = Offset.shared
        
    /// EnvironmentObject for orientation
    @StateObject private var orientation: Orientation = Orientation.shared
    
    @ObservedObject var viewModel: BookmarksViewModel
    @ObservedObject var group: BookmarkGroup
    @ObservedObject private var frame: Frame
    
    @Environment(\.geometry) private var geometry

    @State var tmpSize: CGSize = .zero
    
    public init(_ group: BookmarkGroup, frame: Frame) {
        self.frame = frame
        self.group = group
        self.viewModel = BookmarksViewModel.shared
        self.viewModel.bookmarksFeed(group: group)
    }
    
    public var body: some View {
        if case .Success(let groups) = viewModel.bookmarksUiState.state {
            VStack(alignment: .leading, spacing: .zero) {
                if let group = groups.first(where: { $0.id == group.id }) {
                    VStack(alignment: .leading) {
                        Text(group.id != "-1" ? group.directoryName : "reading_list".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem))
                            .foregroundColor(localColorScheme.onPrimaryContainer)
                            .textStyle(TypographyTokens.TitleLarge)
                            .lineLimit(6)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if group.shortDescription.isNotEmpty {
                            Text(group.shortDescription)
                                .foregroundColor(localColorScheme.onPrimaryContainer)
                                .textStyle(TypographyTokens.BodyLarge)
                                .lineLimit(4)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.top, 6)
                    .padding(.trailing, isTablet ? 16.0 : orientation.current.isPortrait ? 0.0 : geometry.safeAreaInsets.trailing)
                    .padding(.bottom, 10)
                    .padding(.leading, !isTablet && orientation.current.isPortrait ? geometry.safeAreaInsets.leading : 0.0)
                    
                    let resourcesState = viewModel.resourcesUiState.state
                    if case .Success(let resources) = resourcesState, resources.isNotEmpty {
                        if isTablet || orientation.current.isLandscape  {
                            BookmarkableUserResourcesGrid(
                                resources: resources,
                                onToggleBookmark: viewModel.onToggleBookmark,
                                onTopicClick: viewModel.onTopicClick)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, isTablet ? geometry.safeAreaInsets.bottom : 0.0)
                        } else {
                            OlaList<[BookmarkableUserResource], BookmarkableUserResourceCard>(
                                elements: resources,
                                frame: Frame(bounds: UIScreen.main.bounds),
                                content: { resource in
                                    BookmarkableUserResourceCard(
                                        bookmarkableUserResource: resource,
                                        onToggleBookmark: viewModel.onToggleBookmark,
                                        onClick: {},
                                        onTopicClick: viewModel.onTopicClick)
                                })
                        }
                    }
                }
            }
            .animation(nil, value: viewModel.resourcesUiState.state != .Loading)
            .padding(.leading, isTablet ? Offset.shared.value : (orientation.current.isPortrait ? 0.0 : Offset.shared.value))
            .frame(width: UIScreen.main.bounds.width)
            .modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) { value in
                guard value.width != 0 && value.height != 0 else { return }
                tmpSize = value
                
                DispatchQueue.main.async {
                    if tmpSize == value && frame.bounds.size != value {
                        frame.bounds.size = value
                        frame.objectWillChange.send()
                        if LoadingWheel.shared.isShowing { LoadingWheel.isShowing(false) }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
