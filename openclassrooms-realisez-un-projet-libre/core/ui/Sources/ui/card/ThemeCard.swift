//
//  ThemeCard.swift
//  ui
//
//  Created by Damien Gironnet on 01/05/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

///
/// Structure representing View for theme home card
///
public struct ThemeCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var offset: Offset = Offset.shared
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    private let userTheme: UserTheme
    private let onThemeClick: (FollowableTopic) -> Void
    
    public init(userTheme: UserTheme,
                onThemeClick: @escaping (FollowableTopic) -> Void) {
        self.userTheme = userTheme
        self.onThemeClick = onThemeClick
    }
    
    public var body: some View {
        let width = (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 3 - (24.0 * 2) / 2

        DisclosureGroup(isExpanded: .constant(true), content: {
            if let themes = userTheme.themes {
                ForEach(themes.indices, id: \.self) { index in
                    Text(themes[index].name)
                        .foregroundColor(
                            colorScheme == .light ? localColorScheme.primary : localColorScheme.Primary20)
                        .textStyle(TypographyTokens.TitleLarge)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top, 8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onThemeClick(themes[index].followableTopics.first!)
                        }
                }
                .accentColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.Primary20)
                .padding(.top, 4)
            }
        }, label: {
            if isTablet {
                HStack {
                    Text(userTheme.name)
                        .foregroundColor(
                            colorScheme == .light ? localColorScheme.Primary20 : localColorScheme.onPrimaryContainer
                        )
                        .textStyle(TypographyTokens.TitleLarge)
                        .frame(alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.top, 6)
                    
                    Spacer()
                }
            } else {
                Text(userTheme.name)
                    .foregroundColor(
                        colorScheme == .light ? localColorScheme.Primary20 : localColorScheme.onPrimaryContainer
                    )
                    .textStyle(TypographyTokens.TitleLarge)
                    .frame(alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.top, 6)
            }
        })
        .accentColor(.clear)
        .frame(alignment: .center)
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding())
        .Card()
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width) :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

internal struct ThemeCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            OlaTheme(darkTheme: .systemDefault) {
                VStack {
                    ForEach(UserThemesPreviewParameterProvider.themes.indices, id: \.self) { index in
                        ThemeCard(userTheme: UserTheme(theme: UserThemesPreviewParameterProvider.themes[index]), onThemeClick: { _ in })
                    }
                }
                .padding(EdgeInsets(top: geometry.safeAreaInsets.top, leading: 16.0, bottom: geometry.safeAreaInsets.top, trailing: 16.0))
                .OlaBackground()
            }
        }
        .preferredColorScheme(.light)
    }
}
