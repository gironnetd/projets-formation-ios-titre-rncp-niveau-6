//
//  Card.swift
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
/// Structure representing card for Ui in application
///
public struct CardStyle: ViewModifier {
    
    @StateObject var localColorScheme: OlaColorScheme = OlaColorScheme.shared
    @Environment(\.orientation) private var orientation
    @Environment(\.geometry) private var geometry
    @Environment(\.colorScheme) private var colorScheme
    
    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(
                        colorScheme == .light ? PaletteTokens.White :
                            localColorScheme.primaryContainer
                    ).brightness(colorScheme == .light ? 0.0 : -0.03)
                    .shadow(color: localColorScheme.Primary70.opacity(0.12), radius: 4, x: 1, y: 2)
                    .brightness(colorScheme == .light ? 0.0 : -0.01))
            .padding(.bottom, CGFloat(isTablet ? 20.0 : 16.0).adjustVerticalPadding())
    }
}

public extension View {
    func Card() -> some View {
        modifier(CardStyle())
    }
}
