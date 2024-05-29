//
//  BookmarkButton.swift
//  ui
//
//  Created by Damien Gironnet on 25/04/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

///
/// Structure representing card bookmark button
///
public struct BookmarkButton: View {
        
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
        
    @ObservedObject private var isBookmarked: BoolObservable
    
    private let onClick: () -> Void
    private let lightColor: Color
    private let darkColor: Color
    
    public init(lightColor: Color = OlaColorScheme.shared.Primary50,
                darkColor: Color = OlaColorScheme.shared.Primary10,
                isBookmarked: BoolObservable,
                onClick: @escaping () -> Void) {
        self.lightColor = lightColor
        self.darkColor = darkColor
        self.onClick = onClick
        self.isBookmarked = isBookmarked
    }
    
    public var body: some View {
        OlaIconToggleButton(
            checked: $isBookmarked.value,
            onCheckedChange: { _ in onClick() },
            enabled: false,
            icon: {
                if isTablet {
                    OlaIcons.BookmarkBorder.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(22).adjustVerticalPadding())
                        .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30)
                } else {
                    if UIScreen.inches > 4.7 {
                        OlaIcons.BookmarkBorder
                            .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30)
                    } else {
                        OlaIcons.BookmarkBorder.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat(25).adjustVerticalPadding())
                            .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30)
                    }
                }
            },
            checkedIcon: {
                if isTablet {
                    OlaIcons.Bookmark.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(22).adjustVerticalPadding())
                        .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30)
                } else {
                    if UIScreen.inches > 4.7 {
                        OlaIcons.Bookmark
                            .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30)
                    } else {
                        OlaIcons.Bookmark.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: CGFloat(25).adjustVerticalPadding())
                            .foregroundColor(colorScheme == .light ? localColorScheme.Primary70 : localColorScheme.Primary30)
                    }
                }
            })
    }
}
