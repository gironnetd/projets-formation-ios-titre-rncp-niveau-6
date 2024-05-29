//
//  ForyouBiographiesGrid.swift
//  foryou
//
//  Created by Damien Gironnet on 01/11/2023.
//

import SwiftUI
import common
import designsystem
import model
import ui

public struct ForyouBiographiesGrid: View {
    
    /// EnvironmentObject for orientation
    @StateObject private var orientation: Orientation = Orientation.shared
    
    /// ObservedObject for the offset depending on device type
    @ObservedObject private var offset: Offset = Offset.shared
    
    /// Environment value for GeometryReader
    //    @Environment(\.colorScheme) private var colorScheme
    
    /// Environment value for color scheme
    @Environment(\.geometry) private var geometry
    
    private let biographies: [UserBiography]
    private let onTopicClick: (FollowableTopic) -> Void
    private let onToggleBookmark: (UserResource) -> Void
    
    private static var scrollViewPosition: CGFloat = -0.5
    
    public init(biographies: [UserBiography],
                onToggleBookmark: @escaping (UserResource) -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.biographies = biographies
        self.onTopicClick = onTopicClick
        self.onToggleBookmark = onToggleBookmark
    }
    
    public var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    VerticalStaggeredGrid<[UserBiography], ForyouBiographyCard>(
                        columns: Columns(
                            columns: biographies.reversed().map { biography in
                                ColumnElement(uid: biography.uid,
                                              content: ForyouBiographyCard(
                                                biography: biography,
                                                onToggleBookmark: onToggleBookmark,
                                                onClick: {},
                                                onTopicClick: onTopicClick)) },
                            numberOfColumns: isTablet && orientation.current.isLandscape ? 3 : 2),
                        computationTimes: 1)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.leading, isTablet ? offset.value : (orientation.current.isPortrait ? geometry.safeAreaInsets.leading : offset.value))
                .padding(.trailing, !isTablet ? geometry.safeAreaInsets.trailing : 0.0)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

