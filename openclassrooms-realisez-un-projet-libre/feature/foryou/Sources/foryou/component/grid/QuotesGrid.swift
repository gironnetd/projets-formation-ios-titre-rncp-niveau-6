//
//  ForyouQuotesGrid.swift
//  foryou
//
//  Created by Damien Gironnet on 01/11/2023.
//

import SwiftUI
import common
import designsystem
import model
import ui

public struct ForyouQuotesGrid: View {
    
    /// EnvironmentObject for orientation
    @StateObject private var orientation: Orientation = Orientation.shared
    
    /// ObservedObject for the offset depending on device type
    @ObservedObject private var offset: Offset = Offset.shared
    
    /// Environment value for color scheme
    @Environment(\.geometry) private var geometry
    
    private let quotes: [UserQuote]
    private let onTopicClick: (FollowableTopic) -> Void
    private let onToggleBookmark: (UserResource) -> Void
    
    private static var scrollViewPosition: CGFloat = -0.5

    public init(quotes: [UserQuote],
                onToggleBookmark: @escaping (UserResource) -> Void,
                onTopicClick: @escaping (FollowableTopic) -> Void) {
        self.quotes = quotes
        self.onTopicClick = onTopicClick
        self.onToggleBookmark = onToggleBookmark
    }
    
    public var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    VerticalStaggeredGrid<[UserQuote], ForyouQuoteCard>(
                        columns: Columns(
                            columns: quotes.map { quote in
                                ColumnElement(
                                    uid: quote.uid,
                                    content: ForyouQuoteCard(
                                        quote: quote,
                                        onToggleBookmark: onToggleBookmark,
                                        onClick: {},
                                        onTopicClick: onTopicClick)) },
                            numberOfColumns: isTablet && orientation.current.isLandscape ? 3 : 2),
                        computationTimes: 1)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.leading, isTablet ? offset.value : (orientation.current.isPortrait ? (geometry.safeAreaInsets.leading) : offset.value))
                .padding(.trailing, !isTablet ? geometry.safeAreaInsets.trailing : 0.0)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
