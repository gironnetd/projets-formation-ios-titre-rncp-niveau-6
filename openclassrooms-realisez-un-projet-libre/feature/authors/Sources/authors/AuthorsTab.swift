//
//  AuthorsTab.swift
//  authors
//
//  Created by Damien Gironnet on 20/05/2023.
//

import Foundation
import SwiftUI
import common
import designsystem

///
/// Tab for Authors screen
///
public struct AuthorsTab: View {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Binding var selectedTabIndex: Int
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var offset: CGSize = .zero
    
    private let index: Int
    private let title: String
    
    private let selectedBackgroundColor: Color
    
    public var isActive: Bool
    private let namespace: Namespace.ID
    
    public init(index: Int,
                selectedTabIndex: Binding<Int>,
                isActive: Bool = false,
                title: String,
                selectedBackgroundColor: Color,
                namespace: Namespace.ID) {
        self.index = index
        self._selectedTabIndex = selectedTabIndex
        self.isActive = isActive
        self.title = title
        self.selectedBackgroundColor = selectedBackgroundColor
        self.namespace = namespace
    }
    
    public var body: some View {
        if selectedTabIndex == index {
            Text(title)
                .foregroundColor(
                    colorScheme == .light ? PaletteTokens.White : localColorScheme.primaryContainer
                )
                .textStyle(TypographyTokens.TitleLarge)
                .overlay(
                    isActive ?
                    Circle().foregroundColor(localColorScheme.Primary40).frame(width: 10, height: 10)
                        .offset(
                            x: self.offset.width / 2 - 6,
                            y: -self.offset.height / 2 + 6
                        ) : nil)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .foregroundColor(selectedBackgroundColor)
                        .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
                )
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) { value in
                    guard value.width != 0 && value.height != 0 else { return }
                    if value != offset {
                        DispatchQueue.main.async {
                            self.offset = value
                        }
                    }
                }
        } else {
            Text(title)
                .foregroundColor(
                    colorScheme == .light ? localColorScheme.primary : localColorScheme.Primary10
                )
                .textStyle(TypographyTokens.TitleLarge)
                .overlay(
                    isActive ?
                    Circle().foregroundColor(localColorScheme.Primary40).frame(width: 10, height: 10)
                        .offset(
                            x: self.offset.width / 2 - 6,
                            y: -self.offset.height / 2 + 6
                        ) : nil)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().foregroundColor(.clear))
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) { value in
                    guard value.width != 0 && value.height != 0 else { return }
                    if value != offset {
                        DispatchQueue.main.async {
                            self.offset = value
                        }
                    }
                }
        }
    }
}
