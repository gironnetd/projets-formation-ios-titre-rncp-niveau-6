//
//  BookmarkGroupCard.swift
//  ui
//
//  Created by Damien Gironnet on 20/10/2023.
//

import SwiftUI
import model
import designsystem
import common

public struct BookmarkGroupCard: View {

    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    
    @ObservedObject private var offset: Offset = Offset.shared
    @ObservedObject private var group: BookmarkGroup
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    
    @State var showsAlwaysPopover: Bool = false
    
    private let onClick: (BookmarkGroup) -> Void
    private let onRemoveClick: (BookmarkGroup) -> Void
    private let onEditClick: (BookmarkGroup) -> Void
    
    public init(group: BookmarkGroup,
                onClick: @escaping (BookmarkGroup) -> Void,
                onRemoveClick: @escaping (BookmarkGroup) -> Void,
                onEditClick: @escaping (BookmarkGroup) -> Void) {
        self.group = group
        self.onClick = onClick
        self.onRemoveClick = onRemoveClick
        self.onEditClick = onEditClick
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(group.id != "-1" ? group.directoryName : "reading_list".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)).textStyle(TypographyTokens.TitleMedium)
                    .foregroundColor(localColorScheme.onPrimaryContainer)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if group.id == "-1" {
                    OlaIcons.Padlock.foregroundColor(localColorScheme.onPrimaryContainer)
                } else {
                    OlaIcons.Menu
                        .foregroundColor(localColorScheme.onPrimaryContainer)
                        .padding(.top, isTablet ? 8 : 0)
                        .frame(width: 27, height: 27)
                        .background(colorScheme == .light ? PaletteTokens.White : localColorScheme.primaryContainer)
                        .brightness(colorScheme == .light ? 0.0 : -0.03)
                        .onTapGesture { showsAlwaysPopover = true }
                        .alwaysPopover(isPresented: $showsAlwaysPopover) {
                            VStack(alignment: .leading, spacing: 6) {
                                Button(action: { onEditClick(group) },
                                       label: {
                                    HStack {
                                        Text("edit_list_info".localizedString(
                                            identifier: Locale.current.identifier,
                                            bundle: Bundle.designsystem))
                                            .foregroundColor(localColorScheme.onPrimaryContainer)
                                            .textStyle(TypographyTokens.BodyLarge)
                                    }
                                })
                                
                                Button(action: { 
                                    showsAlwaysPopover = false
                                    onRemoveClick(group) },
                                       label: {
                                    Text("delete_from_list".localizedString(
                                        identifier: Locale.current.identifier,
                                        bundle: Bundle.designsystem))
                                        .foregroundColor(localColorScheme.onPrimaryContainer)
                                        .textStyle(TypographyTokens.BodyLarge)
                                        .contentShape(Rectangle())
                                })
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(colorScheme == .light ?
                                        PaletteTokens.White : localColorScheme.primaryContainer)
                            .brightness(colorScheme == .light ? 0.0 : -0.03)
                        }
                }
            }
            
            HStack(alignment: .bottom) {
                Text("\(group.bookmarks.count) " + "bookmarks".localizedString(identifier: Locale.current.identifier, bundle: Bundle.designsystem)).textStyle(TypographyTokens.HeadlineSmall)
                    .foregroundColor(localColorScheme.primary)
                    .frame(alignment: .bottom)
                
                Spacer()
                
                OlaIcons.ArrowRight.foregroundColor(localColorScheme.primary).hidden()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
        .Card()
        .onTapGesture {
            if group.bookmarks.isNotEmpty  && !showsAlwaysPopover {
                onClick(group)
            }
        }
        .frame(width: isTablet ?
               ((UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 24.0 * 2) / 2) :
                (orientation.isPortrait ?
                 (UIScreen.main.bounds.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing) :
                    (UIScreen.main.bounds.size.width - offset.value - geometry.safeAreaInsets.trailing - 12.0 * 2) / 2))
        .fixedSize(horizontal: offset.value == 0.0 ? false : true, vertical: true)
    }
}
