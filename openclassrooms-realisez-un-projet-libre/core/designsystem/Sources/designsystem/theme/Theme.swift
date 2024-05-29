//
//  Theme.swift
//  designsystem
//
//  Created by damien on 14/12/2022.
//

import Foundation
import SwiftUI
import common
import model
//import DevicePpi

///
/// Structure representing theme for application
///
public struct OlaTheme<Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject private var LocalGradientColors: GradientColors  = GradientColors()
    @ObservedObject private var LocalColorScheme: OlaColorScheme = OlaColorScheme.shared

    private let darkTheme: DarkThemeConfig
    private let themeBrand: ThemeBrand
    private let content: Content
    
    public init(darkTheme: DarkThemeConfig,
                themeBrand: ThemeBrand = .primary,
                @ViewBuilder content: @escaping () -> Content) {
        self.darkTheme = darkTheme
        self.themeBrand = themeBrand
        self.content = content()
        
        LocalGradientColors.top = PaletteTokens.Background
        
        switch themeBrand {
        case .primary:
            LocalColorScheme.themeBrand = .primary
            OlaColorScheme.shared.themeBrand = .primary
            LocalGradientColors.bottom = PaletteTokens.Primary99
        case .secondary:
            LocalColorScheme.themeBrand = .secondary
            OlaColorScheme.shared.themeBrand = .secondary
            LocalGradientColors.bottom = PaletteTokens.Secondary99
        case .tertiary:
            LocalColorScheme.themeBrand = .tertiary
            OlaColorScheme.shared.themeBrand = .tertiary
            LocalGradientColors.bottom = PaletteTokens.Tertiary99
        case .quaternary:
            LocalColorScheme.themeBrand = .quaternary
            OlaColorScheme.shared.themeBrand = .quaternary
            LocalGradientColors.bottom = PaletteTokens.Quaternary99
        }
        
        LocalGradientColors.container = LocalColorScheme.surface
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = LocalColorScheme.primary.uiColor()
        
        UITabBar.appearance().unselectedItemTintColor = darkTheme == .dark ?
        LocalColorScheme.primary.uiColor()
        : LocalColorScheme.primaryContainer.uiColor()
    }
    
    public var body: some View {
        content.environmentObject(LocalColorScheme).environmentObject(LocalGradientColors)
        
    }
}
