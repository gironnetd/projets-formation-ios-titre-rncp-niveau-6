//
//  ForyouPicturesGrid.swift
//  foryou
//
//  Created by Damien Gironnet on 01/11/2023.
//

import SwiftUI
import common
import designsystem
import model
import ui

public struct ForyouPicturesGrid: View {
    
    /// EnvironmentObject for orientation
    @StateObject private var orientation: Orientation = Orientation.shared
    
    /// ObservedObject for the offset depending on device type
    @ObservedObject private var offset: Offset = Offset.shared
    
    /// Environment value for color scheme
    @Environment(\.geometry) private var geometry
    
    private let pictures: [UserPicture]
    private let onTopicClick: (FollowableTopic) -> Void
    private let onToggleBookmark: (UserResource) -> Void
    
    private static var scrollViewPosition: CGFloat = -0.5

    public init(pictures: [UserPicture],
                onToggleBookmark: @escaping (UserResource) -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.pictures = pictures
        self.onTopicClick = onTopicClick
        self.onToggleBookmark = onToggleBookmark
    }
    
    public var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    VerticalStaggeredGrid<[UserPicture], ForyouPictureCard>(
                        columns: Columns(
                            columns: pictures.reversed().map { picture in
                                ColumnElement(uid: picture.uid,
                                              content: ForyouPictureCard(
                                                picture: picture,
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
