//
//  BookmarkCardTitle.swift
//  ui
//
//  Created by Damien Gironnet on 23/10/2023.
//

import Foundation
import SwiftUI
import common
import model
import designsystem
import domain

///
/// Structure representing card title
///
public struct BookmarkCardTitle: View {
    
    @StateObject private var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.colorScheme) private var colorScheme
    
    private let title: String
    private let alignment: TextAlignment
    
    public init(title: String, alignment: TextAlignment = .leading) {
        self.title = title
        self.alignment = alignment
    }
    
    public var body: some View {
        Text(title)
            .foregroundColor(colorScheme == .light ? localColorScheme.Primary40 : localColorScheme.onPrimaryContainer)
            .textStyle(TypographyTokens.TitleLarge)
            .lineLimit(4)
            .multilineTextAlignment(alignment)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.trailing, 16)
    }
}
