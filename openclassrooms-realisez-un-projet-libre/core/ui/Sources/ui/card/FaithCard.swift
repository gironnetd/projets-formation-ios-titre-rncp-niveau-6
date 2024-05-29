//
//  FaithCard.swift
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
/// Structure representing View for faith home card
///
public struct FaithCard: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var offset: Offset = Offset.shared
    
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    private let userFaith: UserFaith
    
    private let onFaithClick: (FollowableTopic) -> Void
    
    public init(userFaith: UserFaith,
                onFaithClick: @escaping (FollowableTopic) -> Void) {
        self.userFaith = userFaith
        self.onFaithClick = onFaithClick
    }
    
    public var body: some View {
        let width = (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing) / 3 - (24.0 * 2) / 2

        DisclosureGroup(isExpanded: .constant(true), content: {
            if let movements = userFaith.movements {
                ForEach(movements.indices, id: \.self) { index in
                    if let subMovements = movements[index].movements {
                        DisclosureGroup(isExpanded: .constant(true), content: {
                            ForEach(subMovements.indices, id: \.self) { index in
                                Text(subMovements[index].name)
                                    .foregroundColor(
                                        colorScheme == .light ?
                                        localColorScheme.primary : localColorScheme.Primary20)
                                    .textStyle(TypographyTokens.TitleLarge)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                    .padding(.leading, 16)
                                    .padding(.top, 8)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        onFaithClick(subMovements[index].followableTopics.first!)
                                    }
                            }
                        }, label: {
                            if isTablet {
                                HStack {
                                    Text(movements[index].name)
                                        .foregroundColor(
                                            colorScheme == .light ?
                                            localColorScheme.Primary20 : localColorScheme.onPrimaryContainer)
                                        .textStyle(TypographyTokens.TitleLarge)
                                        .frame(alignment: .leading)
                                        .padding(.leading, 10)
                                        .padding(.top, 6)
                                    
                                    Spacer()
                                }
                            } else {
                                Text(movements[index].name)
                                    .foregroundColor(
                                        colorScheme == .light ?
                                        localColorScheme.Primary20 : localColorScheme.onPrimaryContainer)
                                    .textStyle(TypographyTokens.TitleLarge)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 10)
                                    .padding(.top, 6)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        onFaithClick(movements[index].followableTopics.first!)
                                    }
                            }
                        }).padding(.leading, 30)
                    } else {
                        Text(movements[index].name)
                            .foregroundColor(
                                colorScheme == .light ?
                                localColorScheme.primary : localColorScheme.Primary20)
                            .textStyle(TypographyTokens.TitleLarge)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(.top, 10)
                            .padding(.leading, 30)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onFaithClick(movements[index].followableTopics.first!)
                            }
                    }
                }
                .accentColor(.clear)
                .padding(.top, 4)
            }
        }, label: {
            if isTablet {
                HStack {
                    Text(userFaith.name)
                        .foregroundColor(
                            colorScheme == .light ?
                            localColorScheme.onPrimaryContainer : localColorScheme.onPrimaryContainer)
                        .textStyle(TypographyTokens.TitleLarge)
                        .frame(alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.top, 6)
                    
                    Spacer()
                }
            } else {
                Text(userFaith.name)
                    .foregroundColor(
                        colorScheme == .light ?
                        localColorScheme.onPrimaryContainer : localColorScheme.onPrimaryContainer)
                    .textStyle(TypographyTokens.TitleLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .frame(alignment: .leading)
                    .padding(.leading, 10)
                    .padding(.top, 6)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onFaithClick(userFaith.followableTopics.first!)
                    }
            }
        })
        .accentColor(.clear)
        .frame(alignment: .center)
        .padding([.horizontal, .vertical], CGFloat(isTablet ? 24.0 : 20.0).adjustVerticalPadding())
        .Card()
        .frame(width: isTablet ? (orientation.isPortrait ?
                                  ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) : width)
                :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}

internal struct FaithCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            OlaTheme(darkTheme: .systemDefault) {
                VStack {
                    ForEach(UserFaithsPreviewParameterProvider.faiths[0..<1].indices, id: \.self) { index in
                        FaithCard(userFaith: UserFaith(faith: UserFaithsPreviewParameterProvider.faiths[0..<1][index]), onFaithClick: { _ in })
                    }
                }
                .padding(EdgeInsets(top: geometry.safeAreaInsets.top, leading: 16.0, bottom: geometry.safeAreaInsets.top, trailing: 16.0))
                .OlaBackground()
            }
        }
        .preferredColorScheme(.light)
    }
}
