//
//  HomeTab.swift
//  home
//
//  Created by Damien Gironnet on 07/04/2023.
//

import Foundation
import SwiftUI
import common
import designsystem

///
/// Tab for Home screen
///
public struct HomeTab: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Binding var selectedTabIndex: Int

    @Environment(\.colorScheme) private var colorScheme
    
    private let index: Int
    private let title: String
    private let namespace: Namespace.ID
    
    public init(index: Int,
                selectedTabIndex: Binding<Int>,
                title: String,
                namespace: Namespace.ID) {
        self.index = index
        self._selectedTabIndex = selectedTabIndex
        self.title = title
        self.namespace = namespace
    }
    
    public var body: some View {
        if selectedTabIndex == index {
            Text(title)
                .foregroundColor(
                    colorScheme == .light ? PaletteTokens.White : localColorScheme.primaryContainer
                )
                .textStyle(TypographyTokens.TitleLarge)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .fixedSize()
                .background(
                    Capsule()
                        .foregroundColor(colorScheme == .light ? localColorScheme.primary : localColorScheme.onPrimaryContainer)
                        .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
                )
        } else {
            Text(title)
                .foregroundColor(
                    colorScheme == .light ? localColorScheme.primary : localColorScheme.Primary10
                )
                .textStyle(TypographyTokens.TitleLarge)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .fixedSize()
                .background(Capsule().foregroundColor(.clear))
        }
    }
}
